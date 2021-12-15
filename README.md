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

We need readonly permissions. Do not forget read wallet permission.

![](https://user-images.githubusercontent.com/7776462/146216064-695338e5-5e78-4659-87ee-23b9d4d8b583.png)


Grafana
-------
![grafana](https://user-images.githubusercontent.com/7776462/146219123-bb61ac43-31f6-406e-9e3b-50ef0a0c0809.png)

[Get Grafana Dashboard](https://grafana.com/grafana/dashboards/14718)


Tip
---

### parse error: Invalid numeric literal at line 1, column 11

You passed wrong `KEY`, `SEC` and `ORG`.
