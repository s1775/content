---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Проверка DNS-записей домена'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'network'
  - 'linux'
  - 'windows'
tags:
  - 'dns'
  - 'dig'
  - 'drill'
  - 'nslookup'
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

date: '2024-03-27T17:25:34+03:00'
publishDate: '2024-04-15T13:03:00+03:00'
lastMod: '2024-03-27T17:25:34+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'bd4f198b907ebc14f0c6a7c032891ce085bf80aa'
uuid: 'bd4f198b-907e-5c14-90c6-a7c032891ce0'
slug: 'bd4f198b-907e-5c14-90c6-a7c032891ce0'

draft: 0
---

Когда требуется узнать информацию о домене, можно воспользоваться локальными утилитами для диагностики его DNS-записей.

<!--more-->

## Общая информация

Рассмотрим запросы общей информации по доменам.

### Dig

Получить общую информацию по домену в `Dig`:

```bash
dig example.org
```

Результат запроса:

```terminal {lang="dns"}
dig google.com

; <<>> DiG 9.18.24-1-Debian <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 19217
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             112     IN      A       173.194.222.101
google.com.             112     IN      A       173.194.222.139
google.com.             112     IN      A       173.194.222.113
google.com.             112     IN      A       173.194.222.138
google.com.             112     IN      A       173.194.222.100
google.com.             112     IN      A       173.194.222.102

;; Query time: 4 msec
;; SERVER: 172.16.18.22#53(172.16.18.22) (UDP)
;; WHEN: Mon Apr 15 09:14:51 UTC 2024
;; MSG SIZE  rcvd: 135
```

Где:
- `;; SERVER: 172.16.18.22#53(172.16.18.22) (UDP)` - сервер DNS, с которого пришёл ответ.

### Drill

Получить общую информацию по домену в `Drill`:

```bash
drill example.org
```

Результат запроса:

```terminal {lang="dns"}
drill google.com

;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 45117
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; QUESTION SECTION:
;; google.com.  IN      A

;; ANSWER SECTION:
google.com.     184     IN      A       216.58.210.142

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 3 msec
;; SERVER: 10.1.0.1
;; WHEN: Wed Mar 27 17:41:27 2024
;; MSG SIZE  rcvd: 44
```

Где:
- `;; SERVER: 172.16.18.22#53(172.16.18.22) (UDP)` - сервер DNS, с которого пришёл ответ.

### NSLookUp

Получить общую информацию по домену в `NSLookUp`:

```bash
nslookup example.org
```

Результат запроса:

```terminal {lang="dns"}
nslookup google.com

Server:         172.16.18.22
Address:        172.16.18.22#53

Non-authoritative answer:
Name:   google.com
Address: 173.194.222.138
Name:   google.com
Address: 173.194.222.101
Name:   google.com
Address: 173.194.222.100
Name:   google.com
Address: 173.194.222.102
Name:   google.com
Address: 173.194.222.113
Name:   google.com
Address: 173.194.222.139
Name:   google.com
Address: 2a00:1450:4010:c0b::71
Name:   google.com
Address: 2a00:1450:4010:c0b::66
Name:   google.com
Address: 2a00:1450:4010:c0b::64
Name:   google.com
Address: 2a00:1450:4010:c0b::65
```

Где:
- `Server: 172.16.18.22` - сервер DNS, с которого пришёл ответ.

## Информация по DNS-записям

В отдельных случаях требуется получить информацию по конкретным DNS-записям домена.

### Dig

Получить информацию по MX-записи домена в `Dig`:

```bash
dig mx example.org
```

Результат запроса:

```terminal {lang="dns"}
dig mx google.com

; <<>> DiG 9.18.24-1-Debian <<>> mx google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 61308
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 10

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;google.com.                    IN      MX

;; ANSWER SECTION:
google.com.             300     IN      MX      10 smtp.google.com.

;; ADDITIONAL SECTION:
smtp.google.com.        300     IN      A       64.233.161.26
smtp.google.com.        300     IN      A       64.233.162.27
smtp.google.com.        300     IN      A       64.233.163.26
smtp.google.com.        300     IN      A       64.233.163.27
smtp.google.com.        300     IN      A       173.194.220.26
smtp.google.com.        300     IN      AAAA    2a00:1450:4010:c01::1b
smtp.google.com.        300     IN      AAAA    2a00:1450:4010:c05::1b
smtp.google.com.        300     IN      AAAA    2a00:1450:4010:c06::1a
smtp.google.com.        300     IN      AAAA    2a00:1450:4010:c06::1b

;; Query time: 48 msec
;; SERVER: 172.16.18.22#53(172.16.18.22) (UDP)
;; WHEN: Mon Apr 15 09:17:29 UTC 2024
;; MSG SIZE  rcvd: 252
```

Где:
- `google.com. 300 IN MX 10 smtp.google.com.` - MX-запись домена `google.com`.

### Drill

Получить информацию по MX-записи домена в `Drill`:

```bash
drill mx example.org
```

Результат запроса:

```terminal {lang="dns"}
drill mx google.com

;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 51703
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 5
;; QUESTION SECTION:
;; google.com.  IN      MX

;; ANSWER SECTION:
google.com.     30      IN      MX      10 smtp.google.com.

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:
smtp.google.com.        30      IN      A       142.250.150.27
smtp.google.com.        30      IN      A       64.233.161.27
smtp.google.com.        30      IN      A       64.233.161.26
smtp.google.com.        30      IN      A       64.233.162.27
smtp.google.com.        30      IN      A       142.250.150.26

;; Query time: 4 msec
;; SERVER: 10.1.0.1
;; WHEN: Wed Mar 27 17:41:53 2024
;; MSG SIZE  rcvd: 136
```

Где:
- `google.com. 300 IN MX 10 smtp.google.com.` - MX-запись домена `google.com`.

### NSLookUp

Получить информацию по MX-записи домена в `NSLookUp`:

```bash
nslookup -type=mx example.org
```

Результат запроса:

```terminal {lang="dns"}
nslookup -type=mx google.com

Server:  gw1.lan
Address:  10.1.0.1

Non-authoritative answer:
google.com      MX preference = 10, mail exchanger = smtp.google.com

smtp.google.com internet address = 173.194.221.27
smtp.google.com internet address = 173.194.222.27
smtp.google.com internet address = 173.194.222.26
smtp.google.com internet address = 74.125.205.27
smtp.google.com internet address = 173.194.220.26
```

Где:
- `google.com MX preference = 10, mail exchanger = smtp.google.com` - MX-запись домена `google.com`.

## Трассировка

Трассировка запросов к домену.

### Dig

Получить информацию по трассировке запросов к домену в `Dig`:

```bash
dig +trace example.org
```

Результат запроса:

```terminal {lang="dns"}
dig +trace google.com

; <<>> DiG 9.18.24-1-Debian <<>> +trace google.com
;; global options: +cmd
.                       86400   IN      NS      k.root-servers.net.
.                       86400   IN      NS      d.root-servers.net.
.                       86400   IN      NS      h.root-servers.net.
.                       86400   IN      NS      f.root-servers.net.
.                       86400   IN      NS      g.root-servers.net.
.                       86400   IN      NS      l.root-servers.net.
.                       86400   IN      NS      j.root-servers.net.
.                       86400   IN      NS      e.root-servers.net.
.                       86400   IN      NS      a.root-servers.net.
.                       86400   IN      NS      b.root-servers.net.
.                       86400   IN      NS      m.root-servers.net.
.                       86400   IN      NS      c.root-servers.net.
.                       86400   IN      NS      i.root-servers.net.
;; Received 824 bytes from 172.16.18.22#53(172.16.18.22) in 4 ms

com.                    172800  IN      NS      a.gtld-servers.net.
com.                    172800  IN      NS      b.gtld-servers.net.
com.                    172800  IN      NS      c.gtld-servers.net.
com.                    172800  IN      NS      d.gtld-servers.net.
com.                    172800  IN      NS      e.gtld-servers.net.
com.                    172800  IN      NS      f.gtld-servers.net.
com.                    172800  IN      NS      g.gtld-servers.net.
com.                    172800  IN      NS      h.gtld-servers.net.
com.                    172800  IN      NS      i.gtld-servers.net.
com.                    172800  IN      NS      j.gtld-servers.net.
com.                    172800  IN      NS      k.gtld-servers.net.
com.                    172800  IN      NS      l.gtld-servers.net.
com.                    172800  IN      NS      m.gtld-servers.net.
com.                    86400   IN      DS      19718 13 2 8ACBB0CD28F41250A80A491389424D341522D946B0DA0C0291F2D3D7 71D7805A
com.                    86400   IN      RRSIG   DS 8 1 86400 20240428050000 20240415040000 5613 . B5vi45DiEHj1RSe0d4ZMvighZNLSPj6ORov+tN+g4MASLSudADHgjP9i 32HBqh6IyFeK8aIR3Jvuvk61Z+2Z0oKjX6rUisVxf9RcQ3/uYZEBYUlp JD32jNFY1qFXRfWiijTFhq8detfDVvczcwv0v6Lln0fcRIYDnzgHkqQV 38LonWnfWLuOOjt6drrmsc6NqMvzBNM62ctqdajOd1SYFduk5JadzLZa YhUooeLpfTNmBQtPjsrZeXVE9UUpLrOVW9Up3NV+kfusBCG5iBkepw/p daza94/0N5Q2xqTVCoHHUnaPmdZwp78AsLdpeJ347OyJQ/gO+pIz8WYT aNi7FA==
;; Received 1170 bytes from 193.0.14.129#53(k.root-servers.net) in 68 ms

google.com.             172800  IN      NS      ns2.google.com.
google.com.             172800  IN      NS      ns1.google.com.
google.com.             172800  IN      NS      ns3.google.com.
google.com.             172800  IN      NS      ns4.google.com.
CK0POJMG874LJREF7EFN8430QVIT8BSM.com. 86400 IN NSEC3 1 1 0 - CK0Q2D6NI4I7EQH8NA30NS61O48UL8G5 NS SOA RRSIG DNSKEY NSEC3PARAM
CK0POJMG874LJREF7EFN8430QVIT8BSM.com. 86400 IN RRSIG NSEC3 13 2 86400 20240422042504 20240415031504 4534 com. ecgUBNoIjF0/2NK5qbLLoESdr1gCp2UQeruasASkce/2OC1+tbNorpx2 zr2HsO8bFW7BEvnN11MdmPyQBU3Csg==
S84BKCIBC38P58340AKVNFN5KR9O59QC.com. 86400 IN NSEC3 1 1 0 - S84BR9CIB2A20L3ETR1M2415ENPP99L8 NS DS RRSIG
S84BKCIBC38P58340AKVNFN5KR9O59QC.com. 86400 IN RRSIG NSEC3 13 2 86400 20240419042537 20240412031537 4534 com. 5lFoSTkTYKY8oMvoj3TJbMvg72dB8RNZ3hvC5xkh9u6iZtqSZS+7bjJH nVL6cstRpACJKNLpTaWmI1NE9WsPWg==
;; Received 644 bytes from 192.42.93.30#53(g.gtld-servers.net) in 44 ms

google.com.             300     IN      A       74.125.131.139
google.com.             300     IN      A       74.125.131.102
google.com.             300     IN      A       74.125.131.100
google.com.             300     IN      A       74.125.131.113
google.com.             300     IN      A       74.125.131.138
google.com.             300     IN      A       74.125.131.101
;; Received 135 bytes from 216.239.36.10#53(ns3.google.com) in 20 ms
```

### Drill

Получить информацию по трассировке запросов к домену в `Drill`:

```bash
drill -T example.org
```

Результат запроса:

```terminal {lang="dns"}
drill -T google.com

.       518400  IN      NS      a.root-servers.net.
.       518400  IN      NS      b.root-servers.net.
.       518400  IN      NS      c.root-servers.net.
.       518400  IN      NS      d.root-servers.net.
.       518400  IN      NS      e.root-servers.net.
.       518400  IN      NS      f.root-servers.net.
.       518400  IN      NS      g.root-servers.net.
.       518400  IN      NS      h.root-servers.net.
.       518400  IN      NS      i.root-servers.net.
.       518400  IN      NS      j.root-servers.net.
.       518400  IN      NS      k.root-servers.net.
.       518400  IN      NS      l.root-servers.net.
.       518400  IN      NS      m.root-servers.net.
com.    172800  IN      NS      m.gtld-servers.net.
com.    172800  IN      NS      j.gtld-servers.net.
com.    172800  IN      NS      f.gtld-servers.net.
com.    172800  IN      NS      l.gtld-servers.net.
com.    172800  IN      NS      g.gtld-servers.net.
com.    172800  IN      NS      c.gtld-servers.net.
com.    172800  IN      NS      k.gtld-servers.net.
com.    172800  IN      NS      b.gtld-servers.net.
com.    172800  IN      NS      d.gtld-servers.net.
com.    172800  IN      NS      h.gtld-servers.net.
com.    172800  IN      NS      a.gtld-servers.net.
com.    172800  IN      NS      i.gtld-servers.net.
com.    172800  IN      NS      e.gtld-servers.net.
google.com.     172800  IN      NS      ns2.google.com.
google.com.     172800  IN      NS      ns1.google.com.
google.com.     172800  IN      NS      ns3.google.com.
google.com.     172800  IN      NS      ns4.google.com.
google.com.     300     IN      A       108.177.14.139
google.com.     300     IN      A       108.177.14.102
google.com.     300     IN      A       108.177.14.138
google.com.     300     IN      A       108.177.14.100
google.com.     300     IN      A       108.177.14.101
google.com.     300     IN      A       108.177.14.113
```

## PTR-запись домена

### Dig

Получить информацию по PTR-записи домена в `Dig`:

```bash
dig -x IP_ADDRESS
```

Результат запроса:

```terminal {lang="dns"}
dig -x 108.177.14.100

; <<>> DiG 9.18.24-1-Debian <<>> -x 108.177.14.100
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 649
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4000
;; QUESTION SECTION:
;100.14.177.108.in-addr.arpa.   IN      PTR

;; ANSWER SECTION:
100.14.177.108.in-addr.arpa. 815 IN     PTR     lt-in-f100.1e100.net.

;; Query time: 0 msec
;; SERVER: 172.16.18.22#53(172.16.18.22) (UDP)
;; WHEN: Mon Apr 15 09:21:53 UTC 2024
;; MSG SIZE  rcvd: 90
```

### Drill

Получить информацию по PTR-записи домена в `Drill`:

```bash
drill -x IP_ADDRESS
```

Результат запроса:

```terminal {lang="dns"}
drill -x 108.177.14.100

;; ->>HEADER<<- opcode: QUERY, rcode: NOERROR, id: 55533
;; flags: qr rd ra ; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0
;; QUESTION SECTION:
;; 100.14.177.108.in-addr.arpa. IN      PTR

;; ANSWER SECTION:
100.14.177.108.in-addr.arpa.    14366   IN      PTR     lt-in-f100.1e100.net.

;; AUTHORITY SECTION:

;; ADDITIONAL SECTION:

;; Query time: 3 msec
;; SERVER: 10.1.0.1
;; WHEN: Wed Mar 27 17:44:49 2024
;; MSG SIZE  rcvd: 79
```

### NSLookUp

Получить информацию по PTR-записи домена в `NSLookUp`:

```bash
nslookup -debug IP_ADDRESS
```

Результат запроса:

```terminal {lang="dns"}
nslookup -debug 108.177.14.100

------------
Got answer:
    HEADER:
        opcode = QUERY, id = 1, rcode = NOERROR
        header flags:  response, want recursion, recursion avail.
        questions = 1,  answers = 1,  authority records = 0,  additional = 1

    QUESTIONS:
        1.0.1.10.in-addr.arpa, type = PTR, class = IN
    ANSWERS:
    ->  1.0.1.10.in-addr.arpa
        name = gw1.lan
        ttl = 86400 (1 day)
    ADDITIONAL RECORDS:
    ->  gw1.lan
        internet address = 10.1.0.1
        ttl = 86400 (1 day)

------------
Server:  gw1.lan
Address:  10.1.0.1

------------
Got answer:
    HEADER:
        opcode = QUERY, id = 2, rcode = NOERROR
        header flags:  response, want recursion, recursion avail.
        questions = 1,  answers = 1,  authority records = 0,  additional = 0

    QUESTIONS:
        100.14.177.108.in-addr.arpa, type = PTR, class = IN
    ANSWERS:
    ->  100.14.177.108.in-addr.arpa
        name = lt-in-f100.1e100.net
        ttl = 14305 (3 hours 58 mins 25 secs)

------------
Name:    lt-in-f100.1e100.net
Address:  108.177.14.100
```
