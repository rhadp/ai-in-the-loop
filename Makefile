COMPONENTS_DIR := components

COMPONENT_NAMES := konflux-ci jumpstarter automotive-dev-operator

REPO_konflux-ci := https://github.com/konflux-ci/konflux-ci
REPO_jumpstarter := https://github.com/jumpstarter-dev/jumpstarter
REPO_automotive-dev-operator := https://github.com/centos-automotive-suite/automotive-dev-operator

.PHONY: clone update status

clone:
	@for name in $(COMPONENT_NAMES); do \
		url=$$(eval echo \$$REPO_$$name); \
		if [ -d "$(COMPONENTS_DIR)/$$name" ]; then \
			echo "$$name: already cloned"; \
		else \
			echo "$$name: cloning $$url"; \
			git clone "$$url" "$(COMPONENTS_DIR)/$$name"; \
		fi; \
	done

update:
	@for name in $(COMPONENT_NAMES); do \
		if [ -d "$(COMPONENTS_DIR)/$$name" ]; then \
			echo "$$name: pulling latest..."; \
			git -C "$(COMPONENTS_DIR)/$$name" pull --ff-only; \
		else \
			echo "$$name: not cloned — run 'make clone' first"; \
		fi; \
	done

status:
	@for name in $(COMPONENT_NAMES); do \
		if [ -d "$(COMPONENTS_DIR)/$$name" ]; then \
			branch=$$(git -C "$(COMPONENTS_DIR)/$$name" rev-parse --abbrev-ref HEAD); \
			sha=$$(git -C "$(COMPONENTS_DIR)/$$name" rev-parse --short HEAD); \
			echo "$$name: $$branch @ $$sha"; \
		else \
			echo "$$name: not cloned"; \
		fi; \
	done

