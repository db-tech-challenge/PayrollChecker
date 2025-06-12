#!/usr/bin/env python3

import sys, os, json, xml.etree.ElementTree as ET
from datetime import datetime

def read_status(path, default=1):
    try:
        return int(open(path).read().strip())
    except:
        return default

def parse_tests(xml_path):
    if not os.path.exists(xml_path):
        return []
    try:
        tree = ET.parse(xml_path)
        root = tree.getroot()
        tests = []
        for t in root.findall('testcase'):
            name = t.get('name', 'unknown')
            time = float(t.get('time', '0'))
            status = 'PASSED'
            msg = 'Test passed'
            if t.find('failure') is not None:
                status = 'FAILED'
                msg = t.find('failure').get('message', 'failed')
            elif t.find('error') is not None:
                status = 'ERROR'
                msg = t.find('error').get('message', 'error')
            tests.append({
                "name": name,
                "status": status,
                "time": time,
                "message": msg,
                "type": "automatic"
            })
        return tests
    except Exception:
        return []

def parse_manual_tests(team, manual_path='manual-tests.json'):
    if not os.path.exists(manual_path): return []
    try:
        data = json.load(open(manual_path))
        if team not in data: return []
        tests = data[team].values()
        return [
            {
                "name": t.get("name"),
                "status": t.get("status", "PENDING"),
                "description": t.get("description", ""),
                "reviewer": t.get("reviewer", ""),
                "notes": t.get("notes", ""),
                "type": "manual"
            } for t in tests
        ]
    except:
        return []

def main():
    team = sys.argv[1]
    test_dir = f'test-{team}'
    xml_path = os.path.join(test_dir, 'target/surefire-reports/TEST-com.payroll.PayrollApplicationTest.xml')

    compile_status = read_status(f'{test_dir}/compile.status')
    run_status     = read_status(f'{test_dir}/run.status')
    test_status    = read_status(f'{test_dir}/test.status')

    auto_tests = parse_tests(xml_path)
    manual_tests = parse_manual_tests(team)

    all_tests = sorted(auto_tests + manual_tests, key=lambda t: t['name'])
    score = 0
    if compile_status == 0: score += 20
    if run_status == 0: score += 10
    if test_status == 0: score += 40
    if manual_tests:
        passed = len([t for t in manual_tests if t['status'] == 'PASSED'])
        score += int(passed * 30 / len(manual_tests))

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
        "timestamp": datetime.utcnow().isoformat() + "Z",
        "commit": {
            "hash": commit_hash,
            "message": commit_msg,
            "author": commit_author,
            "date": commit_date
        },
        "results": {
            "compilation": {"success": compile_status == 0, "status": compile_status},
            "execution":   {"success": run_status == 0,     "status": run_status},
            "tests": {
                "automatic": {
                    "success": test_status == 0,
                    "total": len(auto_tests),
                    "passed": len([t for t in auto_tests if t['status'] == 'PASSED']),
                    "failed": len([t for t in auto_tests if t['status'] in ['FAILED', 'ERROR']])
                },
                "manual": {
                    "total": len(manual_tests),
                    "passed": len([t for t in manual_tests if t['status'] == 'PASSED']),
                    "failed": len([t for t in manual_tests if t['status'] == 'FAILED']),
                    "pending": len([t for t in manual_tests if t['status'] == 'PENDING'])
                },
                "all_tests": all_tests
            },
            "score": {
                "total": score,
                "max": 100,
                "percentage": score
            }
        }
    }

    os.makedirs("results", exist_ok=True)
    with open(f'results/{team}.json', 'w') as f:
        json.dump(result, f, indent=2)

if __name__ == '__main__':
    main()
