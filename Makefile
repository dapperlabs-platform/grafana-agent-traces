.PHONY: doc
doc:
	terraform-docs markdown table --header-from header.md . > README.md