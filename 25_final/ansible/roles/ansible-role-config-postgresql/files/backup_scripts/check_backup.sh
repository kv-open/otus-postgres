#!/bin/bash
backup_path={{ backup_path }}

json_data=$(pg_probackup-16 show --instance {{ backup_instance }} --backup-path $backup_path --format=json |\
    jq '.[] | .backups | .[0]
    | {
     "status": ."status",
     "start-time": ."start-time",
     "end-time": ."end-time",
     "backup-mode" : ."backup-mode",
     "wal": ."wal", "data-megabytes": (."data-bytes"/1024/1024), "wal-megabytes": (."wal-bytes"/1024/1024)
     }')

# current date without time
start_date=$(echo "$json_data" | jq -r '."start-time"' | cut -d " " -f 1)

today=$(date +%Y-%m-%d)

# Compare start_date with today's date
if [ "$start_date" != "$today" ]; then
    # If dates do not match, change status to "failed"
    json_data=$(echo "$json_data" | jq '.status = "failed"')
fi

echo "$json_data"
