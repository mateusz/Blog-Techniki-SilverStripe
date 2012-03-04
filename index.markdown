---
layout: default
---
<div class="homePage">

<h1>Techniki SilverStripe</h1>
{% for page in site.posts limit:10 %}
{% capture body %}
    {% for item in page.content | split:'<!-- more start -->' limit:1 %}
        {{ item }}
        <p><a href="{{ site.url }}{{ page.url }}">Zobacz cały artykuł &raquo;</a></p>
    {% endfor %}
{% endcapture %}
{% assign headingtag = 'h2' %}
{% include post-div.html %}
{% endfor %}

{% if site.posts.size > 10 %}
<div class="related">
	<h2>Pozostałe artykuły</h2>
	<p>{% for post in site.posts offset:10 %}<a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a>{% unless forloop.last %} &middot; {% endunless %}{% endfor %}</p>
</div>
{% endif %}

</div>
