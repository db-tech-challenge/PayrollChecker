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

	bash scripts/run-tests.sh gamma
	@$(PYTHON) scripts/generate-results.py gamma
	bash scripts/generate-docs.sh
	open "http://localhost:63342/payroll-checker/docs/index.html"

clean:
	@echo "Cleaning up..."
	@rm -rf test-alpha test-beta test-gamma test-delta docs/* 'docs/.nojekyll' target
	@echo "Cleanup complete."

build-docs:
	@echo "Building documentation..."
	bash scripts/generate-docs.sh
	@echo "Documentation built in docs/"
