---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'FAQ для IP.Board 2.3'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cmf'
  - 'inHistory'
tags:
  - 'ipb'
  - 'ips'
  - 'faq'
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

date: '2023-10-17T03:57:06+03:00'
publishDate: '2023-10-17T03:57:06+03:00'
lastMod: '2023-10-17T03:57:06+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'a0756caeae3c49ff9587ee8c7f3247c838bad8a5'
uuid: 'a0756cae-ae3c-59ff-b587-ee8c7f3247c8'
slug: 'a0756cae-ae3c-59ff-b587-ee8c7f3247c8'

draft: 0
---

Сборник вопросов и ответов по форумному движку {{< tag "IPB" >}} 2.3.

<!--more-->

## Как сделать портал главной страницей форума?

Открыть файл `init.php`, найти:

```php
define( 'IPB_MAKE_PORTAL_HOMEPAGE', 0 );
```

Заменить на:

```php
define( 'IPB_MAKE_PORTAL_HOMEPAGE', 1 );
```

## Как удалить (Powered by Invision Power Board) из title?

Открыть файл `./sources/action_public/boards.php`, найти:

```php
$cp = " (Powered by Invision Power Board)";
```

Заменить на:

```php
$cp = "";
```

## Как убрать текст в просмотре темы под аватаром?

Нужно отредактировать шаблон `RenderRow`:

- Админцентр / Внешний вид / *Ваш скин*.
  - редактировать HTML фрагменты / `skin_topic` (Просмотр темы) / `RenderRow`.

Код, отвечающий за поля пользователя в сообщении:

```php
{$author['avatar']}<br /><br />
{$author['title']}<br />
{$author['member_rank_img']}<br /><br />
{$author['member_group']}<br />
{$author['member_posts']}<br />
{$author['member_joined']}<br />
{$author['member_location']}
{$author['member_number']}<br />
```

Где:
- `{$author['avatar']}` - аватар.
- `{$author['title']}` - ранг.
- `{$author['member_rank_img']}` - изображения ранга.
- `{$author['member_group']}` - Группа пользователя.
- `{$author['member_posts']}` - Сообщения.
- `{$author['member_joined']}` - Регистрация.
- `{$author['member_number']}` - ID пользователя.

## Как добавить дополнительные кнопки BB-кода в быстрый ответ?

Сначала нужно в файле `./jscripts/ips_text_editor_lite.js` добавить свои BB-коды, а потом отредактировать шаблон `quick_reply_box_open`.

Открываем `./jscripts/ips_text_editor_lite.js`, находим строчку:

```js
this.ipb_code=function(){var _text=this.get_selection();this.wrap_tags('code',false,_text);};
```

Эта строка отвечает за BB-код `CODE`. Копируем её к себе в редактор и заменяем в ней слово code на свой BB-код (например, у меня будет это `[i]spoiler[/i]`):

```js
this.ipb_spoiler=function(){var _text=this.get_selection();this.wrap_tags('spoiler',false,_text);};
```

После этого вставляем её обратно в файл `./jscripts/ips_text_editor_lite.js`, НО уже после скопированной нами ранее строки с BB-кодом `CODE`. Получается вот так:

```js
this.ipb_code=function(){var _text=this.get_selection();this.wrap_tags('code',false,_text);};this.ipb_spoiler=function(){var _text=this.get_selection();this.wrap_tags('spoiler',false,_text);};
```

Сохраняем!

Теперь нужно отредактировать шаблон `quick_reply_box_open`:

- Админцентр / Внешний вид / *Ваш скин*.
  - редактировать HTML фрагменты / `skin_topic` (Просмотр темы) / `quick_reply_box_open`.

Открываем шаблон, находим:

```html
<td><div class="rte-normal" id="fast-reply_cmd_ipb_code"><img src="style_images/<#IMG_DIR#>/folder_editor_images/rte-code-button.png"  alt="{$this->ipsclass->lang['js_rte_lite_code']}" title="{$this->ipsclass->lang['js_rte_lite_code']}"></div></td>
```

Копируем этот участок и вставляем ниже. Теперь нужно отредактировать вставленный нами участок. Слово `code` заменяем на свой тег. Напомню, что у меня это - `spoiler`. Вот пример:

```html
<td><div class="rte-normal" id="fast-reply_cmd_ipb_spoiler"><img src="style_images/<#IMG_DIR#>/folder_editor_images/rte-spoiler-button.png"  alt="Спойлер" title="Спойлер"></div></td>
```

Не забудьте загрузить кнопку для своего тега в папку `./style_images/папка_стиля/folder_editor_images`.

## Как добавить дополнительные кнопки BB-кода в расширенный ответ?

Инструкция добавления BB-кода в расширенный ответ похожа на предыдущую, за исключением того, что для расширенного ответа необходимо отредактировать файл `./jscripts/ips_text_editor.js` и шаблон `ips_editor`.

Открываем `./jscripts/ips_text_editor.js`, находим:

```js
this.ipb_quote = function()
  {
    this.wrap_tags_lite(  '[quote]', '[/quote]', 0)
  };
```

Добавить ниже:

```js
this.ipb_youtube = function()
  {
    this.wrap_tags_lite(  '[spoiler]', '[/spoiler]', 0)
  };
```

После этого необходимо отредактировать шаблон `skin_editors` (редактор сообщений) / `ips_editor`, чтобы добавить кнопку в расширенный ответ. Находим:

```html
<td><div class="rte-normal"  id="{$editor_id}_cmd_ipb_code"><img  src="{$images_path}rte-code-button.png"   alt="{$this->ipsclass->lang['js_rte_lite_code']}"  title="{$this->ipsclass->lang['js_rte_lite_code']}"></div></td>
```

Добавляем выше:

```html
<td><div class="rte-normal" id="{$editor_id}_cmd_ipb_youtube"><img src="{$images_path}rte-code-tube.png"  alt="Youtube" title="YouTube"></div></td>
```

Не забудьте загрузить кнопку для своего тега в папку `./style_images/папка_стиля/folder_editor_images`.

## Возникает ошибка Fatal error: Allowed memory size of xxx bytes exhausted (tried to allocate yyy bytes). Что это такое?

При попытке зайти в тему, профиль пользователя, список пользователей либо любую другую страницу ничего не выводится, либо выводится сообщение аналогичное приведенному:

{{< window title="Fatal error" type="danger" >}}
Fatal error: Allowed memory size of 8388608 bytes exhausted (tried to allocate 737280 bytes) in /home/ourmobil/public_html/forum/sources/ipsclass.php(2054) : eval()'d code on line 1085
{{< /window >}}

или такому:

{{< window title="Fatal error" type="danger" >}}
Fatal error: Allowed memory size of 50331648 bytes exhausted (tried to allocate 16 bytes) in /home/users/d/demon99/docs/subs/cs/forum/ips_kernel/class_xml.php on line 254
{{< /window >}}

Это означает, что для выполнения скрипта требуется больше памяти, чем предоставляет PHP. Необходимо увеличить количество выделяемой PHP памяти. Сделать это можно одним из следующих способов:

1. В `.htaccess` добавить строку (при условии, что {{< tag "PHP" >}} работает под Apache):

```apache
php_value memory_limit 32M
```

2. В `php.ini` (при условии, что Вы можете его редактировать) изменить значение параметра `memory_limit`:

```ini
memory_limit 32M
```

3. Добавив в `index.php` после:

```php
<?php
```

следующий код:

```php
ini_set('memory_limit', '32M');
```

Если ни один из предложенных вариантов не подошел, обратитесь за помощью к хостеру с указанием описания ошибки.

## Как сделать форум на несколько доменов?

Если у вас несколько доменов, но ОДНА база данных, то в `conf_global.php` нужно изменить строчку:

```php
$INFO['board_url'] = 'http://domain.com';
```

На такую:

```php
$INFO['board_url'] = "http://".$_SERVER["HTTP_HOST"];
```

Однако, если форум установлен в под-директорию, например, `http://domain.com/forum`, то необходимо изменить строчку на следующую:

```php
$INFO['board_url'] = "http://".$_SERVER["HTTP_HOST"]."/forum";
```
Где:
- `forum` - папка форума.

## Как сделать, чтобы прикреплённые имена файлов имели русские символы в названии?

Для этого необходимо открыть файл `./ips_kernel/class_upload.php`, найти:

```php
//-------------------------------------------------
// Make the uploaded file safe
//-------------------------------------------------

$FILE_NAME = preg_replace( "/[^\w\.]/", "_", $FILE_NAME );
```

Заменить на:

```php
//-------------------------------------------------
// Make the uploaded file safe
//-------------------------------------------------

$FILE_NAME = preg_replace( "/[^a-zA-Z0-9а-яА-Я\-\.\_]/", "_", $FILE_NAME );
```
