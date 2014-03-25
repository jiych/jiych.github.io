{% include header.tpl %}

{% for post in list %}
<article{% if forloop.index == 1 and preview %} content-loaded="1"{% endif %}>
	{% if post.category != 'life' %}
		<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
	{% else %}
		<h2>{{ post.title }}</a></h2>
	{% endif %}
	{% include meta.tpl %}
	<div class="article-content">
	{% if forloop.index == 1 and preview and post.layout == 'post' %}
		{% if post.category != 'life' %}
			{{ post.content }}
		{% else %}
			#You dont have rights to see this#
		{% endif %}
	{% endif %}
	</div>
</article>
{% endfor %}

{% if list == null %}
<article class="empty">
	<p>该分类下还没有文章</p>
</article>
{% endif %}
