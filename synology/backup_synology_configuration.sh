#!/bin/sh

# Script to backup Synology configuration to a file and store it on NetBackup folder, located at:
# - GUI: File Station --> NetBackup
# - CLI: /volume1/NetBackup/
# Output example file: synology01_20200722.dss
#
# OBS: you can store the configuration file in any local or remote folder mounted on your Synology, just remember to change the "--filepath" parameter.
#
# You can schedule it by doing:
# - GUI schedule: Log on to Synology Server via Web --> Control Panel --> Task Scheduler --> Create --> Scheduled Task --> User-defined script
# - CLI schedule: Log on to Synology Server via SSH --> use Linux cron

/usr/syno/bin/synoconfbkp export --filepath=/volume1/NetBackup/"$(hostname -s)_$(date +%Y%m%d)".dss
