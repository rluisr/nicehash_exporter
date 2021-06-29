nicehash_exporter
=================

About Textfile Collector [see](https://github.com/prometheus/node_exporter#textfile-collector)

Run
---

Before using this, replace `KEY`, `SEC` and `ORG` on `run.sh`

```bash
$ ./run.sh | sponge /etc/node_exporter/collector/nicehash.prom
```

Output
-------
```
# HELP nicehash_active_devices
# TYPE nicehash_active_devices
nicehash_active_devices 3
# HELP nicehash_device_temperature
# TYPE nicehash_device_temperature
nicehash_device_temperature{rig="windows",device="AMD Ryzen 9 3900X 12-Core Processor",status="DISABLED"} -1
nicehash_device_temperature{rig="windows",device="EVGA NVIDIA GeForce RTX 2080 Ti",status="MINING"} 70
nicehash_device_temperature{rig="worker1",device="AMD Ryzen 5 3500 6-Core Processor",status="DISABLED"} -1
nicehash_device_temperature{rig="worker1",device="V_ID_8710 NVIDIA GeForce RTX 3080",status="MINING"} 60
nicehash_device_temperature{rig="worker1",device="V_ID_9475 NVIDIA GeForce RTX 3060",status="MINING"} 65
# HELP nicehash_device_load
# TYPE nicehash_device_load
nicehash_device_load{rig="windows",device="AMD Ryzen 9 3900X 12-Core Processor",status="DISABLED"} 0
nicehash_device_load{rig="windows",device="EVGA NVIDIA GeForce RTX 2080 Ti",status="MINING"} 100
nicehash_device_load{rig="worker1",device="AMD Ryzen 5 3500 6-Core Processor",status="DISABLED"} 0
nicehash_device_load{rig="worker1",device="V_ID_8710 NVIDIA GeForce RTX 3080",status="MINING"} 100
nicehash_device_load{rig="worker1",device="V_ID_9475 NVIDIA GeForce RTX 3060",status="MINING"} 100
```
