include .env

PYTHON ?= python3

# Remote webhook triggers for GitHub Actions
alpha:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "alpha"}' \
		https://api.github.com/repos/db-tech-challenge/PayrollChecker/dispatches

beta:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "beta"}' \
		https://api.github.com/repos/db-tech-challenge/PayrollChecker/dispatches

gamma:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "gamma"}' \
		https://api.github.com/repos/db-tech-challenge/PayrollChecker/dispatches

delta:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "delta"}' \
		https://api.github.com/repos/db-tech-challenge/PayrollChecker/dispatches

# Local testing with compile/run/test + result generation
test-local:
	@echo "Testing team: $(TEAM)"
	@rm -rf test-$(TEAM)
	@git clone https://github.com/db-tech-challenge/PayrollCalculator.git test-$(TEAM)
	@cd test-$(TEAM) && git checkout $(TEAM)
	@mkdir -p test-$(TEAM)/src/test/java/com/payroll
	@cp tests/PayrollApplicationTest.java test-$(TEAM)/src/test/java/com/payroll/
	@echo "Compiling..."
	@cd test-$(TEAM) && mvn clean compile > compile.log 2>&1; echo $$? > compile.status
	@echo "Running application..."
	@cd test-$(TEAM) && mvn exec:java -Dexec.mainClass="com.payroll.PayrollApplication" > run.log 2>&1; echo $$? > run.status
	@echo "Running tests..."
	@cd test-$(TEAM) && mvn test > test.log 2>&1; echo $$? > test.status
	@$(MAKE) generate-json TEAM=$(TEAM)

# Generate JSON report using Python
generate-json:
	@echo "Generating JSON results for $(TEAM)..."
	@mkdir -p results
	@$(PYTHON) scripts/generate-results.py $(TEAM)

	@echo "Results saved to results/$(TEAM).json"

# Per-team shortcuts
test-alpha-local:
	@$(MAKE) test-local TEAM=alpha

test-beta-local:
	@$(MAKE) test-local TEAM=beta

test-gamma-local:
	@$(MAKE) test-local TEAM=gamma

test-delta-local:
	@$(MAKE) test-local TEAM=delta

# Run all teams locally and aggregate results
test-all-local:
	@$(MAKE) test-alpha-local
	@$(MAKE) test-beta-local
	@$(MAKE) test-gamma-local
	@$(MAKE) test-delta-local
	@echo "Combining all results into all-teams.json..."
	@mkdir -p docs/results
	@$(PYTHON) -c 'import json, glob; files = glob.glob("results/*.json"); all_data = [json.load(open(f)) for f in files]; json.dump(all_data, open("docs/results/all-teams.json", "w"), indent=2)'
	@cp -r results docs/

# Clean generated files
clean:
	@echo "Cleaning up..."
	@rm -rf test-alpha test-beta test-gamma test-delta results docs/results
	@echo "Cleanup complete."
