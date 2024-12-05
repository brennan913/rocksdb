#!/bin/bash

PATH_TO_ROCKSDB="/Users/ryanwee/brennan_rocksdb"
DATA_DIR="/tmp/rocksdb" # This should have at least 30G available
export WAL_DIR="$DATA_DIR/wal"
export DB_DIR="$DATA_DIR/db"
export OUTPUT_DIR="$DATA_DIR"

report="$OUTPUT_DIR/report.tsv"
schedule="$OUTPUT_DIR/schedule.txt"

# Install dependencies
sudo apt install -y libgflags-dev libzstd-dev time

# Create output files and directories
sudo rm -rf $DATA_DIR
sudo mkdir -p $DATA_DIR
sudo mkdir $WAL_DIR  $DB_DIR
sudo touch $report $schedule
sudo chmod 777 $DATA_DIR $WAL_DIR $DB_DIR $report $schedule

# Set benchmark parameters
export LD_LIBRARY_PATH=/Users/ryanwee/brennan_rocksdb:$LD_LIBRARY_PATH
export BLOCK_SIZE=$((16 << 10))         # 16 MiB
export CACHE_SIZE=$((16 << 30))         # 16 GiB
export BLOB_CACHE_SIZE=$((16 << 30))    # 16 GiB
export NUM_KEYS=5000

# Build benchmark
cd $PATH_TO_ROCKSDB
sudo make db_bench -j$(nproc) DEBUG_LEVEL=0
sudo mv db_bench tools/
cd tools

# Run benchmark
yes | ./benchmark.sh seqkeystimestamps
