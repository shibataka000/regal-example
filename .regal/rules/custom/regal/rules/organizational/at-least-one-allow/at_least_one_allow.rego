# METADATA
# description: |
#   There must be at least one boolean rule named `allow`, and it must
#   have a default value of `false`
# related_resources:
# - description: documentation
#   ref: https://www.acmecorp.example.org/docs/regal/aggregate-allow
# schemas:
# - input: schema.regal.ast
package custom.regal.rules.organizational["at-least-one-allow"]

import rego.v1

import data.regal.ast
import data.regal.result

aggregate contains entry if {
	# ast.rules is input.rules with functions filtered out
	some rule in ast.rules

	# search for rule named allow
	ast.ref_to_string(rule.head.ref) == "allow"

	# make sure it's a default assignment
	# ideally we'll want more than that, but the *requirement* is only
	# that such a rule exists...
	rule["default"] == true

	# ...and that it defaults to false
	rule.head.value.type == "boolean"
	rule.head.value.value == false

	# if found, collect the result into our aggregate collection
	# we don't really need the location here, but showing for demonstration
	entry := result.aggregate(rego.metadata.chain(), {"package": input["package"]}) # optional metadata here
}

# METADATA
# description: |
#   This is called once all aggregates have been collected. Note the use of a
#   different schema here for type checking, as the input is no longer the AST
#   of a Rego policy, but our collected data.
# schemas:
#   - input: schema.regal.aggregate
aggregate_report contains violation if {
	# input.aggregate contains only the entries collected by *this* aggregate rule,
	# so you don't need to worry about counting entries from other sources here!
	count(input.aggregate) == 0

	# no aggregated data found, so we'll report a violation
	# another rule may of course want to make use of the data collected in the aggregation
	details := {"message": "At least one rule named `allow` must exist, and it must have a default value of `false`"}
	violation := result.fail(rego.metadata.chain(), details)
}
