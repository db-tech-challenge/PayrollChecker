include .env

# Remote webhook triggers
alpha:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "alpha"}' \
		https://api.github.com/repos/t0lia/payroll-checker/dispatches

beta:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "beta"}' \
		https://api.github.com/repos/t0lia/payroll-checker/dispatches

gamma:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "gamma"}' \
		https://api.github.com/repos/t0lia/payroll-checker/dispatches

delta:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "delta"}' \
		https://api.github.com/repos/t0lia/payroll-checker/dispatches

# Local testing with JSON results
test-local:
	@echo "Testing team: $(TEAM)"
	@rm -rf test-$(TEAM)
	@git clone https://github.com/db-tech-challenge/PayrollCalculator.git test-$(TEAM)
	@cd test-$(TEAM) && git checkout $(TEAM)
	@mkdir -p test-$(TEAM)/src/test/java/com/payroll
	@cp tests/PayrollApplicationTest.java test-$(TEAM)/src/test/java/com/payroll/
	@echo "Compiling..."
	@cd test-$(TEAM) && mvn clean compile > compile.log 2>&1; echo $? > compile.status
	@echo "Running application..."
	@cd test-$(TEAM) && timeout 30s mvn exec:java -Dexec.mainClass="com.payroll.PayrollApplication" > run.log 2>&1; echo $? > run.status
	@echo "Running tests..."
	@cd test-$(TEAM) && mvn test > test.log 2>&1; echo $? > test.status
	@$(MAKE) generate-json TEAM=$(TEAM)

generate-json:
	@echo "Generating JSON results for $(TEAM)..."
	@mkdir -p results
	@./scripts/generate-results.sh $(TEAM) > results/$(TEAM).json
	@echo "Results saved to results/$(TEAM).json"

test-alpha-local:
	@$(MAKE) test-local TEAM=alpha

test-beta-local:
	@$(MAKE) test-local TEAM=beta

test-gamma-local:
	@$(MAKE) test-local TEAM=gamma

test-delta-local:
	@$(MAKE) test-local TEAM=delta

test-all-local:
	@$(MAKE) test-alpha-local
	@$(MAKE) test-beta-local
	@$(MAKE) test-gamma-local
	@$(MAKE) test-delta-local
	@echo "All results combined:"
	@jq -s 'add' results/*.json > results/all-teams.json