---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'MikroTik: Туннель WireGuard (Site-to-Site) + OSPF'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'network'
  - 'scripts'
tags:
  - 'mikrotik'
  - 'routeros'
  - 'wireguard'
  - 'ospf'
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

date: '2024-04-06T12:27:28+03:00'
publishDate: '2024-04-06T12:27:28+03:00'
lastMod: '2024-04-06T12:27:28+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '146e83d5f5715273ea29172bf5dc10fe0decbe6c'
uuid: '146e83d5-f571-5273-9a29-172bf5dc10fe'
slug: '146e83d5-f571-5273-9a29-172bf5dc10fe'

draft: 0
---

Объединение двух маршрутизаторов между собой при помощи туннеля {{< tag "WireGuard" >}}. При этом, обмениваться маршрутами эти маршрутизаторы будут через протокол {{< tag "OSPF" >}}.

<!--more-->

В качестве WAN IP я использую суб-домены. {{< tag "WireGuard" >}} позволяет использовать суб-домены как EndPoint'ы, а уже к суб-доменам приписываются IP-адреса маршрутизаторов. Подобная схема наиболее универсальная, так как не в каждом случае имеется внешний статический IP-адрес, но при использовании скрипта из статьи {{< uuid "ff2ae66e-8e14-5c4a-baa6-0cd2e59f6517" >}} любой адрес маршрутизатора можно превратить в статический через суб-домен.

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

- Создаём интерфейс {{< tag "WireGuard" >}}:
  - Номер порта: `51820`.
  - Название интерфейса: `wireguard-sts`.
  - Комментарий: `WireGuard (Site-to-Site)`.

```text
/interface wireguard
add listen-port=51820 name=wireguard-sts comment="WireGuard (Site-to-Site)"
```

- Прописываем интерфейсу IP-адрес `10.255.255.1/24`:
  - Адрес интерфейса: `10.255.255.1/24`.
  - Интерфейс: `wireguard-sts`.
  - Комментарий: `[WG] WireGuard (Site-to-Site)`.

```text
/ip address
add address=10.255.255.1/24 interface=wireguard-sts comment="[WG] WireGuard (Site-to-Site)"
```

- Указываем маршрут до удалённой сети `R2`:
  - Адрес удалённой сети `R2`: `10.2.0.0/16`.
  - Шлюз `R2`: `10.255.255.2`.
  - Комментарий: `[WG] GW1-GW2`.

```text
/ip route
add dst-address=10.2.0.0/16 gateway=10.255.255.2 comment="[WG] GW1-GW2"
```

- Настраиваем фильтры брандмауэра:
  - Открыть порт `51820`.
  - Разрешить трафик из удалённой сети `R2` `10.2.0.0/16` в локальную сеть `R1` `10.1.0.0/16`.
  - Разрешить трафик из локальной сети `R1` `10.1.0.0/16` в удалённую сеть `R2` `10.2.0.0/16`.

```text
/ip firewall filter
add action=accept chain=input dst-port=51820 in-interface-list=WAN protocol=udp comment="[WG] WireGuard (Site-to-Site)"
add action=accept chain=forward src-address=10.2.0.0/16 dst-address=10.1.0.0/16 comment="[WG] GW2-GW1"
add action=accept chain=forward src-address=10.1.0.0/16 dst-address=10.2.0.0/16 comment="[WG] GW1-GW2"
```

### Router #2

- Создаём интерфейс {{< tag "WireGuard" >}}:
  - Номер порта: `51820`.
  - Название интерфейса: `wireguard-sts`.
  - Комментарий: `WireGuard (Site-to-Site)`.

```text
/interface wireguard
add listen-port=51820 name=wireguard-sts comment="WireGuard (Site-to-Site)"
```

- Прописываем интерфейсу IP-адрес `10.255.255.2/24`:
  - Адрес интерфейса: `10.255.255.2/24`.
  - Интерфейс: `wireguard-sts`.
  - Комментарий: `[WG] WireGuard (Site-to-Site)`.

```text
/ip address
add address=10.255.255.2/24 interface=wireguard-sts comment="WireGuard (Site-to-Site)"
```

- Указываем маршрут до удалённой сети `R1`:
  - Адрес удалённой сети `R1`: `10.1.0.0/16`.
  - Шлюз `R1`: `10.255.255.1`.
  - Комментарий: `[WG] GW2-GW1`.

```text
/ip route
add dst-address=10.1.0.0/16 gateway=10.255.255.1 comment="[WG] GW2-GW1"
```

- Настраиваем фильтры брандмауэра:
  - Открыть порт `51820`.
  - Разрешить трафик из удалённой сети `R1` `10.1.0.0/16` в локальную сеть `R2` `10.2.0.0/16`.
  - Разрешить трафик из локальной сети `R2` `10.2.0.0/16` в удалённую сеть `R1` `10.1.0.0/16`.

```text
/ip firewall filter
add action=accept chain=input dst-port=51820 in-interface-list=WAN protocol=udp comment="[WG] WireGuard (Site-to-Site)"
add action=accept chain=forward src-address=10.1.0.0/16 dst-address=10.2.0.0/16 comment="[WG] GW1-GW2"
add action=accept chain=forward src-address=10.2.0.0/16 dst-address=10.1.0.0/16 comment="[WG] GW2-GW1"
```

### Автоматизация

Написал небольшой сценарий для разворачивания интерфейса WireGuard на маршрутизаторах. Настройки сценария, естественно, разные под каждый из маршрутизаторов. А вот добавлять peer'ы придётся вручную.

{{< file "ros.wg.rsc" >}}

## Добавление peer'ов

### Router #1

- Добавить маршрутизатор `R2` в **Peers**:
  - Интерфейс: `wireguard-sts`.
  - Публичный ключ маршрутизатора `R2`: `<public-key>`.  
    *Публичный ключ берём от маршрутизатора `R2`.*
  - Адрес EndPoint маршрутизатора `R2`: `gw2.example.org`.
  - Порт EndPoint маршрутизатора `R2`: `51820`.
  - Разрешённые адреса:
    - `10.2.0.0/16` - адрес удалённой сети маршрутизатора `R2`.
    - `10.255.255.0/24` - общий адрес интерфейсов `wireguard-sts` обоих маршрутизаторов.
    - `224.0.0.5/32` - мультикастовый адрес протокола {{< tag "OSPF" >}}.  
      *Без этого параметра не будет работать протокол {{< tag "OSPF" >}}.*
  - Комментарий: `[WG] GW2`.

```text
/interface wireguard peers
add allowed-address=10.2.0.0/16,10.255.255.0/24,224.0.0.5/32 endpoint-address=gw2.example.org endpoint-port=51820 interface=wireguard-sts public-key="<public-key>" comment="[WG] GW2"
```

### Router #2

- Добавить маршрутизатор `R1` в **Peers**:
  - Интерфейс: `wireguard-sts`.
  - Публичный ключ маршрутизатора `R1`: `<public-key>`.  
    *Публичный ключ берём от маршрутизатора `R1`.*
  - Адрес EndPoint маршрутизатора `R1`: `gw1.example.org`.
  - Порт EndPoint маршрутизатора `R1`: `51820`.
  - Разрешённые адреса:
    - `10.1.0.0/16` - адрес удалённой сети маршрутизатора `R1`.
    - `10.255.255.0/24` - общий адрес интерфейсов `wireguard-sts` обоих маршрутизаторов.
    - `224.0.0.5/32` - мультикастовый адрес протокола {{< tag "OSPF" >}}.  
      *Без этого параметра не будет работать протокол {{< tag "OSPF" >}}.*
  - Комментарий: `[WG] GW1`.

```text
/interface wireguard peers
add allowed-address=10.1.0.0/16,10.255.255.0/24,224.0.0.5/32 endpoint-address=gw1.example.org endpoint-port=51820 interface=wireguard-sts public-key="<public-key>" comment="[WG] GW1"
```

## Настройка OSPF

{{< alert "info" >}}
На каждом маршрутизаторе настройки полностью идентичные.
{{< / alert >}}

- Создаём инстанс:
  - Название: `ospf-instance-wg`.

```text
/routing ospf instance
add name=ospf-instance-wg
```

- Добавляем Area:
  - Название Area: `backbone`.
  - Название инстанса: `ospf-instance-wg`.

```text
/routing ospf area
add instance=ospf-instance-wg name=backbone
```

- Настраиваем шаблоны:
  - Интерфейс `bridge1`.
    - Area: `backbone`.
  - Интерфейс `wireguard-sts`.
    - Area: `backbone`.
    - Type: `PTP` (Point-to-Point).

```text
/routing ospf interface-template
add area=backbone interfaces=bridge1
add area=backbone interfaces=wireguard-sts type=ptp
```

- Настраиваем фильтры брандмауэра:
  - Разрешить протокол {{< tag "OSPF" >}} на интерфейсе `wireguard-sts`.

```text
/ip firewall filter
add action=accept chain=input in-interface=wireguard-sts protocol=ospf comment="[WG] OSPF"
```
