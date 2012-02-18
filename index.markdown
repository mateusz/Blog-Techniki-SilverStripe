---
layout: default
---
<h1>Mateusz Uzdowski on SilverStripe</h1>
{% for page in site.posts limit:5 %}
{% assign body = page.content %}
{% assign headingtag = 'h2' %}
{% include post-div.html %}
{% endfor %}
<div class="related">
	<h3>More Posts</h3>
	<p>{% for post in site.posts offset:5 %}<a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a>{% unless forloop.last %} &middot; {% endunless %}{% endfor %}</p>
</div>
