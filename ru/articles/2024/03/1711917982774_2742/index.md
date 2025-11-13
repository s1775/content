---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MikroTik: Туннель IPsec (Site-to-Site)'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'network'
  - 'scripts'
tags:
  - 'mikrotik'
  - 'routeros'
  - 'ipsec'
authors:
  - 'KaiKimera'
sources:
  - ''
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-03-31T23:46:24+03:00'
publishDate: '2024-03-31T23:46:24+03:00'
lastMod: '2024-03-31T23:46:24+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '54a2b39f38b4ff0c6b54310f853da38f6ba33ec3'
uuid: '54a2b39f-38b4-5f0c-9b54-310f853da38f'
slug: '54a2b39f-38b4-5f0c-9b54-310f853da38f'

draft: 0
---

Объединение двух маршрутизаторов между собой при помощи туннеля {{< tag "IPsec" >}}.

<!--more-->

В WAN IP у меня используются суб-домены. К суб-доменам через A-запись в {{< tag "DNS" >}} прописаны внешние IP-адреса маршрутизаторов. При помощи скрипта из статьи {{< uuid "ff2ae66e-8e14-5c4a-baa6-0cd2e59f6517" >}} у меня каждый маршрутизатор имеет актуальный IP-адрес в суб-домене.

## Исходные данные

- Маршрутизатор `R1`:
  - WAN IP: `gw1.example.org`.
  - LAN IP: `10.1.0.1`.
  - Network: `10.1.0.0/16`.
- Маршрутизатор `R2`:
  - WAN IP: `gw2.example.org`.
  - LAN IP: `10.2.0.1`.
  - Network: `10.2.0.0/16`.

## Настройка маршрутизаторов

### Router #1

- Добавляем профиль {{< tag "IPsec" >}}:
  - Имя профиля: `ipsec-sts`.
  - Группа Diffie-Hellman (стойкость шифрования): `ecp384`.
  - Алгоритм шифрования: `aes-256`.

```text
/ip ipsec profile
add dh-group=ecp384 enc-algorithm=aes-256 name=ipsec-sts
```

- Добавляем представление {{< tag "IPsec" >}}:
  - Имя представления: `ipsec-sts`.
  - Алгоритм аутентификации: `sha256`.
  - Алгоритм шифрования: `aes-256-cbc`.
  - Группа Diffie-Hellman (стойкость шифрования): `ecp384`.

```text
/ip ipsec proposal
add auth-algorithms=sha256 enc-algorithms=aes-256-cbc name=ipsec-sts pfs-group=ecp384
```

- Добавляем {{< tag "IPsec" >}} peer:
  - Имя peer'а: `GW2`.
  - Внешний адрес `R2`: `gw2.example.org`.
  - Профиль: `ipsec-sts`.
  - Режим обмена: `ike2`.
  - Комментарий: `GW2`.

```text
/ip ipsec peer
add address="gw2.example.org" exchange-mode=ike2 name=GW2 profile=ipsec-sts comment="GW2"
```

- Добавляем идентификацию:
  - Peer: `GW2`.
  - Секретная фраза: `PassWord`.  
    *Секретная фраза должна быть одинаковой на обоих маршрутизаторах.*
  - Комментарий: `GW2`.

```text
/ip ipsec identity
add peer=GW2 secret="PassWord" comment="GW2"
```

- Добавляем политику {{< tag "IPsec" >}}:
  - Peer: `GW2`.
  - Туннель: `yes`.
  - Адрес локальной сети `R1`: `10.1.0.0/16`.
  - Адрес удалённой сети `R2`: `10.2.0.0/16`.
  - Действие: `encrypt`.
  - Представление: `ipsec-sts`.
  - Комментарий: `GW1-GW2`.

```text
/ip ipsec policy
add src-address=10.1.0.0/16 dst-address=10.2.0.0/16 tunnel=yes action=encrypt proposal=ipsec-sts peer=GW2 comment="GW1-GW2"
```

- Исключаем обработку трафика {{< tag "IPsec" >}}:
  - Адрес локальной сети `R1`: `10.1.0.0/16`.
  - Адрес удалённой сети `R2`: `10.2.0.0/16`.
  - Комментарий: `[IPsec] GW1-GW2`.

```text
/ip firewall nat
add chain=srcnat action=accept src-address=10.1.0.0/16 dst-address=10.2.0.0/16 place-before=0 comment="[IPsec] GW1-GW2"
```

- Настраивает фильтры брандмауэра:
  - Открыть порты `500` и `4500` по протоколу `UDP`.
  - Разрешить трафик по протоколу `ipsec-esp`.

```text
/ip firewall filter
add action=accept chain=input dst-port=500,4500 in-interface-list=WAN protocol=udp comment="[ROS] IPsec"
add action=accept chain=input in-interface-list=WAN protocol=ipsec-esp comment="[ROS] IPsec"
```

- Настраиваем обход отслеживания соединений {{< tag "IPsec" >}} для снижения нагрузки на CPU маршрутизатора:
  - Пакеты из удалённой сети `R2` `10.2.0.0/16` в локальную сеть `R1` `10.1.0.0/16`.
  - Пакеты из локальной сети `R1` `10.1.0.0/16` в удалённую сеть `R2` `10.2.0.0/16`.

```text
/ip firewall raw
add action=notrack chain=prerouting src-address=10.2.0.0/16 dst-address=10.1.0.0/16 comment="[IPsec] GW2-GW1"
add action=notrack chain=prerouting src-address=10.1.0.0/16 dst-address=10.2.0.0/16 comment="[IPsec] GW1-GW2"
```

### Router #2

- Добавляем профиль {{< tag "IPsec" >}}:
  - Имя профиля: `ipsec-sts`.
  - Группа Diffie-Hellman (стойкость шифрования): `ecp384`.
  - Алгоритм шифрования: `aes-256`.

```text
/ip ipsec profile
add dh-group=ecp384 enc-algorithm=aes-256 name=ipsec-sts
```

- Добавляем представление {{< tag "IPsec" >}}:
  - Имя представления: `ipsec-sts`.
  - Алгоритм аутентификации: `sha256`.
  - Алгоритм шифрования: `aes-256-cbc`.
  - Группа Diffie-Hellman (стойкость шифрования): `ecp384`.

```text
/ip ipsec proposal
add auth-algorithms=sha256 enc-algorithms=aes-256-cbc name=ipsec-sts pfs-group=ecp384
```

- Добавляем {{< tag "IPsec" >}} peer:
  - Имя peer'а: `GW1`.
  - Внешний адрес `R1`: `gw1.example.org`.
  - Профиль: `ipsec-sts`.
  - Режим обмена: `ike2`.
  - Комментарий: `GW1`.

```text
/ip ipsec peer
add address="gw1.example.org" exchange-mode=ike2 name=GW1 profile=ipsec-sts comment="GW1"
```

- Добавляем идентификацию:
  - Peer: `GW1`.
  - Секретная фраза: `PassWord`.  
    *Секретная фраза должна быть одинаковой на обоих маршрутизаторах.*
  - Комментарий: `GW1`.

```text
/ip ipsec identity
add peer=GW1 secret="PassWord" comment="GW1"
```

- Добавляем политику {{< tag "IPsec" >}}:
  - Peer: `GW1`.
  - Туннель: `yes`.
  - Адрес локальной сети `R2`: `10.2.0.0/16`.
  - Адрес удалённой сети `R1`: `10.1.0.0/16`.
  - Действие: `encrypt`.
  - Представление: `ipsec-sts`.
  - Комментарий: `GW2-GW1`.

```text
/ip ipsec policy
add src-address=10.2.0.0/16 dst-address=10.1.0.0/16 tunnel=yes action=encrypt proposal=ipsec-sts peer=GW1 comment="GW2-GW1"
```

- Исключаем обработку трафика {{< tag "IPsec" >}}:
  - Адрес локальной сети `R2`: `10.2.0.0/16`.
  - Адрес удалённой сети `R1`: `10.1.0.0/16`.
  - Комментарий: `[IPsec] GW2-GW1`.

```text
/ip firewall nat
add chain=srcnat action=accept src-address=10.2.0.0/16 dst-address=10.1.0.0/16 place-before=0 comment="[IPsec] GW2-GW1"
```

- Настраивает фильтры брандмауэра:
  - Открыть порты `500` и `4500` по протоколу `UDP`.
  - Разрешить трафик по протоколу `ipsec-esp`.

```text
/ip firewall filter
add action=accept chain=input dst-port=500,4500 in-interface-list=WAN protocol=udp comment="[ROS] IPsec"
add action=accept chain=input in-interface-list=WAN protocol=ipsec-esp comment="[ROS] IPsec"
```

- Настраиваем обход отслеживания соединений {{< tag "IPsec" >}} для снижения нагрузки на CPU маршрутизатора:
  - Пакеты из удалённой сети `R1` `10.1.0.0/16` в локальную сеть `R2` `10.2.0.0/16`.
  - Пакеты из локальной сети `R2` `10.2.0.0/16` в удалённую сеть `R1` `10.1.0.0/16`.

```text
/ip firewall raw
add action=notrack chain=prerouting src-address=10.1.0.0/16 dst-address=10.2.0.0/16 comment="[IPsec] GW1-GW2"
add action=notrack chain=prerouting src-address=10.2.0.0/16 dst-address=10.1.0.0/16 comment="[IPsec] GW2-GW1"
```

## Автоматизация

Сделал небольшой скрипт, который позволяет быстро развернуть туннель между двумя маршрутизаторами. Скрипт запускается отдельно на каждом из маршрутизаторов со своими настройками.

{{< file "ros.ipsec.rsc" >}}
