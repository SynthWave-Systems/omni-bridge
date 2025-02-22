# Common variables and settings
common_testing_root := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))/..
common_timestamp := $(shell date -u +%Y%m%d-%H%M%S)

# ASCII box formatting for step descriptions
define description
	@echo "|──────────────────────────────────────────────────────────────"
	@echo "│ $(1)"
	@echo "|──────────────────────────────────────────────────────────────"
endef

# Progress bar for waiting operations
define progress_wait
	@tput civis; \
	for i in $$(seq 1 $(1)); do \
		printf "\033[2K\rWaiting: ["; \
		p=$$((i * 100 / $(1))); \
		for j in $$(seq 1 $$p); do printf "="; done; \
		if [ $$p -lt 100 ]; then printf ">"; fi; \
		for j in $$(seq $$(($$p + 1)) 100); do printf " "; done; \
		printf "] $$p%% ($$i/$(1) seconds)"; \
		sleep 1; \
	done; \
	printf "\n"; \
	tput cnorm
endef

# Common directories
common_near_deploy_results_dir := $(common_testing_root)/near_deploy_results
common_evm_deploy_results_dir := $(common_testing_root)/evm_deploy_results
common_solana_deploy_results_dir := $(common_testing_root)/solana_deploy_results

# Common files
common_near_bridge_id_file := $(common_near_deploy_results_dir)/omni_bridge.json
common_bridge_sdk_config_file := $(common_testing_root)/bridge-sdk-config.json

# Chain identifiers
COMMON_SEPOLIA_CHAIN_ID := 0
COMMON_SEPOLIA_CHAIN_STR := Eth

# Create required directories
$(common_near_deploy_results_dir) $(common_evm_deploy_results_dir) $(common_solana_deploy_results_dir):
	$(call description,Creating directory to store deploy results: $@)
	mkdir -p $@

# Clean targets
.PHONY: clean-deploy-results
clean-deploy-results:
	$(call description,Cleaning deploy results directories)
	rm -rf $(common_near_deploy_results_dir)
	rm -rf $(common_evm_deploy_results_dir)
	rm -rf $(common_solana_deploy_results_dir) 