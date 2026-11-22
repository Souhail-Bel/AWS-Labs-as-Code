include versions.env
export FLOCI_VERSION

LAB       ?=
LABDIR     = labs/$(LAB)
USE_FLOCI ?= true
export USE_FLOCI

FLOCI_RUNTIME ?= docker
ifeq ($(FLOCI_RUNTIME),cli)
FLOCI_START ?= floci start
FLOCI_STOP  ?= floci stop
else
FLOCI_START ?= docker compose up -d
FLOCI_STOP  ?= docker compose down
endif

# local Floci emulator by default
export AWS_ENDPOINT_URL      ?= http://localhost:4566
export AWS_DEFAULT_REGION    ?= us-east-1
export AWS_ACCESS_KEY_ID     ?= test
export AWS_SECRET_ACCESS_KEY ?= test

.DEFAULT_GOAL := help
.PHONY: help up down reset start end solution solution-end test fmt check-lab peace

help: ## Need some help?
	@grep -hE '^[a-z-]+:.*##' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  %-13s %s\n", $$1, $$2}'

up: ## Start Floci
	$(FLOCI_START)
	uv run python scripts/wait_for_floci.py

down: ## Stop Floci
	$(FLOCI_STOP)

reset: ## Restart Floci with empty fresh state
	$(MAKE) down
	$(MAKE) up

start: check-lab ## Set up the lab (Start Lab)
	bash scripts/tf.sh $(LABDIR) seed apply

end: check-lab ## Tear the lab setup down (End Lab)
	bash scripts/tf.sh $(LABDIR) seed destroy

solution: check-lab ## Apply the lab's optional Terraform solution
	bash scripts/tf.sh $(LABDIR) solution apply

solution-end: check-lab ## Destroy the Terraform solution
	bash scripts/tf.sh $(LABDIR) solution destroy

test: check-lab ## Run a lab end-to-end, what CI runs
	$(MAKE) reset
	$(MAKE) start
	uv run jupyter nbconvert --to notebook --execute $(LABDIR)/lab.ipynb --output-dir build/$(LAB)
	$(MAKE) end
	@if [ -d $(LABDIR)/solution ]; then \
		$(MAKE) reset && $(MAKE) solution && uv run python $(LABDIR)/solution/verify.py && $(MAKE) solution-end; \
	fi

fmt: ## Format all Terraform and make it all nice
	terraform fmt -recursive

check-lab:
	@test -n "$(LAB)" || { echo "USAGE: make <target> LAB=NN-name"; exit 1; }
	@test -d $(LABDIR) || { echo "no such lab: $(LABDIR)"; exit 1; }

peace: ## Who can forget...
	@echo "Not war!"