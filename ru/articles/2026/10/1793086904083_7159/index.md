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

## Пользователи

- Создать пользователей `llm` и `ui`:

```bash
for i in 'llm' 'ui'; do echo "--- CREATING USER: ${i}" && useradd -m -G 'sudo' -s '/bin/zsh' -c "${i}" "${i}" && passwd "${i}"; done
```

- Создать директорию `data` у пользователей:

```bash
for i in 'llm' 'ui'; do install -d -o "${i}" -g "${i}" "/home/${i}/data"; done
```

## vLLM

- Установить vLLM:

```bash
uv venv --python 3.12 --seed --managed-python && source '.venv/bin/activate' && uv pip install vllm --torch-backend=auto
```

{{< alert "tip" >}}
Для установки vLLM на CPU без видеокарты, можно воспользоваться следующей командой:

```bash
uv venv --python 3.12 --seed --managed-python && source '.venv/bin/activate' && uv pip install vllm --extra-index-url 'https://wheels.vllm.ai/0.32.0/cpu' --torch-backend cpu --constraint <(echo 'triton @ https://github.com/triton-lang/triton-cpu/releases/download/v3.8.0/triton-3.8.0+cpu-cp312-abi3-manylinux_2_27_x86_64.manylinux_2_28_x86_64.whl')
```
{{< /alert >}}

- Запустить vLLM с моделью `Qwen2.5-1.5B-Instruct`:

```bash
vllm serve 'Qwen/Qwen2.5-1.5B-Instruct' --gpu_memory_utilization='0.5'
```

## Open WebUI

- Установить WebUI

```bash
uv venv --python=3.12 --seed --managed-python && source '.venv/bin/activate' && uv pip install "open-webui[all]"
```

- Запустить WebUI с директорией `data` для хранения данных:

```bash
DATA_DIR="${HOME}/data" open-webui serve
```
