---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'SQL запросы IP.Board 2.3'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cmf'
  - 'inHistory'
tags:
  - 'ipb'
  - 'ips'
  - 'sql'
  - 'forum'
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

date: '2023-10-17T02:59:21+03:00'
publishDate: '2023-10-17T02:59:21+03:00'
lastMod: '2023-10-17T02:59:21+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: '54d4e4889a8fc5ed4feac77d4dba0720fc88c3ee'
uuid: '54d4e488-9a8f-55ed-8fea-c77d4dba0720'
slug: '54d4e488-9a8f-55ed-8fea-c77d4dba0720'

draft: 0
---

Запросы для базы данных ({{< tag "SQL" >}}) {{< tag "IPB" >}} 2.3. Информация со старых проектов. Пригодится.

<!--more-->

## SQL запросы

1. Заменить определённый текст во всех сообщениях на форуме.

```sql
UPDATE ibf_posts SET post = REPLACE(post,'старый текст','новый текст');
```

2. Заменить текст во всех описаниях форумов.

```sql
UPDATE ibf_forums SET description = REPLACE(description,'старый текст','новый текст');
```

3. Очистка журнала предупреждений конкретного пользователя, где X - вставить id пользователя, чей журнал вы хотите очистить.

```sql
DELETE FROM ibf_warn_logs WHERE wlog_mid=X;
```

4. Удалить подписи у всех пользователей.

```sql
UPDATE ibf_member_extra SET signature='Ваша подпись удалена';
```

5. Удаление модераторов.

```sql
DELETE FROM ibf_moderators;
```

6. Удаление модератора из всех форумов.

```sql
DELETE FROM ibf_moderators WHERE member_id = XX;
```

7. Удаление модератора из определённых форумов.

```sql
DELETE FROM ibf_moderators WHERE member_id = XX AND forum_id IN (4, 11, 22, 25);
```

8. Удаление аватаров у всех пользователей.

```sql
DELETE FROM ibf_member_extra WHERE avatar_location AND avatar_size;
```

9. Если не работает, то выполните следующие два запроса:

```sql
UPDATE ibf_member_extra SET avatar_location = '';
```

```sql
UPDATE ibf_member_extra SET avatar_size = '';
```

10. Массовый перенос пользователей с определённым количеством сообщений из одной группы в другую.

```sql
UPDATE ibf_members SET mgroup=Б WHERE mgroup=А AND posts > 0;
```

11. Удалить пользователей определенной группы, где b меняете на номер группы.

```sql
DELETE FROM ibf_members WHERE mgroup='b';
```

12. Удалить все ICQ номера пользователей.

```sql
UPDATE ibf_member_extra SET icq_number='';
```

13. Удалить ссылки на сайт у всех пользователей.

```sql
UPDATE ibf_member_extra SET website='';
```

14. Снятие обязательного подтверждения модератором.

```sql
UPDATE ibf_members SET mod_posts='';
```

15. Снятие только чтение/read_only.

```sql
UPDATE ibf_members SET restrict_post='';
```

16. Очистка журнала.

```sql
DELETE FROM ibf_warn_logs WHERE wlog_mid=id_пользователя;
```

17. Удаление всех установленных смайликов, то есть они переходят в список неустановленных смайликов.

```sql
DELETE FROM ibf_emoticons;
```

18. Установка кодировки и сравнения БД по умолчанию.

```sql
ALTER DATABASE `название_бд` DEFAULT CHARACTER SET cp1251 COLLATE cp1251_general_ci;
```

19. Аннулируем счётчик сообщений у всех пользователей.

```sql
UPDATE ibf_members SET posts='0';
```

20. Аннулируем счётчик сообщений у определённых групп.

```sql
UPDATE ibf_members SET posts='0' WHERE mgroup='номер_группы';
```

21. Удаление всех сообщений оставленных гостями.

```sql
DELETE FROM ibf_posts WHERE author_id='0';
```

22. Заменить текст во всех описаниях тем.

```sql
UPDATE ibf_topics SET description = REPLACE(description,'старый текст','новый текст');
```

## Благодарности

В составлении запросов благодарим следующих участников конференции:

- Mazafuka
- КиКиМоРа
- a_aqua
- Ritsuka
- Security
- truth
