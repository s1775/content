---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'LLM: Установка и настройка'
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
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '0'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2026-11-02T17:10:01+03:00'
publishDate: '2026-11-02T17:10:01+03:00'
lastMod: '2026-11-02T17:10:01+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'ac3b9c23fbc704c159c1e23f7cb80bcd350ea549'
uuid: 'ac3b9c23-fbc7-54c1-99c1-e23f7cb80bcd'
slug: 'ac3b9c23-fbc7-54c1-99c1-e23f7cb80bcd'

draft: 1
---

Summary...

<!--more-->

## Ollama

- Скачать файл `compose.yml` в директорию `~/ollama`:

```bash
f=('compose'); d="${HOME}/ollama"; s='https://libsys.ru/ru/2026/11/ac3b9c23-fbc7-54c1-99c1-e23f7cb80bcd'; [[ ! -d "${d}" ]] && mkdir "${d}"; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.yml" "${s}/${i}.ollama.yml"; done && cd "${d}" || return
```

- Запустить `compose.yml`:

```bash
podman compose up -d
```

- Проверить контейнеры:

```bash
podman ps -a
```

- Проверить логи контейнера `ollama`:

```bash
podman logs -f ollama
```

- Проверить логи контейнера `webui`:

```bash
podman logs -f webui
```

- Скачать LLM `ollama:qwen2.5`:

```bash
podman exec -it ollama ollama run qwen2.5
```

- Удалить контейнеры `ollama` и `webui`:

```bash
podman rm ollama webui
```

## vLLM

- Скачать файл `compose.yml` в директорию `~/vllm`:

```bash
f=('compose'); d="${HOME}/vllm"; s='https://libsys.ru/ru/2026/11/ac3b9c23-fbc7-54c1-99c1-e23f7cb80bcd'; [[ ! -d "${d}" ]] && mkdir "${d}"; for i in "${f[@]}"; do curl -fsSLo "${d}/${i}.yml" "${s}/${i}.vllm.yml"; done && cd "${d}" || return
```

- Запустить `compose.yml`:

```bash
podman compose up -d
```

- Проверить контейнеры:

```bash
podman ps -a
```

- Проверить логи контейнера `vllm`:

```bash
podman logs -f vllm
```

- Проверить логи контейнера `webui`:

```bash
podman logs -f webui
```

- Удалить контейнеры `vllm` и `webui`:

```bash
podman rm vllm webui
```

## Podman Compose

- Обновление контейнеров:

```bash
podman compose pull && podman compose down && podman image prune -f
```
