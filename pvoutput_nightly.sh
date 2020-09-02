#!/bin/bash
# crontab script to send the sunnyportal data from the last 3 days to pvoutput.org 
# 
# example schedule: at 2am
# * 2 * * * /path-to-script/pvoutput_nightly.sh


LOGFILE=/tmp/sunnyportal2pvoutput.nightly.log

#rotate logs
for i in {9..1}; do
    if [[ -f $LOGFILE.${i} ]]; then
        mv -f $LOGFILE.${i} $LOGFILE.$((i+1))
    fi
done
mv -f $LOGFILE $LOGFILE.1

exec >> $LOGFILE
exec 2>&1

cd "$(dirname "$0")"

#hardkill after 5min
PYTHONPATH=. timeout -s 9 300 ./bin/sunnyportal2pvoutput --status --days-past 2 sunnyportal.config

cd -
