# 模板设计者文档

## 变量

```
{{ foo.bar }}
{{ foo['bar'] }}
```

## 过滤器

例如 `{{ name|striptags|title }}` 会移除 name 中的所有 HTML 标签并且改写 为标题样式的大小写格式。

## 测试

```
{% if loop.index is divisibleby 3 %}
{% if loop.index is divisibleby(3) %}
```

## 注释

默认使用 `{# ... #}` 注释语法。

## 空白控制

当你在块（比如一个 for 标签、一段注释或变 量表达式）的开始或结束放置一个减号（ `-` ），可以移除块前或块后的空白:

```
{% for item in seq -%}
    {{ item }}
{%- endfor %}

```

这会产出中间不带空白的所有元素。如果 seq 是 `1` 到 `9` 的数字的列表， 输出会是 `123456789` 。

## 转义

你想在在使用把 `{{` 作为原始字符串使用

```
{{ '{{' }}
```

对于较大的段落，标记一个块为 raw 是有意义的。例如展示 Jinja 语法的实例， 你可以在模板中用这个片段:

```
{% raw %}
    <ul>
    {% for item in seq %}
        <li>{{ item }}</li>
    {% endfor %}
    </ul>
{% endraw %}
```

## 行语句

下面的两个例子是等价的:

```
<ul>
# for item in seq
    <li>{{ item }}</li>
# endfor
</ul>

<ul>
{% for item in seq %}
    <li>{{ item }}</li>
{% endfor %}
</ul>
```

```
<ul>
# for href, caption in [('index.html', 'Index'),
                        ('about.html', 'About')]:
    <li><a href="{{ href }}">{{ caption }}</a></li>
# endfor
</ul>
```

从 Jinja 2.2 开始，行注释也可以使用了。

```
# for item in seq:
    <li>{{ item }}</li>     ## this comment is ignored
# endfor
```

## 模板继承

### 基本模板

```html
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    {% block head %}
    <link rel="stylesheet" href="style.css" />
    <title>{% block title %}{% endblock %} - My Webpage</title>
    {% endblock %}
</head>
<body>
    <div id="content">{% block content %}{% endblock %}</div>
    <div id="footer">
        {% block footer %}
        &copy; Copyright 2008 by <a href="http://domain.invalid/">you</a>.
        {% endblock %}
    </div>
</body>
```

### 子模板

```html
{% extends "base.html" %}
{% block title %}Index{% endblock %}
{% block head %}
    {{ super() }}
    <style type="text/css">
        .important { color: #336699; }
    </style>
{% endblock %}
{% block content %}
    <h1>Index</h1>
    <p class="important">
      Welcome on my awesome homepage.
    </p>
{% endblock %}
```