#!/bin/bash
while true; do sleep 600; bash /work/scripts/rate.sh >> /work/logs/rate.log 2>&1; done
