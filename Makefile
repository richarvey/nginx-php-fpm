.DEFAULT_GOAL := help

.PHONY: help build test test-compat check

IMAGE ?= nginx-php-fpm:local
PLATFORM ?=
BUILDER ?= default

# Help
help: ## Show available targets
	@grep -hE '^[a-zA-Z0-9_-]+:.*## ' $(MAKEFILE_LIST) \
	  | awk 'BEGIN {FS = ":.*## "}; {printf "  \033[36m%-16s\033[0m %s\n", $$1, $$2}'

# Docker build
build: ## Build the image, pulling the latest base image
	docker buildx build --builder $(BUILDER) $(if $(PLATFORM),--platform $(PLATFORM)) --load --pull -t $(IMAGE) .

# Tests
test: ## Smoke-test the image and an HTTP request to PHP-FPM
	sh tests/smoke.sh $(IMAGE)
	OPcache=1 sh tests/smoke.sh $(IMAGE)

test-compat: ## Check existing settings and startup scenarios
	sh tests/compat.sh $(IMAGE)

check: build ## Build the image and run all tests
	$(MAKE) test test-compat IMAGE=$(IMAGE)
