#!/bin/bash
JOB_ID=$1
COHORT=$2
DIR_WSI=$3
DIR_OUT=$4
DIR_FINAL=$5

# Declare an array to hold the lines from the file
declare -a lines_array
# Read each line from the file and append to the array
while IFS= read -r line; do
    lines_array+=("$line")
done < "file_lists/$COHORT$JOB_ID.txt"

mkdir -p "$DIR_FINAL/logs"
mkdir -p "$DIR_FINAL/$COHORT"
LOGFILE="$DIR_FINAL/logs/$COHORT$JOB_ID.txt"
touch $LOGFILE

slide_len=${#lines_array[@]}
counter=1

# Echo all elements in the array
for element in "${lines_array[@]}"; do    
    mkdir -p "$DIR_OUT/$COHORT/$JOB_ID/$element/"  
    echo "$(date +"%Y-%m-%d %H:%M:%S") $counter/$slide_len : $element" >> $LOGFILE
    echo "$(date +"%Y-%m-%d %H:%M:%S") start preprocessing" >> $LOGFILE

    python preprocessing/patch_extraction/main_extraction.py \
    --wsi_paths "$DIR_WSI/$COHORT/$element.svs" \
    --output_path "$DIR_OUT/$COHORT/$JOB_ID" \
    --config example/preprocessing_example.yaml 
    
    echo "$(date +"%Y-%m-%d %H:%M:%S") finish preprocessing" >> $LOGFILE
    echo "$(date +"%Y-%m-%d %H:%M:%S") start prediction" >> $LOGFILE

    python cell_segmentation/inference/cell_detection.py \
    --model checkpoints/CellViT-SAM-H-x40.pth \
    --gpu 0 \
    --batch_size 6 \
    --geojson \
    process_wsi \
    --wsi_path  "$DIR_WSI/$COHORT/$element.svs" \
    --patched_slide_path "$DIR_OUT/$COHORT/$JOB_ID/$element"

    echo "$(date +"%Y-%m-%d %H:%M:%S") finish prediction" >> $LOGFILE
    
    mkdir -p "$DIR_FINAL/$COHORT/$JOB_ID/$element/"
    mv "$DIR_OUT/$COHORT/$JOB_ID/$element/cell_detection"/* "$DIR_FINAL/$COHORT/$JOB_ID/$element/"
    rm -rf "$DIR_OUT/$COHORT/$JOB_ID/$element"

    echo "$(date +"%Y-%m-%d %H:%M:%S") results copied" >> $LOGFILE
    echo "" >> $LOGFILE

    counter=$((counter + 1))
done