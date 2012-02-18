---
layout: default
title: "All posts"
---
<h1>All posts</h1>
<div class="related">
	<p>
		{% for post in site.posts %}
			<a href="{{ site.url }}{{ post.url }}">{{ post.title }}</a> &middot; {{ post.date | date: "%e" | ordinalize }} {{ post.date | date: "%B"}} {{ post.date | date: "%Y"}}
			{% unless forloop.last %}
				<br/>
			{% endunless %}
		{% endfor %}
	</p>
</div>
