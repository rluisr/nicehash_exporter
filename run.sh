#!/bin/bash

set -eu

KEY=""
SEC=""
ORG=""
API="https://api2.nicehash.com"

NHCLIENT="python3 nicehash.py -b $API -o $ORG -k $KEY -s $SEC"

rigs_result=$(eval "$NHCLIENT -m GET -p '/main/api/v2/mining/rigs2'" | sed 's/True/true/g' | sed 's/False/false/g' | sed "s/'/\"/g")

total_rigs=$(echo "${rigs_result}" | jq -r .totalRigs)
mining_rigs=$(echo "${rigs_result}" | jq -r .minerStatuses.MINING)

rigs_name=($(echo "${rigs_result}" | jq -r .miningRigs[].name))

temps=()
loads=()
speeds=()
total_speed=0
active_devices=0

for i in "${!rigs_name[@]}"; do
  rig_name="${rigs_name[$i]}"
  devices=$(echo "${rigs_result}" | jq .miningRigs[$i].devices)
  devices_len=$(echo "${rigs_result}" | jq .miningRigs[$i].devices | jq length)

  IFS_BACKUP=$IFS
  IFS=$'\n'
  for x in $(seq 0 $(($devices_len - 1))); do
    device=$(echo "${devices}" | jq .[$x])
    device_name=$(echo "${device}" | jq -r .name)
    device_status=$(echo "${device}" | jq -r .status.enumName)

    device_temp=$(echo "${device}" | jq -r .temperature)
    temps+=($(echo "{rig=\"${rig_name}\",device=\"${device_name}\",status=\"${device_status}\"} ${device_temp}"))

    device_load=$(echo "${device}" | jq -r .load)
    loads+=($(echo "{rig=\"${rig_name}\",device=\"${device_name}\",status=\"${device_status}\"} ${device_load}"))

    device_algo=$(echo "${device}" | jq -r .speeds[0].algorithm)
    device_speed=$(echo "${device}" | jq -r .speeds[0].speed | awk '{printf("%d\n",$1 + .0.5)}')
    speeds+=($(echo "{rig=\"${rig_name}\",device=\"${device_name}\",algo=\"${device_algo}\"} ${device_speed}"))
    total_speed=$(($total_speed + $device_speed))

    if [ "${device_status}" = "MINING" ]; then
      active_devices=$(expr $active_devices + 1)
    fi
  done
  IFS_BACKUP=$IFS
done

echo "# HELP nicehash_active_devices"
echo "# TYPE nicehash_active_devices"
echo "nicehash_active_devices ${active_devices}"

echo "# HELP nicehash_device_temperature"
echo "# TYPE nicehash_device_temperature"
for temp in "${temps[@]}"; do
  echo "nicehash_device_temperature${temp}"
done

echo "# HELP nicehash_device_load"
echo "# TYPE nicehash_device_load"
for load in "${loads[@]}"; do
  echo "nicehash_device_load${load}"
done

echo "# HELP nicehash_device_speed"
echo "# TYPE nicehash_device_speed"
for speed in "${speeds[@]}"; do
  echo "nicehash_device_speed${speed}"
done

echo "# HELP nicehash_total_speed"
echo "# TYPE nicehash_total_speed"
echo "nicehash_total_speed ${total_speed}"
