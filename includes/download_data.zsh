#!/usr/bin/env zsh

# Configuration
SEED_DIR="./seed"

# Create seed directory if it doesn't exist
mkdir -p "$SEED_DIR"

echo "Downloading sample ClickHouse ontime dataset to $SEED_DIR directory"

# Change to seed directory
cd "$SEED_DIR"

# Download data for year 2019 for testing
echo "Downloading data for year 2019 for testing..."
year=2019
echo "Downloading $year data..."
wget --no-check-certificate --continue https://clickhouse-public-datasets.s3.amazonaws.com/ontime/csv_by_year/$year.csv.gz
# Check if download was successful
if [ $? -ne 0 ]; then
  echo "Warning: Failed to download data for year $year"
fi

# Skip extraction and keep .gz files as-is
echo "Download complete! (Files kept in .gz format)"
