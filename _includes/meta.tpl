<p class="meta">
{% if post.category != 'life' %}
	<span class="datetime">{{ post.date | date: "%Y-%m-%d" }}</span> posted in [<a href="/category/{{ post.category }}" class="category">{{ site.custom.category[post.category] }}</a>]
{% else %}
	<span class="datetime">{{ post.date | date: "%Y-%m-%d" }}</span> posted.</a>
{% endif %}
</p>
