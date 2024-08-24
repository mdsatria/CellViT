#!/bin/bash

# some codes for server configs

source activate base
conda activate /path_to_conda_env
export PATH=/path_to_conda_env/bin/:$PATH

cd /path_to_cellvit_repo

JOB_ID='0'
COHORT='cohort'
DIR_WSI="path_to_wsi"
DIR_OUT="path_to_temp"
DIR_FINAL="path_to_final_results"
./run.sh $JOB_ID $COHORT $DIR_WSI $DIR_OUT $DIR_FINAL