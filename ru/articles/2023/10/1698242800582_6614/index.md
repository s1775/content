---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Изучаем API "ЕИС Закупки"'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'linux'
  - 'windows'
  - 'terminal'
tags:
  - 'powershell'
  - 'bash'
  - 'закупки'
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

date: '2023-10-25T17:06:40+03:00'
publishDate: '2023-10-25T17:06:40+03:00'
lastMod: '2023-10-25T17:06:40+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '4e4a39b0798945921a9cbe748204148c61e53948'
uuid: '4e4a39b0-7989-5592-8a9c-be748204148c'
slug: '4e4a39b0-7989-5592-8a9c-be748204148c'

draft: 1
---

У ЕИС "Закупки" имеется JSON-API, но документации по работе с ним я не нашёл. Поэтому, методом тыка и анализа мне удалось сформировать некое подобие руководства.

<!--more-->

## URL на получение списка закупок

Для работы с API, необходимо сформировать специальный URL, который будет содержать информацию для получения ответа от сервера. Чтобы получить список закупок через API необходимо знать ИНН организации. Для проведения экспериментов, я взял ИНН организации, в которой я когда-то работал: `7719167509`.

Собственно, сам URL:

```
https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509&strictEqual=true&pageNumber=1&recordsPerPage=_10&sortDirection=false&sortBy=PUBLISH_DATE&fz44=on&fz223=on&ppRf615=on&fz94=on&af=on&ca=on&pc=on&pa=on
```

URL довольно большой, поэтому для удобства я каждый параметр перенёс на отдельную строку:

```
https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509
&strictEqual=true
&pageNumber=1
&recordsPerPage=_10
&sortDirection=false
&sortBy=PUBLISH_DATE
&fz44=on
&fz223=on
&ppRf615=on
&fz94=on
&af=on
&ca=on
&pc=on
&pa=on
```

Когда стало поудобнее, рассмотрим параметры по отдельности.

### Параметры

#### Общие

- `?searchString=` - текст для поиска по закупкам. Обычно, я сюда вписываю ИНН организации.
- `&strictEqual=` - искать точно, как в запросе.
  - `true` - да.
  - `false` - нет.
- `&pageNumber=` - номер страницы. Так как информации очень много, сервер разбивает её на страницы.
- `&recordsPerPage=` - количество записей на странице. Обратим внимание, что число начинается с нижнего подчёркивания. Это не ошибка.
  - `_10` - 10 записей.
  - `_20` - 20 записей.
  - `_50` - 50 записей.

#### Сортировка данных

- `&sortDirection=` - направление сортировки.
  - `true` - от старого к новому.
  - `false` - от нового к старому.
- `&sortBy=` параметр сортировки.
  - `UPDATE_DATE` - дата обновления.
  - `PUBLISH_DATE` - дата публикации.
  - `PRICE` - цена.
  - `RELEVANCE` - релевантность.

#### Законы

- `&fz44=on` - 44-ФЗ.
- `&fz223=on` - 223-ФЗ.
- `&ppRf615=on` - ПП РФ 615 (Капитальный ремонт).
- `&fz94=on` - 94-ФЗ.

#### Этапы закупки

- `&af=on` - подача заявок.
- `&ca=on` - работа комиссии.
- `&pc=on` - закупка завершена.
- `&pa=on` - закупка отменена.

#### Лоты закупки

- `&showLotsInfoHidden=` - открыть лоты.
  - `false` - нет.
  - `true` - да.

## Запрос на получение списка закупок

Запросы серверу закупок можно отправлять через `curl` или при помощи cmdlet'а `Invoke-WebRequest`, если работаем в PowerShell. Для наших экспериментов не обязательно работать напрямую с сервером, можно получить ответ и сохранить его в файл. Что мы и сделаем - сохраним ответ сервера в файл `orders.json`.

### Linux

{{< alert "important" >}}
При запросе обязательно указывайте **User-Agent**! Первый запрос может пройти без User-Agent'а, но все последующие будут блокироваться.
{{< /alert >}}

При работе в Linux можно применить утилиту `curl` для отправки запроса на сервер закупок:

```bash
curl -X GET -A 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/119.0' \
'https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509' \
-d 'strictEqual=true' \
-d 'sortDirection=false' \
-d 'sortBy=PUBLISH_DATE' \
-d 'recordsPerPage=_10' \
-d 'fz44=on' \
-d 'fz223=on' \
-d 'ppRf615=on' \
-d 'fz94=on' \
-d 'af=on' \
-d 'ca=on' \
-d 'pc=on' \
-d 'pa=on' \
-o 'orders.json'
```

Сервер даст ответ, который сохраниться в файле под именем `orders.json`.

### MS Windows

В ОС Windows нет необходимости применять сторонние утилиты, можно воспользоваться встроенным cmdlet'ом `Invoke-WebRequest`:

```powershell
$URL = 'https://zakupki.gov.ru/api/mobile/proxy/epz/order/extendedsearch/results.html?searchString=7719167509' +
'&strictEqual=true' +
'&sortDirection=false' +
'&sortBy=PUBLISH_DATE' +
'&recordsPerPage=_10' +
'&fz44=on' +
'&fz223=on' +
'&ppRf615=on' +
'&fz94=on' +
'&af=on' +
'&ca=on' +
'&pc=on' +
'&pa=on'

Invoke-WebRequest "${URL}" -OutFile 'orders.json'
```

Сервер даст ответ, который сохранится в файле под именем `orders.json`.

## Работа с файлом `orders.json`

Содержимое файла находится в сжатом формате, без пробелов и переносов строк. Для удобства исследования файла, его содержимое я преобразовал в читабельный вид.

{{< file "orders.json" "json" >}}

### Linux

Получение имени закупки:

```bash
cat 'orders.json' | jq -r '.list[] | .name'
```

Получение номера закупки:

```bash
cat 'orders.json' | jq -r '.list[] | .number'
```

### MS Windows

Получение имени закупки:

```powershell
(Get-Content 'orders.json' | ConvertFrom-Json).list.name
```

Получение номера закупки:

```powershell
(Get-Content 'orders.json' | ConvertFrom-Json).list.number
```
