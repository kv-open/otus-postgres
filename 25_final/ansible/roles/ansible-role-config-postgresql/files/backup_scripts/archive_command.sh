#!/bin/bash
# 1 - %f
# 2 - %p
export BACKUP_PATH='{{ backup_path }}'
pg_probackup-16 archive-push -B "$BACKUP_PATH" \
            --instance {{ backup_instance }} \
            --wal-file-path "$2" \
            --wal-file-name "$1" \
            --overwrite \
            --compress-algorithm=zstd \
            --compress-level=3 \
            --threads {{ backup_threads }} \
            --batch-size 100
