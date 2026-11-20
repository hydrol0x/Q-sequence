#!/bin/bash
# usage: p.sh exec 'cmd' | p.sh job NAME FILE | p.sh tail PATH [LEN] | p.sh put REMOTE LOCAL | p.sh health
D=$(dirname "$0"); T=$(cat "$D/token.txt"); U=https://m11vdyb9ph3zlx-8000.proxy.runpod.net
case "$1" in
 health) curl -sS -m 20 "$U/health";;
 exec) curl -sS -m 100 -H "X-Token: $T" -X POST --data-binary "$2" "$U/exec?timeout=${3:-80}";;
 job) curl -sS -m 60 -H "X-Token: $T" -X POST --data-binary @"$3" "$U/job?name=$2";;
 tail) curl -sS -m 60 -H "X-Token: $T" -G --data-urlencode "path=$2" --data-urlencode "len=${3:-4000}" "$U/file";;
 put) curl -sS -m 60 -H "X-Token: $T" -X POST --data-binary @"$3" "$U/put?path=$2";;
esac
