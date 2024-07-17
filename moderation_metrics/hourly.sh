#!/bin/bash

pipelines_dir="/srv/product_analytics/jobs/data-pipelines"

# Clean up nbconvert notebooks from *previous* run:
rm $pipelines_dir/*.nbconvert.ipynb
rm $pipelines_dir/moderation/*.nbconvert.ipynb

# Activate conda-analytics base environment:
source /opt/conda-analytics/bin/activate

notebooks=(
  "$notebooks_dir/moderation/calculate_moderation_flagged_revisions_pending_hourly.ipynb"
)

for notebook in "${notebooks[@]}"
do
  python -m jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook --execute $notebook || exit 1
done
