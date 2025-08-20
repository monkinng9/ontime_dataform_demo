# Makefile for OnTime Dataform Project

# Include environment variables
include .env

# Default target
.PHONY: all
all: load

# Download data for year 2019
.PHONY: download
download:
	@echo "Downloading data for year 2019..."
	@zsh ./includes/download_data.zsh

# Upload data to Google Cloud Storage
.PHONY: upload
upload:
	@echo "Uploading data to Google Cloud Storage..."
	@zsh ./includes/upload_data.zsh

# Download and upload data in one step
.PHONY: load
load:
	@echo "Downloading and uploading data for year 2019..."
	@zsh ./includes/load_data_to_gcs.zsh

# Test upload using download_data.zsh and upload_data.zsh
.PHONY: test-upload
test-upload:
	@echo "Testing upload by running download then upload..."
	@zsh ./includes/download_data.zsh
	@zsh ./includes/upload_data.zsh
	@echo "Test upload complete."

# Run Dataform workflow
.PHONY: dataform
dataform:
	@echo "Running Dataform workflow..."
	@dataform run

# Clean seed directory
.PHONY: clean
clean:
	@echo "Cleaning seed directory..."
	@rm -rf seed/*
	@echo "Seed directory cleaned."

# Display help information
.PHONY: help
help:
	@echo "OnTime Dataform Project Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make download     Download data for year 2019"
	@echo "  make upload       Upload data to Google Cloud Storage"
	@echo "  make load         Download and upload data (default)"
	@echo "  make test-upload  Run download and then upload scripts for testing"
	@echo "  make dataform     Run Dataform workflow"
	@echo "  make clean        Clean seed directory"
	@echo "  make help         Display this help message"
	@echo ""
	@echo "Environment variables (set in .env file):"
	@echo "  GCS_BUCKET        Google Cloud Storage bucket path"
