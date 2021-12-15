nicehash_exporter
=================

About Textfile Collector [see](https://github.com/prometheus/node_exporter#textfile-collector)

Run
---

Before using this, replace `KEY`, `SEC` and `ORG` on `run.sh`

```bash
$ ./run.sh | sponge /etc/node_exporter/collector/nicehash.prom
```

About API Key
-------------

We need read only permissions. Do not forget read wallet permission.

![](https://user-images.githubusercontent.com/7776462/146216064-695338e5-5e78-4659-87ee-23b9d4d8b583.png)


Output
-------
```
# HELP nicehash_active_devices
# TYPE nicehash_active_devices
nicehash_active_devices 6
# HELP nicehash_device_temperature
# TYPE nicehash_device_temperature
nicehash_device_temperature{rig="windows",device="AMD Ryzen 9 3900X 12-Core Processor",status="DISABLED"} -1
nicehash_device_temperature{rig="windows",device="V_ID_9475 NVIDIA GeForce RTX 3060",status="MINING"} 73
nicehash_device_temperature{rig="windows",device="V_ID_9348 NVIDIA GeForce RTX 3070",status="MINING"} 59
nicehash_device_temperature{rig="worker1",device="AMD Ryzen 5 3500 6-Core Processor",status="DISABLED"} -1
nicehash_device_temperature{rig="worker1",device="EVGA NVIDIA GeForce RTX 3070",status="MINING"} 50
nicehash_device_temperature{rig="worker1",device="Gigabyte NVIDIA GeForce RTX 3070",status="MINING"} 48
nicehash_device_temperature{rig="worker1",device="V_ID_4156 NVIDIA GeForce RTX 3080",status="MINING"} 57
nicehash_device_temperature{rig="worker1",device="EVGA NVIDIA GeForce RTX 2080 Ti",status="MINING"} 74
# HELP nicehash_device_load
# TYPE nicehash_device_load
nicehash_device_load{rig="windows",device="AMD Ryzen 9 3900X 12-Core Processor",status="DISABLED"} 4
nicehash_device_load{rig="windows",device="V_ID_9475 NVIDIA GeForce RTX 3060",status="MINING"} 100
nicehash_device_load{rig="windows",device="V_ID_9348 NVIDIA GeForce RTX 3070",status="MINING"} 100
nicehash_device_load{rig="worker1",device="AMD Ryzen 5 3500 6-Core Processor",status="DISABLED"} 4
nicehash_device_load{rig="worker1",device="EVGA NVIDIA GeForce RTX 3070",status="MINING"} 100
nicehash_device_load{rig="worker1",device="Gigabyte NVIDIA GeForce RTX 3070",status="MINING"} 100
nicehash_device_load{rig="worker1",device="V_ID_4156 NVIDIA GeForce RTX 3080",status="MINING"} 100
nicehash_device_load{rig="worker1",device="EVGA NVIDIA GeForce RTX 2080 Ti",status="MINING"} 100
# HELP nicehash_device_speed
# TYPE nicehash_device_speed
nicehash_device_speed{rig="windows",device="AMD Ryzen 9 3900X 12-Core Processor",algo="null"} 0
nicehash_device_speed{rig="windows",device="V_ID_9475 NVIDIA GeForce RTX 3060",algo="DAGGERHASHIMOTO"} 47
nicehash_device_speed{rig="windows",device="V_ID_9348 NVIDIA GeForce RTX 3070",algo="DAGGERHASHIMOTO"} 60
nicehash_device_speed{rig="worker1",device="AMD Ryzen 5 3500 6-Core Processor",algo="null"} 0
nicehash_device_speed{rig="worker1",device="EVGA NVIDIA GeForce RTX 3070",algo="DAGGERHASHIMOTO"} 60
nicehash_device_speed{rig="worker1",device="Gigabyte NVIDIA GeForce RTX 3070",algo="DAGGERHASHIMOTO"} 60
nicehash_device_speed{rig="worker1",device="V_ID_4156 NVIDIA GeForce RTX 3080",algo="DAGGERHASHIMOTO"} 97
nicehash_device_speed{rig="worker1",device="EVGA NVIDIA GeForce RTX 2080 Ti",algo="DAGGERHASHIMOTO"} 59
# HELP nicehash_total_speed
# TYPE nicehash_total_speed
nicehash_total_speed 383
# HELP nicehash_speed_accepted
# TYPE nicehash_speed_accepted
nicehash_speed_accepted{rig="windows"} 123.99722130812546
nicehash_speed_accepted{rig="worker1"} 179.41695548326845
# HELP nicehash_rejected_r1_target_speed
# TYPE nicehash_rejected_r1_target_speed
nicehash_rejected_r1_target_speed{rig="windows"} 0
nicehash_rejected_r1_target_speed{rig="worker1"} 32.51579355315997
# HELP nicehash_rejected_r2_stale_speed
# TYPE nicehash_rejected_r2_stale_speed
nicehash_rejected_r2_stale_speed{rig="windows"} 0
nicehash_rejected_r2_stale_speed{rig="worker1"} 0
# HELP nicehash_rejected_r3_duplicate_speed
# TYPE nicehash_rejected_r3_duplicate_speed
nicehash_rejected_r3_duplicate_speed{rig="windows"} 0
nicehash_rejected_r3_duplicate_speed{rig="worker1"} 0
# HELP nicehash_rejected_r4_ntime_speed
# TYPE nicehash_rejected_r4_ntime_speed
nicehash_rejected_r4_ntime_speed{rig="windows"} 0
nicehash_rejected_r4_ntime_speed{rig="worker1"} 0
# HELP nicehash_rejected_r5_other_speed
# TYPE nicehash_rejected_r5_other_speed
nicehash_rejected_r5_other_speed{rig="windows"} 0
nicehash_rejected_r5_other_speed{rig="worker1"} 0
# HELP nicehash_total_rejected_speed
# TYPE nicehash_total_rejected_speed
nicehash_total_rejected_speed{rig="windows"} 0
nicehash_total_rejected_speed{rig="worker1"} 32.51579355315997
```

Grafana
-------
![grafana](https://user-images.githubusercontent.com/7776462/146219123-bb61ac43-31f6-406e-9e3b-50ef0a0c0809.png)

[Get Grafana Dashboard](https://grafana.com/grafana/dashboards/14718)


Tip
---

### parse error: Invalid numeric literal at line 1, column 11

You passed wrong `KEY`, `SEC` and `ORG`.
