.DEFAULT_GOAL := lint

.PHONY: fmt
fmt:
	opa fmt . --write

.PHONY: lint
lint:
	opa check . --strict
	regal lint .
