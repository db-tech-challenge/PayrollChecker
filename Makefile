include .env

PYTHON ?= python3

# Remote webhook triggers for GitHub Actions
alpha:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "alpha"}' \
		https://api.github.com/repos/db-tech-challenge/PayrollChecker/dispatches

test:
	bash scripts/run-tests.sh alpha
	@$(PYTHON) scripts/generate-results.py alpha
	bash scripts/run-tests.sh beta
	@$(PYTHON) scripts/generate-results.py beta
	bash scripts/run-tests.sh gamma
	@$(PYTHON) scripts/generate-results.py gamma
	bash scripts/run-tests.sh delta
	@$(PYTHON) scripts/generate-results.py delta
	bash scripts/run-tests.sh epsilon
	@$(PYTHON) scripts/generate-results.py epsilon
	bash scripts/run-tests.sh zeta
	@$(PYTHON) scripts/generate-results.py zeta
	bash scripts/run-tests.sh omega
	@$(PYTHON) scripts/generate-results.py omega
	bash scripts/generate-docs.sh
	open "http://localhost:63342/payroll-checker/docs/index.html"

clean:
	@echo "Cleaning up..."
	@rm -rf test-alpha test-beta test-gamma test-delta test-epsilon test-omega test-zeta docs/* 'docs/.nojekyll' target
	@echo "Cleanup complete."

build-docs:
	@echo "Building documentation..."
	bash scripts/generate-docs.sh
	@echo "Documentation built in docs/"
