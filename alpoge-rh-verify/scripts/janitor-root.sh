#!/bin/bash
exec runuser -u builder -- env -i HOME=/home/builder PATH=/usr/bin:/bin LANG=C.UTF-8 bash /work/scripts/janitor.sh
