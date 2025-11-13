---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Cisco: Базовая настройка'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'network'
tags:
  - 'cisco'
  - 'ios'
authors:
  - 'KaiKimera'
sources:
  - 'https://ciscozine.com/nat-and-pat-a-complete-explanation/'
  - 'https://danjmcintyre.com/2020/02/13/cisco-router-dual-wan-uplinks-with-nat/'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2024-04-25T22:16:43+03:00'
publishDate: '2024-05-13T18:00:00+03:00'
lastMod: '2024-05-13T18:00:00+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '8caf49e38f13d145d0ab8ba1f2cb1c37994264a7'
uuid: '8caf49e3-8f13-5145-90ab-8ba1f2cb1c37'
slug: '8caf49e3-8f13-5145-90ab-8ba1f2cb1c37'

draft: 0
---

Представлю базовый конфигурационный файл для маршрутизатора {{< tag "Cisco" >}}. При помощи него можно быстро запустить маршрутизатор, предварительно подставив свои значения.

<!--more-->

## Параметры конфигурации

- Пароль администратора (`enable`): `qwerty-en`.
- Пользователи:
  - `admin:qwerty-admin`.
- Интерфейсы:
  - `FastEthernet0/0`:
    - IP: `DHCP`.
  - `FastEthernet0/1`:
    - IP: `10.88.0.1/16`.
  - `Loopback0`:
    - IP: `10.90.10.1/32`.
  - `Loopback1`:
    - IP: `10.90.20.1/32`.
- Локальная сеть:
  - Маска: `10.88.0.0/16`.
  - Домен: `home.lan`.

### Сервисы

- `service password-encryption` - включить шифрования паролей в консоли, терминале и конфигурации.
- `service timestamps debug datetime msec localtime show-timezone` - установить местное время в режиме отладки.
- `service timestamps log datetime msec localtime show-timezone` - установить местное время в режиме логирования.
- `service tcp-keepalives-in` и `service tcp-keepalives-out` - включить поддержку активности сеансов TCP для входящих и исходящих подключений. Эти параметры позволяют проверять доступность удалённого устройства при помощи специальных keepalive-пакетов, а полуоткрытые и потерянные соединения убудут удалены с локального устройства Cisco.
- `service sequence-numbers` - включить нумерование сообщений при логировании событий. Параметр позволяет выяснить потерянные сообщения из-за `rate-limit` на Cisco или когда эти сообщения передаются по сети с использованием syslog по протоколу UDP.
- `no service pad` - отключить сервис PAD (X.25).
- `no service udp-small-servers` и `no service tcp-small-servers` - отключить использование небольших TCP & UDP серверов.
- `no service finger` - отключить протокол Finger.

### Основные настройки

- `clock timezone UTC 3` и `clock update-calendar` - установить часовой пояс `+3` и обновить встроенные часы Cisco согласно пользовательским настройкам.
- `hostname gw1` - установить имя хоста в Cisco.
- `logging buffered 4096` - зарезервировать в оперативной памяти 4096 КБ для записи логов. При заполнении буфера, старые сообщения будут перезаписаны новыми.
- `logging console critical` - включить отображение в консоли (RS-232) только критических сообщений.
- `ip cef` - включить Cisco Express Forwarding (CEF). Cisco Express Forwarding (CEF) - технология высокоскоростной маршрутизации/коммутации пакетов, использующаяся в маршрутизаторах и коммутаторах третьего уровня фирмы Cisco Systems, и позволяющая добиться более быстрой и эффективной обработки транзитного трафика.
- `ip multicast-routing` - включить пересылку multicast-пакетов.
- `ip tcp path-mtu-discovery` - включить функцию обнаружения пути TCP MTU для соединений TCP, инициированных маршрутизаторами (например, BGP и Telnet).
- `ip tcp selective-ack` - повысить производительность TCP на каналах, где есть потери пакетов. Если в пределах окна было потеряно несколько пакетов, SACK позволяет повторно отправить только потерянные пакеты, а не все пакеты. [RFC2018](http://www.ietf.org/rfc/rfc2018.txt).
- `ip tcp timestamp` - включить более точное измерение RTT для повышения производительности TCP. [RFC1323](http://www.ietf.org/rfc/rfc1323.txt).
- `no ip source-route` - отключить функцию указания отдельными пакетами маршрута. В современных сетях эта функция не используется и является небезопасной.
- `no ip bootp server` - отключить Bootstrap Protocol (BOOTP). BootP это сетевой протокол прикладного уровня, используемый для автоматического получения клиентом IP-адреса.
- `memory reserve critical 4096` - зарезервировать в оперативной памяти 4096 КБ для отображения критических уведомлений. Этот объём памяти не может превышать 25% от общего объёма оперативной памяти. По умолчанию: 100 КБ.
- `memory reserve console 512` - зарезервировать в оперативной памяти 512 КБ для доступа к консоли. Увеличение памяти обеспечивает доступ к консоли для устранения неполадок или других административных задач и поддерживает оптимальный уровень производительности. По умолчанию: 256 КБ.

### Аккаунты

- `aaa new-model` - включение новой модели системы аутентификации авторизации и учета событий, встроенная в операционную систему {{< tag "Cisco" >}} IOS.
- `aaa authentication login default local` - база логинов и паролей хранится на устройстве {{< tag "Cisco" >}}.
- `aaa authentication ppp default local` - локальная аутентификация для сеансов PPP.
- `enable password qwerty-en` - пароль для режима `enable`.
- `username admin privilege 15 password qwerty-admin` - добавление нового пользователя `admin`.
  - `admin` - имя нового пользователя.
  - `privilege 15` - уровень привилегий (15 - максимальный).
  - `qwerty-admin` - пароль нового пользователя.

### Терминал

- `line con 0`
  - `logging synchronous`
  - `exec-timeout 60 0`
- `line vty 0 4`
  - `access-class ACL_VTY in`
  - `logging synchronous`
  - `privilege level 15`
  - `transport input telnet ssh`
  - `exec-timeout 60 0`
- `line aux 0`
  - `transport input none`
  - `transport output none`
  - `no exec`
  - `exec-timeout 0 1`
  - `no password`

### SSH

- `ip ssh authentication-retries 5` - установить 5 попыток аутентификации на локальном SSH-сервере Cisco.
- `ip ssh version 2` - явно указать использование SSH версии 2.

### SNMP

- `snmp-server community CISCO_ID ro ACL_SNMP_RO` - разрешить хостам из `ACL_SNMP_RO` получать информацию от SNMP-сервера Cisco с идентификатором `CISCO_ID`.
  - `CISCO_ID` - идентификатор SNMP Cisco.
  - `ro` - доступ только на чтение.
  - `ACL_SNMP_RO` - лист доступа для подключения к SNMP Cisco.
- `snmp-server location Petrovka 37, 2 floor, room 220` - указать информацию по местонахождению устройства в SNMP-сервере Cisco.
  - `Petrovka 37, 2 floor, room 220` - адрес устройства Cisco.
- `snmp-server contact mail@example.org` - указать контактную информацию в SNMP-сервере Cisco.
  - `mail@example.org` - контактный адрес электронной почты.

### Интерфейсы

- `interface FastEthernet0/0` - внешний интерфейс `FastEthernet0/0`.
  - `ip address dhcp` - включение получения IP-адреса от DHCP-сервера.
  - `ip nat outside` - определение интерфейса в качестве внешнего.
- `interface FastEthernet0/1` - внутренний интерфейс `FastEthernet0/1`.
  - `ip address 10.88.0.1 255.255.0.0` - IP-адрес интерфейса и маска подсети.
  - `ip nat inside` - определение интерфейса в качестве внутреннего.
- `interface Loopback0` - loopback-интерфейс `Loopback0`.
  - `ip address 10.90.10.1 255.255.255.255` - IP-адрес интерфейса и маска подсети.
- `interface Loopback1` - loopback-интерфейс `Loopback1`.
  - `ip address 10.90.20.1 255.255.255.255` - IP-адрес интерфейса и маска подсети.
- `no ip http server` - отключить встроенный HTTP-сервер.
- `no ip http secure-server` - отключить встроенный HTTPS-сервер.

### NTP

- `ntp update-calendar` - обновить встроенные часы Cisco согласно настройкам NTP.
- `ntp server 194.190.168.1` - сервер NTP.
  - `194.190.168.1` - IP-адрес сервера NTP.

### DNS

- `ip domain timeout 2` - число попыток отрезолвить хост.
- `ip domain name home.lan` - имя домена по умолчанию. Используется для определения имени домена, которое будет использоваться для дополнения неполных имен хостов (имен, состоящих только из имени хоста).
- `ip name-server 1.1.1.1` - внешний DNS-сервер #1.
  - `1.1.1.1` - IP-адрес внешнего DNS-сервера #1.
- `ip name-server 8.8.8.8` - внешний DNS-сервер #1.
  - `8.8.8.8` - IP-адрес внешнего DNS-сервера #2.
- `ip dns server` - включить локальный DNS-сервер Cisco.

### DHCP

- `service dhcp FastEthernet0/1` - включить локальный DHCP-сервер только на интерфейсе `FastEthernet0/1`.
- `ip dhcp excluded-address 10.88.0.1` - исключить адрес `10.88.0.1` из пула адресов локального DHCP-сервера.
- `ip dhcp excluded-address 10.88.0.2 10.88.200.0` - исключить диапазон от `10.88.0.2` до `10.88.200.0` из пула адресов локального DHCP-сервера.
- `ip dhcp pool LAN` - конфигурация локального DHCP-сервера.
  - `network 10.88.0.0 255.255.0.0` - адрес локальной сети.
  - `default-router 10.88.0.1` - шлюз по умолчанию.
  - `domain-name home.lan` - домен локальной сети.
  - `dns-server 10.88.0.1` - DNS-сервер локальной сети.

### NAT

- `ip nat inside source route-map MAP_ETH_00 interface FastEthernet0/0 overload`

### Листы доступа

- `ip access-list standard ACL_VTY` - список хостов для доступа к терминалу.
- `ip access-list standard ACL_NAT` - список хостов за NAT. Разрешить эти адреса из локальной сети транслировать во внешний мир.

## Скрипт конфигурации

{{< file "cisco.router.ios" "properties" >}}
