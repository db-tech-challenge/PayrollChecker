#!/bin/bash

source .env

TEAM="$1"

if [[ -z "$TEAM" ]]; then
    echo "Error: Team name is required"
    echo "Usage: $0 <team-name>"
    exit 1
fi

if [[ ! "$TEAM" =~ ^(alpha|beta|gamma|delta)$ ]]; then
    echo "Error: Invalid team name. Must be one of: alpha, beta, gamma, delta"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "${PROJECT_DIR}"

echo "Cloning PayrollCalculator for team: $TEAM"
mkdir -p "test-$TEAM"
rm -rf "test-$TEAM"

PAYROLL_LOCAL_REPO="${PAYROLL_LOCAL_REPO:-}"

if [ -z "$PAYROLL_LOCAL_REPO" ]; then
  echo "Cloning from GitHub..."
  git clone https://github.com/db-tech-challenge/PayrollCalculator.git "test-$TEAM"
else
  echo "Using local repository: $PAYROLL_LOCAL_REPO"
  cp -r "${PAYROLL_LOCAL_REPO}" "test-$TEAM"
fi


cd "test-$TEAM"


if git checkout "$TEAM" > checkout.log 2>&1 ; then
  echo "Successfully checked out branch: $TEAM"
  git pull origin "$TEAM"
  echo "Updated to latest commit: $(git rev-parse HEAD)"

  mkdir -p src/test/java/com/payroll
  cp ../tests/PayrollApplicationTest.java src/test/java/com/payroll/

  echo "Compiling..."
  mvn clean compile > compile.log 2>&1
  COMPILE_STATUS=$?
  echo $COMPILE_STATUS > compile.status

  echo "Compiling tests..."
  mvn clean test-compile > test-compile.log 2>&1
  TEST_COMPILE_STATUS=$?
  echo $TEST_COMPILE_STATUS > test-compile.status

  if [ $COMPILE_STATUS -eq 0 ]; then
    echo "Running app..."
    mvn exec:java -Dexec.mainClass="com.payroll.PayrollApplication" > run.log 2>&1
    RUN_STATUS=$?
    echo $RUN_STATUS > run.status
    if [ $RUN_STATUS -eq 0 ]; then
      echo "Running tests..."
      mvn test > test.log 2>&1
      TEST_STATUS=$?
      echo $TEST_STATUS > test.status
    else
      echo "Skipping tests due to execution failure"
      TEST_STATUS=1
      echo 1 > test.status
    fi
  else
      echo "Skipping execution due to compilation failure"
      RUN_STATUS=1
      echo 1 > run.status
  fi
else
  echo "Branch $TEAM not found"
  echo 1 > compile.status
  echo 1 > run.status
  echo "Branch checkout failed" > compile.log
  echo "Branch checkout failed" > run.log
fi

echo ""
echo "═══════════════ TEST RESULTS ═══════════════"
printf "Compilation Status......... %s\n" "$COMPILE_STATUS"
printf "Test compilation Status.... %s\n" "$TEST_COMPILE_STATUS"
printf "Run Status................. %s\n" "$RUN_STATUS"
printf "Test Status................ %s\n" "$TEST_STATUS"
echo "════════════════════════════════════════════"

exit 0