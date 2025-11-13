---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Читабельные ссылки на темы форума для IP.Board 2.3'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cmf'
  - 'inHistory'
tags:
  - 'ipb'
  - 'ips'
  - 'forum'
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

date: '2023-10-17T05:45:40+03:00'
publishDate: '2023-10-17T05:45:40+03:00'
lastMod: '2023-10-17T05:45:40+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'd477b5ce8095960741c75c5ad7b7f146ef27ee0f'
uuid: 'd477b5ce-8095-5607-91c7-5c5ad7b7f146'
slug: 'd477b5ce-8095-5607-91c7-5c5ad7b7f146'

draft: 0
---

Очередной артефакт прошлого. Когда то была очень крутая модификация для {{< tag "IPB" >}} 2.3. Эта модификация позволяла преобразовывать обычные ссылки на темы внутри форума в читабельный формат с текстом. Золотое время было...

<!--more-->

{{< alert "info" >}}
- Автор: GiV.
- Тестирование (маленькое :)): KaiKimera.
- Исправление ошибок и неточностей: Sannis.
{{< /alert >}}

## Внедрение модификации

Открыть файл `./sources/classes/bbcode/class_bbcode_core.php`, найти:

```php
$show = $url['show'];
```

Добавить **после**:

```php
if (strpos($show, $this->ipsclass->base_url) !== false) {
  $match = array();

  if (preg_match("/showtopic=(\d+)/", $show, $match) or preg_match("/&t=(\d+)/", $show, $match)) {
    $show = $this->_getUrlLocalName('topics', $match[1]);
  }

  if (preg_match("/showforum=(\d+)/", $show, $match)) {
    $show = $this->_getUrlLocalName('forums', $match[1]);
  }

  if (preg_match("/showuser=(\d+)/", $show, $match)) {
    $show = $this->_getUrlLocalName('members', $match[1]);
  }

  if (!$show) {
    $show = $url['show'];
  }
} else
```

Найти:

```php
/*-------------------------------------------------------------------------*/
// Remove sessions in a nice way
/*-------------------------------------------------------------------------*/
```

Добавить **перед**:

```php
function _getUrlLocalName($from = '', $for = '')
{
  // Сколько раз разбирали ссылки.
  static $parsedUrls;

  // Проверка на лимит разбора ссылок, чем больше число, тем больше
  // вероятность, что злоумышленник может создать нагрузку на БД.
  if (++$parsedUrls >= 10) return false;
  if (!$from or !$for) return false;

  // Оптимизация для ссылок на форумы/разделы. Берем имя не через запрос
  // к базе, а из кэша форумов. Спасибо улетает к SAT.
  if ($from == 'forums') {
    return $this->ipsclass->cache['forum_cache'][$for]['name'];
  }

  // 'pk' - имя первичного ключа (id'ентификатора) в таблице.
  // 'fieldName' - имя поля в таблице, в котором хранится возвращаемое имя.
  $pk = 'id';           // В большинстве случаев имя первичного ключа - 'id'.
  $fieldName = 'name';  // Имя поля - 'name'.

  // Однако в случае с темами у нас другие 'pk' и 'fieldName'.
  if ($from == 'topics') {
    $pk = 'tid';          // Имя первичного ключа - 'tid'.
    $fieldName = 'title'; // Имя поля с названием - 'title'.
  }

  // Однако в случае с пользователями у нас другое 'fieldName'.
  if ($from == 'members') {
    $fieldName = 'members_display_name'; // Имя поля с названием - 'members_display_name'.
  }

  $this->ipsclass->DB->simple_select($fieldName, $from, $pk . "= '" . $for . "'");
  $ci = $this->ipsclass->DB->exec_query();
  $row = $this->ipsclass->DB->fetch_row($ci);

  if ($fieldValue = $row[$fieldName]) {
    return $fieldValue;
  }

  return false;
}
```
