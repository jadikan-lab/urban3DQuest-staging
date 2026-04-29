SHELL := /bin/bash

.PHONY: ready checks status rc quick

ready:
	./scripts/autopilot_minimal.sh

checks:
	./scripts/run_all_ops_checks.sh

status:
	./scripts/report_staging_status.sh

rc:
	./scripts/release_candidate_staging.sh

quick:
	./scripts/runbook_staging_ops.sh quick-checks
