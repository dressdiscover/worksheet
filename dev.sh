#!/bin/bash

set -e

cd `dirname "$(readlink -f "$0")"`

THIS_DIR_PATH=$PWD
CACHE_DIR_PATH=$THIS_DIR_PATH/.paradicms/cache
DATA_DIR_PATH=$THIS_DIR_PATH/.paradicms/data
PROJECTS_DIR_PATH=$PWD/../..

cd $PROJECTS_DIR_PATH/paradicms/lib/py/ssg

poetry run python $PROJECTS_DIR_PATH/paradicms/lib/py/etl/paradicms_etl/pipelines/costume_core_ontology_airtable_to_paradicms_rdf_pipeline.py \
  --paradicms-rdf-file-path $DATA_DIR_PATH/costume_core_ontology.trig \
  "$@"

poetry run $PROJECTS_DIR_PATH/directory-etl-action/action.py \
  --cache-directory-path $CACHE_DIR_PATH \
  --input-directory-path $THIS_DIR_PATH \
  --loaded-data-directory-path $DATA_DIR_PATH \
  --pipeline-id app_configuration

poetry run $PROJECTS_DIR_PATH/ssg-action/action.py \
  --cache-directory-path $CACHE_DIR_PATH \
  --data-paths $DATA_DIR_PATH \
  --dev \
  --pipeline-id app
