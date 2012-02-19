---
layout: default
---
<h1>Techniki SilverStripe</h1>
{% for page in site.posts limit:5 %}
{% assign body = page.content %}
{% assign headingtag = 'h2' %}
{% include post-div.html %}
{% endfor %}

{% if site.posts.size > 5 %}
<div class="related">
	<h3>Pozostałe artykuły</h3>
	<p>{% for post in site.posts offset:5 %}<a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a>{% unless forloop.last %} &middot; {% endunless %}{% endfor %}</p>
</div>
{% endif %}
