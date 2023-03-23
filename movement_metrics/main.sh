#!/bin/bash

notebooks_dir="/srv/product_analytics/jobs/movement_metrics/notebooks"

# Clean up nbconvert notebooks from *previous* run:
rm $notebooks_dir/*.nbconvert.ipynb

# Activate conda-analytics base environment:
source /opt/conda-analytics/bin/activate

for notebook in $notebooks_dir/*.ipynb
do
  python -m jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook --execute $notebook || exit 1
done
