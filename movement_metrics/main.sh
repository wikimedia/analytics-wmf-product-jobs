#!/bin/bash

notebooks_dir="/srv/product_analytics/jobs/movement_metrics/notebooks"

source /usr/lib/anaconda-wmf/bin/activate

for notebook in $notebooks_dir/*.ipynb
do
  python -m jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook --execute $notebook || exit 1
done
