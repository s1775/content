---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: '1775735825851_8030'
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

date: '2026-04-09T14:57:08+03:00'
publishDate: '2026-04-09T14:57:08+03:00'
lastMod: '2026-04-09T14:57:08+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '9af94f1c099a5c889f15f31f4f36944cd1ad8bfd'
uuid: '9af94f1c-099a-5c88-af15-f31f4f36944c'
slug: '9af94f1c-099a-5c88-af15-f31f4f36944c'

draft: 1
---

Summary...

<!--more-->

```bash
curl -fsSL 'https://sing-box.app/gpg.key' | gpg --dearmor -o '/etc/apt/keyrings/sagernet.gpg'
```

```bash
echo -e "X-Repolib-Name: SagerNet\nTypes: deb\nURIs: https://deb.sagernet.org\nSuites: *\nComponents: *\nSigned-By: /etc/apt/keyrings/sagernet.gpg\n" | tee '/etc/apt/sources.list.d/sagernet.sources' > '/dev/null'
```
