#!/usr/bin/env zsh

# Configuration
SEED_DIR="./seed"
# Get GCS_BUCKET from environment variable, with a default value
GCS_BUCKET="${GCS_BUCKET:-gs://your-bucket-name/ontime-data}"

# Create seed directory if it doesn't exist
mkdir -p "$SEED_DIR"

echo "Downloading ClickHouse ontime dataset to $SEED_DIR directory"

# Download ClickHouse ontime dataset (year 2019)
# Data source: ClickHouse public datasets
# https://clickhouse.com/docs/en/getting-started/example-datasets/ontime
cd "$SEED_DIR"
echo "Downloading data for years 2020 to 2022..."
for year in {2020..2022}; do
  echo "Downloading $year data..."
  wget --no-check-certificate --continue https://clickhouse-public-datasets.s3.amazonaws.com/ontime/csv_by_year/$year.csv.gz
  # Check if download was successful
  if [ $? -ne 0 ]; then
    echo "Warning: Failed to download data for year $year"
  fi
done

# Skip extraction and keep .gz files as-is
echo "Download complete! (Files kept in .gz format)"

# Upload data to Google Cloud Storage, organized by year and month
echo "Uploading data to Google Cloud Storage bucket: $GCS_BUCKET"

# Process each .gz file and upload to partitioned directories
for file in *.csv.gz; do
  if [ -f "$file" ]; then
    # Extract year from filename (e.g., 2019.csv.gz -> 2019)
    if [[ $file =~ ([0-9]{4})\.csv\.gz ]]; then
      year="${match[1]}"
      
      # Create partitioned path by year only (no month data in this dataset)
      partition_path="$GCS_BUCKET/landing_data/ontime/load_year=$year/"
      
      echo "Uploading $file to $partition_path"
      gsutil -m cp "$file" "$partition_path"

      # Check if the upload was successful
      if [ $? -ne 0 ]; then
        echo "Error: Failed to upload $file to $partition_path. Aborting."
        exit 1
      fi
    else
      echo "Warning: Could not parse year from filename $file. Skipping upload."
    fi
  fi
done

echo "Upload complete!"