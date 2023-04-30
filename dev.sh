#!/bin/bash

set -e

cd `dirname "$(readlink -f "$0")"`

THIS_DIR_PATH=$PWD
PROJECTS_DIR_PATH=$PWD/../..

cd $PROJECTS_DIR_PATH/paradicms/lib/py/ssg

poetry run python $PROJECTS_DIR_PATH/paradicms/lib/py/etl/paradicms_etl/pipelines/costume_core_ontology_airtable_to_paradicms_rdf_pipeline.py \
  --paradicms-rdf-file-path $THIS_DIR_PATH/.paradicms/data/costume_core_ontology.trig \
  "$@"

poetry run $PROJECTS_DIR_PATH/directory-etl-action/action.py \
  --input-directory-path $THIS_DIR_PATH \
  --loaded-data-directory-path $THIS_DIR_PATH/.paradicms/data \
  --pipeline-id dressdiscover_worksheet

poetry run $PROJECTS_DIR_PATH/ssg-action/action.py \
  --dev \
  --pipeline-id costume_core_ontology
