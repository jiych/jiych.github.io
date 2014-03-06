---
layout: default
title: "solve jekyll utf-8 problem under windows"
description: ""
category: tips
tags: []
---

At the first beginning,I installed jekyll under Windows conveniently.
So I got the update jekyll,version 1.4.3.
After invoked `jekyll server`,I got errors:

>invalid byte sequence in GBK
>
>Use --trace to view backtrace

and so on.

After google,I found the problem was that my some post files including chinese words;and some people gave [their solutions](http://blog.jsfor.com/skill/2013/09/07/jekyll-local-structures-notes/):
1.uninstall jekyll 1.4.3
2.install jekyll 1.3.0 and change some code like this:

`self.content = File.read(File.join(base, name))`

to

`self.content = File.read(File.join(base, name),:encoding=>"utf-8")`

but in jekyll 1.3.0 source code `convertible.rb`,I couldn't find the same line like above.

And besides that,I found some [issues](https://github.com/jekyll/jekyll/issues/1948%20for%20more%20information) about jekyll 1.4.3 in github.
To avoid falling myself into trouble,I install jekyll 1.4.2 instead.
`gem uninstall jekyll`

`gem install jekyll "version=1.4.2"`

Unfortunately,the same annoying utf-8 question issued:

>invalid byte sequence in GBK

And I couldn't find the same line people changed in `convertible.rb`,I just looked through the code,and I got line:

`self.content = File.read_with_options(File.join(base, name),
				                                              merged_file_read_opts(opts))`

So...the function `merged_file_read_opts` defined as follow:

	def merged_file_read_opts(opts)
		(self.site ? self.site.file_read_opts : {}).merge(opts)
	end

I guessed that encoding should can be configure from configure file,`_config.yml`.

Just a try,added one encoding configuration in `_config.yml`:
`encoding: utf-8`

and then started jekyll

`jekyll sever`
>    Generating... done.
>  
>Server address: http://0.0.0.0:4000
> 
>Server running... press ctrl-c to stop.

and Wow,I got the question solved.
