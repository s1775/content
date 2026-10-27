---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: '1793086904083_7159'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cat_01'
  - 'cat_02'
  - 'cat_03'
tags:
  - 'tag_01'
  - 'tag_02'
  - 'tag_03'
authors:
  - 'JohnDoe'
  - 'JaneDoe'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2026-10-27T10:41:48+03:00'
publishDate: '2026-10-27T10:41:48+03:00'
lastMod: '2026-10-27T10:41:48+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '0a56f208e99e70aef1112c432e3e563891e53b26'
uuid: '0a56f208-e99e-50ae-8111-2c432e3e5638'
slug: '0a56f208-e99e-50ae-8111-2c432e3e5638'

draft: 1
---

Summary...

<!--more-->

```bash
podman pull docker.io/ollama/ollama:latest
```

```bash
podman pull ghcr.io/open-webui/open-webui:main
```

```bash
podman run -d --name 'open-webui' -p 3000:8080 -v 'open-webui:/app/backend/data' -e WEBUI_SECRET_KEY='secret_key' --restart 'always' 'ghcr.io/open-webui/open-webui:main'
```

```bash
podman run -d --name 'ollama' -p 11434:11434 -v 'ollama:/root/.ollama' --restart 'always' 'docker.io/ollama/ollama:latest'
```
