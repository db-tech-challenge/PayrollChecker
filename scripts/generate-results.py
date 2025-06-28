#!/usr/bin/env python3

import sys, os, json, xml.etree.ElementTree as ET
from datetime import datetime, UTC
from collections import defaultdict

def read_status(path, default=1):
    try:
        return int(open(path).read().strip())
    except:
        return default

def parse_tests(xml_path):
    print(f"Looking for XML at: {xml_path}")
    print(f"XML file exists: {os.path.exists(xml_path)}")

    if os.path.exists(xml_path):
        print(f"XML file size: {os.path.getsize(xml_path)} bytes")

    surefire_dir = os.path.dirname(xml_path)
    if os.path.exists(surefire_dir):
        print(f"Files in {surefire_dir}: {os.listdir(surefire_dir)}")
    else:
        print(f"Surefire directory does not exist: {surefire_dir}")

    if not os.path.exists(xml_path):
        return []

    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()

        tasks = defaultdict(list)

        for t in root.findall('testcase'):
            name = t.get('name', 'unknown')
            time = float(t.get('time', '0'))

            try:
                if name.startswith('test_'):
                    task_id = name.split('_')[1]
                    if len(task_id) == 2 and task_id.isdigit():
                        pass
                    else:
                        print(f"Warning: Invalid task_id format in test name: {name}")
                        continue
                else:
                    print(f"Warning: Test name doesn't start with 'test_': {name}")
                    continue
            except IndexError:
                print(f"Warning: Cannot extract task_id from test name: {name}")
                continue

            status = 'PASSED'
            if t.find('failure') is not None or t.find('error') is not None:
                status = 'FAILED'

            tasks[task_id].append({
                "name": name,
                "status": status,
                "time": time
            })

        result_tasks = []
        for task_id, tests in tasks.items():
            passed_count = len([t for t in tests if t['status'] == 'PASSED'])
            total_count = len(tests)
            progress = round((passed_count / total_count) * 100) if total_count > 0 else 0

            result_tasks.append({
                "task_id": task_id,
                "progress": progress,
                "type": "automatic"
            })

        print(f"Parsed {len(result_tasks)} task groups from XML")
        return result_tasks

    except Exception as e:
        print(f"Error parsing XML: {e}")
        return []

def parse_manual_tests(team, manual_path='data/manual-tests.json'):
    if not os.path.exists(manual_path):
        return []

    try:
        data = json.load(open(manual_path))

        if team not in data:
            print(f"No data found for team: {team}")
            return []

        team_data = data[team]
        result_tasks = []

        for task_id in sorted(team_data.keys()):
            result_tasks.append({
                "task_id": task_id,
                "progress": team_data[task_id],
                "type": "manual"
            })

        print(f"Parsed {len(result_tasks)} manual tasks for team {team}")
        return result_tasks

    except Exception as e:
        print(f"Error parsing manual tests: {e}")
        return []

def main():
    team = sys.argv[1]
    test_dir = f'test-{team}'
    xml_path = os.path.join(test_dir, 'target/surefire-reports/TEST-com.payroll.PayrollApplicationTest.xml')

    print(f"Looking for status files in: {test_dir}")
    print(f"Files in {test_dir}:", os.listdir(test_dir) if os.path.exists(test_dir) else "Directory not found")

    compile_status = read_status(f'{test_dir}/compile.status')
    run_status     = read_status(f'{test_dir}/run.status')
    test_status    = read_status(f'{test_dir}/test.status')

    print(f"Raw statuses - compile: {compile_status}, run: {run_status}, test: {test_status}")

    compilation_success = compile_status == 0
    execution_success = run_status == 0
    should_show_tests = compilation_success and execution_success

    if not compilation_success:
        build_status = "compilation_failed"
    elif not execution_success:
        build_status = "execution_failed"
    else:
        build_status = "success"

    if should_show_tests:
        auto_tasks = parse_tests(xml_path)
        manual_tasks = parse_manual_tests(team)
    else:
        auto_tasks = []
        manual_tasks = []

    all_tasks_dict = {}

    for task in auto_tasks:
        all_tasks_dict[task['task_id']] = task

    for task in manual_tasks:
        task_id = task['task_id']
        if task_id in all_tasks_dict:
            auto_task = all_tasks_dict[task_id]
            combined_progress = round((auto_task['progress'] + task['progress']) / 2)
            all_tasks_dict[task_id] = {
                "task_id": task_id,
                "progress": combined_progress,
                "type": "combined"
            }
        else:
            all_tasks_dict[task_id] = task

    all_tasks = sorted(all_tasks_dict.values(), key=lambda t: t['task_id'])

    score = 0
    if compilation_success:
        score += 20
    if execution_success:
        score += 10
    if should_show_tests and test_status == 0:
        score += 40

    if all_tasks:
        total_progress = sum(task['progress'] for task in all_tasks)
        max_progress = len(all_tasks) * 100
        task_score = int((total_progress / max_progress) * 30) if max_progress > 0 else 0
        score += task_score

    try:
        os.chdir(test_dir)
        commit_hash = os.popen('git rev-parse HEAD').read().strip()
        commit_msg = os.popen('git log -1 --pretty=%s').read().strip()
        commit_author = os.popen('git log -1 --pretty=%an').read().strip()
        commit_date = os.popen('git log -1 --pretty=%ai').read().strip()
        os.chdir('..')
    except:
        commit_hash = commit_msg = commit_author = commit_date = 'unknown'

    result = {
        "team": team,
        "timestamp": datetime.now(UTC).isoformat(),
        "commit": {
            "hash": commit_hash,
            "message": commit_msg,
            "author": commit_author,
            "date": commit_date
        },
        "build_status": build_status,
        "should_show_tests": should_show_tests,
        "results": {
            "compiled": compilation_success,
            "executed": execution_success,
            "tasks": all_tasks,
            "score": {
                "total": score,
                "max": 100,
                "percentage": score
            }
        }
    }

    os.makedirs("target", exist_ok=True)
    with open(f'target/{team}.json', 'w') as f:
        json.dump(result, f, indent=2)

if __name__ == '__main__':
    main()