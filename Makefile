generate: ## Generate code
	dart run build_runner build

generate_watch: ## Generate code cleaning old files
	dart run build_runner watch --delete-conflicting-outputs

setup: ## Clean and get packages
	flutter clean
	flutter pub get

generate_all: setup generate ## Run clean, get packages, and generate code