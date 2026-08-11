---
layout: default
title: Blog
permalink: /blog/
---

<h1>Blog</h1>

{% for post in site.posts %}
  <article>
	<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
	<p class="muted">{{ post.date | date: "%B %d, %Y" }}</p>
	<p>{{ post.excerpt }}</p>
  </article>
{% endfor %}
