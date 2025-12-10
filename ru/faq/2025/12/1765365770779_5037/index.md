---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'iRedMail: "Bad interpreter: No such file or directory"'
description: ''
icon: 'far fa-circle-question'
tags:
  - 'mail'
  - 'iredmail'
  - 'fail2ban'
  - 'bash'
authors:
  - 'KaiKimera'
sources:
  - 'https://github.com/iredmail/iRedMail/issues/290'
  - 'https://forum.iredmail.org/topic20910-fail2ban-error-command-not-found.html'

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2025-12-10T14:22:52+03:00'
publishDate: '2025-12-10T14:22:52+03:00'
lastMod: '2025-12-10T14:22:52+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'faq'
hash: '15b81e30eefd6311e93d9da55432bc7b49e51968'
uuid: '15b81e30-eefd-5311-893d-9da55432bc7b'
slug: '15b81e30-eefd-5311-893d-9da55432bc7b'

draft: 0
---

При установке v1.7.4 в логах fail2ban появляется ошибка `bad interpreter: No such file or directory'`. Как исправить?

<!--more-->

Полная версия ошибки:

```bash
stderr: '/bin/sh: /usr/local/bin/fail2ban_banned_db: /usr/local/bin/bash: bad interpreter: No such file or directory' 
```
