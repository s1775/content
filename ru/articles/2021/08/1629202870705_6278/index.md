---
# -------------------------------------------------------------------------------------------------------------------- #
# GENERAL
# -------------------------------------------------------------------------------------------------------------------- #

title: 'Условия в шаблонах XenForo 2'
description: ''
icon: 'far fa-file-lines'
categories:
  - 'cmf'
tags:
  - 'html'
  - 'xenforo'
  - 'cms'
  - 'cmf'
authors:
  - 'KaiKimera'
sources:
  - 'https://xenforo.com/community/resources/5795/'
license: 'CC-BY-SA-4.0'
complexity: '1'
toc: 1
comments: 1

# -------------------------------------------------------------------------------------------------------------------- #
# DATE
# -------------------------------------------------------------------------------------------------------------------- #

date: '2021-08-17T15:21:10+03:00'

# -------------------------------------------------------------------------------------------------------------------- #
# META
# -------------------------------------------------------------------------------------------------------------------- #

type: 'articles'
hash: 'f9a39e378816ff800133893f3dc8f35296dea86f'
uuid: 'f9a39e37-8816-5f80-8133-893f3dc8f352'
slug: 'f9a39e37-8816-5f80-8133-893f3dc8f352'

draft: 0
---

Представляю список условий, которые можно использовать в шаблонах {{< tag "XenForo" >}}. Все возможные условия перечислить затруднительно, потому что существует множество различных вариантов фильтрации и выборки информации. Здесь представлены наиболее популярные варианты.

<!--more-->

С этой статьи я начинаю попытку восстановления накопленных данных за период моей деятельности в качестве исследователя и разработчика веб-приложений.

## Условия в шаблонах

1. Отображение информации только администраторам.

```html
<xf:if is="$xf.visitor.is_admin">
  <!-- content -->
</xf:if>
```

2. Отображение информации только модераторам.

```html
<xf:if is="$xf.visitor.is_moderator">
  <!-- content -->
</xf:if>
```

3. Отображение информации только администраторам и модераторам.

```html
<xf:if is="$xf.visitor.is_admin OR $xf.visitor.is_moderator">
  <!-- content -->
</xf:if>
```

4. Отображение информации только зарегистрированному пользователю

```html
<xf:if is="$xf.visitor.user_id">
  <!-- content -->
</xf:if>
```

5. Отображение информации гостю.

```html
<xf:if is="!$xf.visitor.user_id">
  <!-- content -->
</xf:if>
```

6. Отображение разной информации зарегистрированному пользователю и гостю.

```html
<xf:if is="!$xf.visitor.user_id">
  <!-- content for members -->
<xf:else />
  <!-- content for guests -->
</xf:if>
```

7. Отображение информации только заблокированным пользователям.

```html
<xf:if is="$user.is_banned">
  <!-- content -->
</xf:if>
```

8. Отображение информации только если у пользователя симпатий больше определённого количества.

```html
<xf:if is="$user.like_count|number > X">
  <!-- content -->
</xf:if>
```

9. Отображение информации только если у пользователя сообщений больше определённого количества.

```html
<xf:if is="{$xf.visitor.message_count|number} > X">
  <!-- content -->
</xf:if>
```

10. Отображение информации только если у пользователя очков больше определённого количества.

```html
<xf:if is="$user.trophy_points|number > X">
  <!-- content -->
</xf:if>
```

11. Отображение информации определённому пользователю.

```html
<xf:if is="$xf.visitor.user_id == X">
  <!-- content -->
</xf:if>
```

12. Отображение информации определённым пользователям.

```html
<xf:if is="in_array($xf.visitor.user_id, [X, Y, Z])">
  <!-- content -->
</xf:if>
```

13. (1) Отображение информации определённым группам пользователей.

```html
<xf:if is="{{$xf.visitor.isMemberOf([X, Y])}}">
  <!-- content -->
</xf:if>
```

13. (2) Отображение информации определённой группе пользователей.

```html
<xf:if is="{{$xf.visitor.isMemberOf(X)}}">
  <!-- content -->
</xf:if>
```

14. (1) Скрытие информации от определённых групп пользователей.

```html
<xf:if is="{{!$xf.visitor.isMemberOf([X, Y])}}">
  <!-- content -->
</xf:if>
```

14. (2) Скрытие информации от определённой группы пользователей.

```html
<xf:if is="{{!$xf.visitor.isMemberOf(X)}}">
  <!-- content -->
</xf:if>
```

15. (1) Отображение информации после первого сообщения в теме.

```html
<xf:if is="$post.position % $xf.options.messagesPerPage == 0">
  <!-- content -->
</xf:if>
```

15. (2) Отображение информации через определённое количества сообщений.

```html
<xf:if is="$post.position % $xf.options.messagesPerPage == X">
  <!-- content -->
</xf:if>
```

16. Отображение информации на странице, на которой присутствует боковая панель.

```html
<xf:if is="$sidebar">
  <!-- content -->
</xf:if>
```

17. Отображение информации на главной (домашней) странице форума.

```html
<xf:if is="$template == 'forum_list'">
  <!-- content -->
</xf:if>
```

18. Скрытие информации только с главной (домашней) странице форума.

```html
<xf:if is="$template !== 'forum_list'">
  <!-- content -->
</xf:if>
```

19. Отображение информации на странице создания новой темы.

```html
<xf:if is="$template == 'forum_post_thread'">
  <!-- content -->
</xf:if>
```

20. Скрытие информации на странице создания новой темы.

```html
<xf:if is="$template != 'forum_post_thread'">
  <!-- content -->
</xf:if>
```

21. Отображение информации на странице создания нового ресурса.

```html
<xf:if is="$template == 'xfrm_category_add_resource'">
  <!-- content -->
</xf:if>
```

22. Скрытие информации на странице создания нового ресурса.

```html
<xf:if is="$template != 'xfrm_category_add_resource'">
  <!-- content -->
</xf:if>
```

23. Отображение информации на странице поисковой формы.

```html
<xf:if is="$template == 'search_form'">
  <!-- content -->
</xf:if>
```

24. Скрытие информации на странице поисковой формы.

```html
<xf:if is="$template != 'search_form'">
  <!-- content -->
</xf:if>
```

25. Отображение информации на странице "Что нового?".

```html
<xf:if is="$template == 'whats_new'">
  <!-- content -->
</xf:if>
```

26. Скрытие информации на странице "Что нового?".

```html
<xf:if is="$template != 'whats_new'">
  <!-- content -->
</xf:if>
```

27. Отображение информации на странице просмотра личной переписки.

```html
<xf:if is="$template == 'conversation_view'">
  <!-- content -->
</xf:if>
```

28. Скрытие информации на странице просмотра личной переписки.

```html
<xf:if is="$template != 'conversation_view'">
  <!-- content -->
</xf:if>
```

29. Отображение информации на странице просмотра списка личных переписок.

```html
<xf:if is="$template == 'conversation_list'">
  <!-- content -->
</xf:if>
```

30. Скрытие информации на странице просмотра списка личных переписок.

```html
<xf:if is="$template != 'conversation_list'">
  <!-- content -->
</xf:if>
```

31. Отображение информации на главной странице ресурсов.

```html
<xf:if is="$template == 'xfrm_overview'">
  <!-- content -->
</xf:if>
```

32. Скрытие информации на главной странице ресурсов.

```html
<xf:if is="$template != 'xfrm_overview'">
  <!-- content -->
</xf:if>
```

33. Отображение информации на странице просмотра ресурса.

```html
<xf:if is="$template == 'xfrm_resource_view'">
  <!-- content -->
</xf:if>
```

34. Скрытие информации на странице просмотра ресурса.

```html
<xf:if is="$template != 'xfrm_resource_view'">
  <!-- content -->
</xf:if>
```

35. Отображение информации на странице просмотра темы.

```html
<xf:if is="$template == 'thread_view'">
  <!-- content -->
</xf:if>
```

36. Скрытие информации на странице просмотра темы.

```html
<xf:if is="$template !='thread_view'">
  <!-- content -->
</xf:if>
```

37. Отображение информации на странице просмотра форума (раздела).

```html
<xf:if is="$template =='forum_view'">
  <!-- content -->
</xf:if>
```

38. Скрытие информации на странице просмотра форума (раздела).

```html
<xf:if is="$template != 'forum_view'">
  <!-- content -->
</xf:if>
```

39. Отображение информации "наказанным" пользователям.

```html
<xf:if is="{$xf.visitor.Option.is_discouraged}">
  <!-- content -->
</xf:if>
```

40. Отображение информации пользователям, которые имеют Gravatar.

```html
<xf:if is="{$xf.visitor.gravatar}">
  <!-- content -->
</xf:if>
```

41. Отображение информации пользователям поддержки форума.

```html
<xf:if is="{$xf.visitor.is_staff}">
  <!-- content -->
</xf:if>
```

42. Отображение информации пользователям без подтверждённого адреса e-mail.

```html
<xf:if is="{$xf.visitor.isAwaitingEmailConfirmation()}">
  <!-- content -->
</xf:if>
```

43. Отображение информации в нескольких форумах (разделах).

```html
<xf:if is="in_array({$forum.node_id}, [X, Y, Z])">
  <!-- content -->
</xf:if>
```

44. Скрытие информации в нескольких форумах (разделах).

```html
<xf:if is="in_array($forum.node_id, [X, Y, Z])">
  <!-- content -->
</xf:if>
```

45. Отображение информации в определённом форуме (разделе).

```html
<xf:if is="$forum.node_id == X">
  <!-- content -->
</xf:if>
```

46. Скрытие информации в определённом форуме (разделе).

```html
<xf:if is="$forum.node_id != 3">
  <!-- content -->
</xf:if>
```

47. Отображение информации только после первого сообщения в каждой теме.

```html
<xf:if is="{$post.position} % {$xf.options.messagesPerPage} == 1">
  <!-- content -->
</xf:if>
```

48. Отображение информации только внутри первого сообщения в каждой теме.

```html
<xf:if is="{$post.position} % {$xf.options.messagesPerPage} == 0">
  <!-- content -->
</xf:if>
```

49. Отображение информации только при заполненном поле местоположения.

```html
<xf:if is="{$xf.visitor.location}">
  <!-- content -->
</xf:if>
```

50. Отображение информации только при заполненном поле веб-сайта.

```html
<xf:if is="{$xf.visitor.website}">
  <!-- content -->
</xf:if>
```

51. Отображение информации при указанной подписи.

```html
<xf:if is="{$xf.visitor.signature}">
  <!-- content -->
</xf:if>
```

52. Отображение информации только активированным пользователям.

```html
<xf:if is="{$xf.visitor.user_state} == 'valid'">
  <!-- content -->
</xf:if>
```

53. Отображение информации только пользователям, ожидающим подтверждения адреса e-mail.

```html
<xf:if is="{$xf.visitor.user_state} == 'email_confirm_edit'">
  <!-- content -->
</xf:if>
```

54. Отображение информации только пользователям с проблемным адресом e-mail.

```html
<xf:if is="{$xf.visitor.user_state} == 'email_bounce'">
  <!-- content -->
</xf:if>
```

55. Отображение информации, если ID пользователя = ID автора темы.

```html
<xf:if is="{$__globals.thread} AND {$__globals.thread.user_id} == {$user.user_id}">
  <!-- content -->
</xf:if>
```

56. Отображение информации пользователю, который является автором темы.

```html
<xf:if is="{$thread.user_id} == {$xf.visitor.user_id}">
  <!-- content -->
</xf:if>
```
