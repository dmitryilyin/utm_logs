#!/bin/sh
dir=`dirname $0`
cd "${dir}" || exit 1

mkdir -p archive netflow

rm -rf archive/*

for file in iptraffic_raw_1415859013.utm.gz iptraffic_raw_1415859128.utm iptraffic_raw_1415859324.utm iptraffic_raw_1415859537.utm; do
  date > "netflow/${file}"
done
