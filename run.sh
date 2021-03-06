#
# shfmt -i 2 -w run.sh
#
#!/bin/bash

set -eu

KEY=""
SEC=""
ORG=""
API="https://api2.nicehash.com"

NHCLIENT="python3 nicehash.py -b $API -o $ORG -k $KEY -s $SEC"

rigs_result=$(eval "$NHCLIENT -m GET -p '/main/api/v2/mining/rigs2'" | sed 's/True/true/g' | sed 's/False/false/g' | sed "s/'/\"/g")
account_result=$(eval "$NHCLIENT -m GET -p '/main/api/v2/accounting/account2/BTC'" | sed 's/True/true/g' | sed 's/False/false/g' | sed "s/'/\"/g")

total_rigs=$(echo "${rigs_result}" | jq -r .totalRigs)
mining_rigs=$(echo "${rigs_result}" | jq -r .minerStatuses.MINING)

rigs_name=($(echo "${rigs_result}" | jq -r .miningRigs[].name))

temps=()
loads=()
speeds=()
accepted_speeds=()
rejected_r1_target_speeds=()
rejected_r2_stale_speeds=()
rejected_r3_duplicate_speeds=()
rejected_r4_ntime_speeds=()
rejected_r5_other_speeds=()
total_rejected_speeds=()
total_speed=0
active_devices=0
total_balance=($(echo "${account_result}" | jq -r .totalBalance))
total_profitability=($(echo "${rigs_result}" | jq -r .totalProfitability))
unpaid_amount=($(echo "${rigs_result}" | jq -r .unpaidAmount))

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

  value=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedAccepted)
  if [ "${value}" != "null" ]; then
    accepted_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

  value=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedRejectedR1Target)
  if [ "${value}" != "null" ]; then
    rejected_r1_target_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

  value=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedRejectedR2Stale)
  if [ "${value}" != "null" ]; then
    rejected_r2_stale_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

  value=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedRejectedR3Duplicate)
  if [ "${value}" != "null" ]; then
    rejected_r3_duplicate_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

  value=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedRejectedR4NTime)
  if [ "${value}" != "null" ]; then
    rejected_r4_ntime_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

  rejected_r5_other_speed=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedRejectedR5Other)
  if [ "${value}" != "null" ]; then
    rejected_r5_other_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

  total_rejected_speed=$(echo "${rigs_result}" | jq -r .miningRigs[$i].stats[0].speedRejectedTotal)
  if [ "${value}" != "null" ]; then
    total_rejected_speeds+=($(echo "{rig=\"${rig_name}\"} ${value}"))
  fi

done

echo "# HELP total_balance"
echo "# TYPE total_balance"
echo "nicehash_total_balance ${total_balance}"

echo "# HELP total_profitability"
echo "# TYPE total_profitability"
echo "nicehash_total_profitability ${total_profitability}"

echo "# HELP unpaid_amount"
echo "# TYPE unpaid_amount"
echo "nicehash_unpaid_amount ${unpaid_amount}"

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

echo "# HELP nicehash_speed_accepted"
echo "# TYPE nicehash_speed_accepted"
for accepted_speed in "${accepted_speeds[@]}"; do
  echo "nicehash_speed_accepted${accepted_speed}"
done

echo "# HELP nicehash_rejected_r1_target_speed"
echo "# TYPE nicehash_rejected_r1_target_speed"
for rejected_r1_target_speed in "${rejected_r1_target_speeds[@]}"; do
  echo "nicehash_rejected_r1_target_speed${rejected_r1_target_speed}"
done

echo "# HELP nicehash_rejected_r2_stale_speed"
echo "# TYPE nicehash_rejected_r2_stale_speed"
for rejected_r2_stale_speed in "${rejected_r2_stale_speeds[@]}"; do
  echo "nicehash_rejected_r2_stale_speed${rejected_r2_stale_speed}"
done

echo "# HELP nicehash_rejected_r3_duplicate_speed"
echo "# TYPE nicehash_rejected_r3_duplicate_speed"
for rejected_r3_duplicate_speed in "${rejected_r3_duplicate_speeds[@]}"; do
  echo "nicehash_rejected_r3_duplicate_speed${rejected_r3_duplicate_speed}"
done

echo "# HELP nicehash_rejected_r4_ntime_speed"
echo "# TYPE nicehash_rejected_r4_ntime_speed"
for rejected_r4_ntime_speed in "${rejected_r4_ntime_speeds[@]}"; do
  echo "nicehash_rejected_r4_ntime_speed${rejected_r4_ntime_speed}"
done

echo "# HELP nicehash_rejected_r5_other_speed"
echo "# TYPE nicehash_rejected_r5_other_speed"
for rejected_r5_other_speed in "${rejected_r5_other_speeds[@]}"; do
  echo "nicehash_rejected_r5_other_speed${rejected_r5_other_speed}"
done

echo "# HELP nicehash_total_rejected_speed"
echo "# TYPE nicehash_total_rejected_speed"
for total_rejected_speed in "${total_rejected_speeds[@]}"; do
  echo "nicehash_total_rejected_speed${total_rejected_speed}"
done
