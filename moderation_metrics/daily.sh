#!/bin/bash

pipelines_dir="/srv/product_analytics/jobs/data-pipelines"

# Clean up nbconvert notebooks from *previous* run:
rm $pipelines_dir/*.nbconvert.ipynb
rm $pipelines_dir/moderation/*.nbconvert.ipynb

# Activate conda-analytics base environment:
source /opt/conda-analytics/bin/activate

notebooks=(
  "$pipelines_dir/moderation/calculate_moderation_patrolled_recentchanges_daily.ipynb"
  "$pipelines_dir/moderation/calculate_moderation_unpatrolled_recentchanges_daily.ipynb"
)

for notebook in "${notebooks[@]}"
do
  echo $notebook
  python -m jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook --execute $notebook || exit 1
done
