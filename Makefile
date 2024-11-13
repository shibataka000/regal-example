.DEFAULT_GOAL := lint

.PHONY: fmt
fmt:
	opa fmt . --write

.PHONY: lint
lint:
	opa check . --strict --ignore .regal
	regal lint .

.PHONY: test
test:
	regal test . --var-values
