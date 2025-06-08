include .env

webhook:
	curl -X POST \
		-H "Authorization: token $(TOKEN)" \
		-H "Accept: application/vnd.github.v3+json" \
		-d '{"event_type": "test"}' \
		https://api.github.com/repos/t0lia/payroll-checker/dispatches
