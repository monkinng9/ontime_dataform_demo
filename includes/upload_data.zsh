#!/usr/bin/env zsh

# Configuration
SEED_DIR="./seed"
# Get GCS_BUCKET from environment variable, with a default value
GCS_BUCKET="${GCS_BUCKET:-gs://your-bucket-name/ontime-data}"

# Change to seed directory
cd "$SEED_DIR" || {
  echo "Error: Could not change to $SEED_DIR directory"
  exit 1
}

# Check if .gz files exist
if ! ls *.csv.gz >/dev/null 2>&1; then
  echo "Error: No .gz files found in $SEED_DIR directory"
  echo "Please run download_data.zsh first to download data"
  exit 1
fi

# Upload data to Google Cloud Storage, organized by year
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
