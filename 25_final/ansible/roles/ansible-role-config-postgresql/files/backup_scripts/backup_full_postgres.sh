#!/bin/bash
export PATH="$PATH:/opt/pgpro/ent-15/bin"
{# {{ опция --stream нужена на тех серверах, где нету копирования wal через archive_command }} #}

{% if archive_command is not defined %}
pg_probackup-16 backup -B {{ backup_path }} \
            -b FULL \
            -h localhost \
             --instance={{ backup_instance }} \
             --stream \
             -U backup \
             -d backupdb \
             --threads {{ backup_threads }} \
             --delete-expired \
             --delete-wal \
             --compress \
             --temp-slot \
             --log-directory={{ postgres_log_directory }}/backup \
             --log-level-file=info \
             --log-filename=pg_probackup-16-full-%Y-%m-%d--%H-%M-%S.log \
             --error-log-filename=error-pg_probackup-16-full-%Y-%m-%d--%H-%M-%S.log \
             --log-rotation-size=10MB \
             --log-rotation-age=14d


{% else %}
pg_probackup-16 backup -B {{ backup_path }} \
            -b FULL \
            -h localhost \
             --instance={{ backup_instance }} \
             -U backup \
             -d backupdb \
             --threads {{ backup_threads }} \
             --delete-expired \
             --delete-wal \
             --compress \
             --temp-slot \
             --log-directory={{ postgres_log_directory }}/backup \
             --log-level-file=info \
             --log-filename=pg_probackup-16-full-%Y-%m-%d--%H-%M-%S.log \
             --error-log-filename=error-pg_probackup-16-full-%Y-%m-%d--%H-%M-%S.log \
             --log-rotation-size=10MB \
             --log-rotation-age=14d
{% endif %}