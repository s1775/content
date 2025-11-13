---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Работа с правилами CloudFlare'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'inDev'
  - 'network'
tags:
  - 'rule'
  - 'cloudflare'
authors:
  - 'KaiKimera'
sources:
  - 'https://developers.cloudflare.com/rules/url-forwarding/single-redirects/examples'
  - 'https://community.cloudflare.com/t/508780'
  - 'https://developer.mozilla.org/ru/docs/Web/HTTP/Status'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2023-10-29T09:55:05+03:00'
publishDate: '2023-10-29T09:55:05+03:00'
lastMod: '2023-10-29T09:55:05+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'e191797ed558a017dac4c28c6e0871ff4b1d29de'
uuid: 'e191797e-d558-5017-8ac4-c28c6e0871ff'
slug: 'e191797e-d558-5017-8ac4-c28c6e0871ff'

draft: 0
---

{{< tag "CloudFlare" >}} предоставляет мощный инструмент по работе с различными правилами, зависящими от запросов клиентов. Разберём составление этих правил и приведём несколько примеров.

<!--more-->

## Настройки правила

Правила работаю на, так называемом, [Cloudflare Ruleset Engine](https://developers.cloudflare.com/ruleset-engine/) и позволяют максимально гибко себя конфигурировать при помощи специальных полей, условий и переменных.

Каждое правило состоит из двух этапов:

1. If... - если.
2. Then... - тогда.

Рассмотрим всё это дело подробнее...

### If...

Этап "Если" означает условие, по которому будут фильтроваться клиенты. Этап состоит из поля, оператора сравнения и значения, которое будет участвовать в составленном условии.

#### Поля

Поля это переменные, значения которых вычисляются из запроса, инициируемого клиентом. Ниже приведён частичный список полей, которые доступны из графического интерфейса. Полный список полей находится в [документации CloudFlare](https://developers.cloudflare.com/ruleset-engine/rules-language/fields/).

- AS Num `ip.src.asnum`.  
  16- или 32-разрядное целое число, представляющее номер автономной системы (AS), связанной с IP-адресом клиента. Это поле эквивалентно устаревшему `ip.geoip.asnum`.
- Cookie `http.cookie`.  
  Файл cookie в строке. Пример: `session=8521F670545D7865F79C3D7BEDC29CCE;-background=light`.
- Country `ip.src.country`.  
  Двухбуквенный код страны в формате ISO 3166-1 Alpha 2. Пример: GB. Это поле эквивалентно устаревшему `ip.geoip.country`.
- Continent `ip.src.continent`.  
  Код континента, связанный с IP-адресом клиента. Это поле эквивалентно устаревшему `ip.geoip.continent`.
  - `AF` - Africa.
  - `AN` - Antarctica.
  - `AS` - Asia.
  - `EU` - Europe.
  - `NA` - North America.
  - `OC` - Oceania.
  - `SA` - South America.
  - `T1` - Tor network.
- Hostname `http.host`.  
  Имя хоста. Пример: `www.example.org`.
- IP Source Address `ip.src`.  
  IP-адрес клиента. Пример: `93.184.216.34`.
- Referer `http.referer`.  
  Заголовок запроса HTTP Referer, который содержит адрес веб-страницы, с которой пришёл запрос. Пример: `Referer: htt­ps://developer.example.org/en-US/docs/Web/JavaScript`.
- Request Method `http.request.method`.  
  Метод HTTP-запроса. Пример: `GET`.
- SSL/HTTPS `ssl`.  
  Возвращает `true`, когда используется зашифрованное соединение с клиентом.
- URI Full `http.request.full_uri`.  
  Весь URI, полученный сервером. Пример: `htt­ps://www.example.org/articles/index?section=539061&expand=comments`.
- URI `http.request.uri`.  
  Путь URI и строка запроса. Пример: `/articles/index?section=539061&expand=comments`.
- URI Path `http.request.uri.path`.  
  Путь URI. Пример: `/articles/index`.
- URI Query String `http.request.uri.query`.  
  Строка запроса без разделителя `?`. Пример: `section=539061&expand=comments`.
- HTTP Version `http.request.version`.  
  Версия используемого протокола HTTP. Пример: `HTTP/1.1` или `HTTP/3`.
- User Agent `http.user_agent`.  
  User Agent клиента, строка, позволяющая идентифицировать клиентскую операционную систему и веб-браузер. Пример: `Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.181 Safari/537.36`.
- X-Forward-For `http.x_forwarded_for`.  
  Заголовок X-Forwarded-For. Пример: `203.0.113.195, 70.41.3.18`.
- Client Certificate Verified `cf.tls_client_auth.cert_verified`.  
  Возвращает `true`, когда запрос предоставляет действительный сертификат клиента.

#### Операторы

Операторы сравнения возвращают true, когда значение запроса клиента совпадает со значением в выражении. Подробнее в [документации](https://developers.cloudflare.com/ruleset-engine/rules-language/operators/).

- equals `eq` - равно.
- does not equal `ne` -  не равно.
- greater than `gt` - больше чем.
- less than `lt` - меньше чем.
- greater than or equal to `ge` - больше или равно.
- less than or equal to `le` - меньше или равно.
- is in `in {}` - значение находится в массиве.
- is not in `not <field> in {}` - значение не находится в массиве.

### Then...

Этап "Тогда" подразумевает под собой действие, которое будет применено к отфильтрованному клиенту.

#### Тип поля URL

- Dynamic - в поле URL содержит динамические параметры (переменные полей) и их необходимо вычислять и обрабатывать.
- Static - в поле URL содержится обычные статические параметры.

#### Коды статуса

- 301 (Moved Permanently).  
  Запрошенный ресурс был окончательно перемещён в URL, указанный в заголовке `Location`. Браузер в случае такого ответа перенаправляется на эту страницу, а поисковые системы обновляют свои ссылки на ресурс (говоря языком SEO, вес страницы переносится на новый URL-адрес).
- 302 (Moved Temporarily).  
  Запрошенный ресурс был временно перемещён по адресу, указанному в заголовке `Location`. Получив такой ответ браузер перенаправляется на новую страницу, но поисковые системы не обновляют свои ссылки на ресурс (в жаргоне SEO говорят, что вес ссылки (link-juice) не меняется и не отправляется на новый URL-адрес).
- 303 (See Other).  
  Перенаправление производится не на новый (только что загруженный) ресурс, а на другую страницу, например, страницу подтверждения или страницу с результатами загрузки.
- 307 (Temporary Redirect).  
  Запрошенный ресурс был временно перемещён в URL-адрес, указанный в заголовке `Location`. Единственное различие между 307 и 302 состоит в том, что 307 гарантирует, что метод и тело не будут изменены при выполнении перенаправленного запроса. В случае с кодом 302 некоторые старые клиенты неправильно меняли метод на `GET`, из-за чего поведение запросов с методом отличным от `GET` и ответа с кодом 302 непредсказуемо, тогда как поведение в случае ответа с кодом 307 предсказуемо. Для запросов `GET` поведение идентично.
- 308 (Permanent Redirect).  
  Запрошенный ресурс был окончательно перемещён в URL-адрес, указанный в `Location`. Браузер перенаправляется на эту страницу, а поисковые системы обновляют свои ссылки на ресурс (в SEO-speak говорится, что link-juice отправляется на новый URL-адрес). Метод запроса и тело не будут изменены, тогда как 301 иногда может быть неправильно заменён на `GET` метод.

В примерах я буду приводить шаблон, который вписывается в редактор выражения. Поэтому, можно не щёлкать по удобным кнопочкам, а сразу нажимать {{< btn "Edit expression" >}} и вписывать нужный шаблон.


## Переадресация

Самый часто используемый тип правил, это правила по работе с переадресацией. Привожу несколько примеров. Их можно брать готовыми и вставлять в редактор выражения, не забыв отредактировать под себя некоторые входные параметры, например, название домена или адрес куда переадресовывать клиентов.

### Примеры

Ниже я привёл примеры, которые позволяют реализовать наиболее популярные правила переадресации запросов.

#### Пути

Переадресация запроса с одного ресурса (или страницы) на другой ресурс (или страницу).

{{< accordion >}}
{{< accordion-item "example.org | www.example.org" >}}
`https://example.org` `->` `https://www.example.org`

**When incoming requests match:**

```lua
(http.host eq "example.org")
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
concat("https://www.", http.host, http.request.uri.path)
```
{{< /accordion-item >}}
{{< accordion-item "www.example.org | example.org" >}}
`https://www.example.org` `->` `https://example.org`

**When incoming requests match:**

```lua
(http.host eq "www.example.org")
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
concat("https://", http.host, http.request.uri.path)
```
{{< /accordion-item >}}
{{< accordion-item "example.org/path | example.org/path">}}
`https://example.org/path` `->` `https://example.org/path`

**When incoming requests match:**

```lua
(http.host eq "example.org")
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
concat("https://example.org", http.request.uri.path)
```
{{< /accordion-item >}}
{{< accordion-item "example.org | example.org">}}
`https://example.org` `->` `https://example.org`

**When incoming requests match:**

```lua
(http.host contains "example.org")
```

**Then...**

- Type: `Static`
- Status code: `301`

**URL:**

```lua
https://example.org/
```
{{< /accordion-item >}}
{{< accordion-item "sub.example.org | example.org/sub">}}
`https://sub.example.org` `->` `https://example.org/sub`

**When incoming requests match:**

```lua
(http.host eq "sub.example.org")
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
concat("https://", http.host, "/sub", http.request.uri.path)
```
{{< /accordion-item >}}
{{< accordion-item "example.org/sub | sub.example.org">}}
`https://example.org/sub` `->` `https://sub.example.org`

**When incoming requests match:**

```lua
(starts_with(http.request.uri.path, "/sub/"))
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
concat("https://sub.", http.host, substring(http.request.uri.path, 6))
```

Число в функции `substring()` - это количество символов в названии директории `sub` + 1 символ.
{{< /accordion-item >}}
{{< accordion-item "example.org/contact-us/ | example.org/contact/">}}
`https://example.org/contact-us/` `->` `https://example.org/contact/`

**When incoming requests match:**

```lua
(http.request.uri.path eq "/contact-us/")
```

**Then...**

- Type: `Static`
- Status code: `301`

**URL:**

```lua
/contacts/
```
{{< /accordion-item >}}
{{< /accordion >}}

#### Порты

Переадресация в зависимости от запроса, пришедшего на определённый порт.

{{< accordion >}}
{{< accordion-item "Переадресовать запрос к любым портам (кроме '80' и '443') на порт '443' (HTTPS)" >}}
`https://example.org:1212` `->` `https://example.org`

**When incoming requests match:**

```lua
(not (cf.edge.server_port in {80 443}))
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
concat("https://", http.host, http.request.uri.path)
```
{{< /accordion-item >}}
{{< /accordion >}}

#### Страны

Переадресация в зависимости от страны клиента.

{{< accordion >}}
{{< accordion-item "Переадресовать пользователей из стран RU/BY/UA в директорию '/ru'" >}}
`https://example.org` `->` `https://example.org/ru/`

**When incoming requests match:**

```lua
(((ip.src.country eq "RU") or (ip.src.country eq "BY") or (ip.src.country eq "UA")) and (http.request.uri.path eq "/"))
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
lower(concat("https://", http.host, "/ru/"))
```
{{< /accordion-item >}}
{{< accordion-item "Переадресовать пользователей НЕ из стран RU/BY/UA в директорию '/en'" >}}
`https://example.org` `->` `https://example.org/en/`

**When incoming requests match:**

```lua
(((ip.src.country ne "RU") or (ip.src.country ne "BY") or (ip.src.country ne "UA")) and (http.request.uri.path eq "/"))
```

**Then...**

- Type: `Dynamic`
- Status code: `301`

**URL:**

```lua
lower(concat("https://", http.host, "/en/"))
```
{{< /accordion-item >}}
{{< /accordion >}}
