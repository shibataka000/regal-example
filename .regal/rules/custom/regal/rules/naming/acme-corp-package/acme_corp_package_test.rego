package custom.regal.rules.naming["acme-corp-package_test"]

import rego.v1

import data.custom.regal.rules.naming["acme-corp-package"] as rule

test_acme_corp_package_allowed if {
	module := regal.parse_module("example.rego", "package acme.corp.foo")
	r := rule.report with input as module
	count(r) == 0
}

test_system_log_package_allowed if {
	module := regal.parse_module("example.rego", "package system.log.foo")
	r := rule.report with input as module
	count(r) == 0
}

test_foo_bar_baz_package_not_allowed if {
	module := regal.parse_module("example.rego", "package foo.bar.baz")
	r := rule.report with input as module
	r == {{
		"category": "naming",
		"description": "All packages must use \"acme.corp\" base name",
		"level": "error",
		"location": {
			"col": 9,
			"end": {
				"col": 12,
				"row": 1,
			},
			"file": "example.rego",
			"row": 1,
			"text": "package foo.bar.baz",
		},
		"related_resources": [{
			"description": "documentation",
			"ref": "https://www.acmecorp.example.org/docs/regal/package",
		}],
		"title": "acme-corp-package",
	}}
}
