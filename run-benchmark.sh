#!/bin/bash

PATH_TO_ROCKSDB="/home/shared/rocksdb"
DATA_DIR=/home/shared/tmp # This should have at least 30G available
export WAL_DIR="$DATA_DIR/wal"
export DB_DIR="$DATA_DIR/db"
export OUTPUT_DIR="$DATA_DIR"

report="$OUTPUT_DIR/report.tsv"
schedule="$OUTPUT_DIR/schedule.txt"

# Install dependencies
sudo apt install -y libgflags-dev libzstd-dev time

# Output directories
sudo rm -rf $DATA_DIR
sudo mkdir -p $DATA_DIR
sudo mkdir $WAL_DIR  $DB_DIR
sudo touch $report $schedule
sudo chmod 777 $DATA_DIR $WAL_DIR $DB_DIR $report $schedule

# Build benchmark
export LD_LIBRARY_PATH=/home/shared/rocksdb:$LD_LIBRARY_PATH
cd $PATH_TO_ROCKSDB
sudo make db_bench -j$(nproc) DEBUG_LEVEL=0
sudo mv db_bench tools/
cd tools

export NUM_KEYS=1000

# Run benchmark
yes | ./benchmark.sh seqkeystimestamps
