#!/bin/bash

NB_DIR="/srv/product_analytics/jobs/movement_metrics/notebooks"

alias execute_notebook="/usr/lib/anaconda-wmf/bin/python -m jupyter nbconvert --ExecutePreprocessor.timeout=None --to notebook --execute"

# Execute the following notebooks:
execute_notebook $NB_DIR/test.ipynb
