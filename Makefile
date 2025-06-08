include .env

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