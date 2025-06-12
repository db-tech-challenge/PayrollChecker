#!/bin/bash

TEAM=$1
TEST_DIR="test-$TEAM"

# Read status files with defaults
COMPILE_STATUS=$(cat $TEST_DIR/compile.status 2>/dev/null || echo "1")
RUN_STATUS=$(cat $TEST_DIR/run.status 2>/dev/null || echo "1")
TEST_STATUS=$(cat $TEST_DIR/test.status 2>/dev/null || echo "1")

# Ensure we have numeric values
COMPILE_STATUS=${COMPILE_STATUS:-1}
RUN_STATUS=${RUN_STATUS:-1}
TEST_STATUS=${TEST_STATUS:-1}

# Get git info
cd $TEST_DIR
COMMIT_HASH=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
COMMIT_MESSAGE=$(git log -1 --pretty=format:'%s' 2>/dev/null || echo "unknown")
COMMIT_AUTHOR=$(git log -1 --pretty=format:'%an' 2>/dev/null || echo "unknown")
COMMIT_DATE=$(git log -1 --pretty=format:'%ai' 2>/dev/null || echo "unknown")
cd ..

# Parse automatic test results
AUTO_TESTS_JSON="[]"
TESTS_RUN=0
TESTS_FAILED=0
TESTS_PASSED=0

if [ -f "$TEST_DIR/target/surefire-reports/TEST-com.payroll.PayrollApplicationTest.xml" ]; then
    AUTO_TESTS_JSON=$(python3 -c "
import xml.etree.ElementTree as ET
import json
import sys

try:
    tree = ET.parse('$TEST_DIR/target/surefire-reports/TEST-com.payroll.PayrollApplicationTest.xml')
    root = tree.getroot()

    tests = []
    for testcase in root.findall('testcase'):
        name = testcase.get('name', 'unknown')
        time = float(testcase.get('time', '0'))

        # Check for failure or error
        failure = testcase.find('failure')
        error = testcase.find('error')

        if failure is not None:
            status = 'FAILED'
            message = failure.get('message', 'Test failed')
        elif error is not None:
            status = 'ERROR'
            message = error.get('message', 'Test error')
        else:
            status = 'PASSED'
            message = 'Test passed'

        tests.append({
            'name': name,
            'status': status,
            'time': time,
            'message': message,
            'type': 'automatic'
        })

    print(json.dumps(tests, indent=2))
except Exception as e:
    print('[]')
" 2>/dev/null || echo "[]")

    # Count totals
    TESTS_RUN=$(echo "$AUTO_TESTS_JSON" | jq length 2>/dev/null || echo "0")
    TESTS_PASSED=$(echo "$AUTO_TESTS_JSON" | jq '[.[] | select(.status == "PASSED")] | length' 2>/dev/null || echo "0")
    TESTS_FAILED=$(echo "$AUTO_TESTS_JSON" | jq '[.[] | select(.status == "FAILED" or .status == "ERROR")] | length' 2>/dev/null || echo "0")
fi

# Load manual tests
MANUAL_TESTS_JSON="[]"
if [ -f "manual-tests.json" ]; then
    MANUAL_TESTS_JSON=$(jq -r ".$TEAM // {} | to_entries | map({name: .value.name, status: .value.status, description: .value.description, reviewer: .value.reviewer, notes: .value.notes, type: \"manual\"})" manual-tests.json 2>/dev/null || echo "[]")
fi

# Combine tests and sort by name
ALL_TESTS_JSON=$(echo "$AUTO_TESTS_JSON $MANUAL_TESTS_JSON" | jq -s 'add | sort_by(.name)' 2>/dev/null || echo "[]")

# Count manual tests
MANUAL_TOTAL=$(echo "$MANUAL_TESTS_JSON" | jq length 2>/dev/null || echo "0")
MANUAL_PASSED=$(echo "$MANUAL_TESTS_JSON" | jq '[.[] | select(.status == "PASSED")] | length' 2>/dev/null || echo "0")
MANUAL_PENDING=$(echo "$MANUAL_TESTS_JSON" | jq '[.[] | select(.status == "PENDING")] | length' 2>/dev/null || echo "0")
MANUAL_FAILED=$(echo "$MANUAL_TESTS_JSON" | jq '[.[] | select(.status == "FAILED")] | length' 2>/dev/null || echo "0")

# Ensure numeric values
TESTS_RUN=${TESTS_RUN:-0}
TESTS_FAILED=${TESTS_FAILED:-0}
TESTS_PASSED=${TESTS_PASSED:-0}
MANUAL_TOTAL=${MANUAL_TOTAL:-0}
MANUAL_PASSED=${MANUAL_PASSED:-0}
MANUAL_PENDING=${MANUAL_PENDING:-0}
MANUAL_FAILED=${MANUAL_FAILED:-0}

# Calculate score
SCORE=0
if [ "$COMPILE_STATUS" = "0" ]; then SCORE=$((SCORE + 20)); fi
if [ "$RUN_STATUS" = "0" ]; then SCORE=$((SCORE + 10)); fi
if [ "$TEST_STATUS" = "0" ]; then SCORE=$((SCORE + 40)); fi

# Manual tests bonus (30 points max)
if [ "$MANUAL_TOTAL" -gt 0 ]; then
    MANUAL_SCORE=$((MANUAL_PASSED * 30 / MANUAL_TOTAL))
    SCORE=$((SCORE + MANUAL_SCORE))
fi

# Generate JSON
cat << EOF
{
  "team": "$TEAM",
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "commit": {
    "hash": "$COMMIT_HASH",
    "message": "$COMMIT_MESSAGE",
    "author": "$COMMIT_AUTHOR",
    "date": "$COMMIT_DATE"
  },
  "results": {
    "compilation": {
      "success": $([ "$COMPILE_STATUS" = "0" ] && echo "true" || echo "false"),
      "status": $COMPILE_STATUS
    },
    "execution": {
      "success": $([ "$RUN_STATUS" = "0" ] && echo "true" || echo "false"),
      "status": $RUN_STATUS
    },
    "tests": {
      "automatic": {
        "success": $([ "$TEST_STATUS" = "0" ] && echo "true" || echo "false"),
        "total": $TESTS_RUN,
        "passed": $TESTS_PASSED,
        "failed": $TESTS_FAILED
      },
      "manual": {
        "total": $MANUAL_TOTAL,
        "passed": $MANUAL_PASSED,
        "failed": $MANUAL_FAILED,
        "pending": $MANUAL_PENDING
      },
      "all_tests": $ALL_TESTS_JSON
    },
    "score": {
      "total": $SCORE,
      "max": 100,
      "percentage": $SCORE
    }
  }
}
EOF