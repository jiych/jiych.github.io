---
layout: post 
title: "Usage of bogofilter"
description: ""
category: oths
tags: []
---

[bogofilter][bogofilter_id1]是利用[bayes][bayes_id2]算法对邮件进行分类处理的过滤器，在很多linux发布版本中已经预装了，可以将其与一些邮件客户端
(evolution,thunderbird,etc.)配合使用进行垃圾邮件的过滤。


`bogofilter`自身只有命令行模式，支持很多参数，分为如下几类：

<pre><code>1.帮助类选项
如-Q查询当前bogofilter配置信息
2.分类选项
如指定输入方式，-B，-b等
3.注册选项
如-s指定训练样本为spam，-n指定训练样本为ham；对应的-S，-N为对应的undo操作
4.通用选项
如-c指定配置文件，-C则相反，表示不读取默认的配置文件
5.参数选项
如-o指定spam、ham的阈值
6.信息选项
如-v用于查询信息的详细程度，-x `c`用于调试，`c`指定调试的模块，如A指定算法部分,L表示词法部分，参见debug.h
7.配置文件选项
采用--option=value方式，可以更改配置文件中指定参数的值，参见bogofilter.cf(一般在/etc下)
</code></pre>
详细信息参考`man bogofilter`。

`bogofilter`支持三种输入检测方式：

1.normal模式(默认)，由标准输入获得其检测文件参数，检测完成后结束；

2.stdin模式，由标准输入获得其检测文件参数，但支持多次检测，直到用户主动退出，如^D等；

3.command line模式，由命令行指定，可以指定多个检测文件，完成后退出。


`bogofilter`可以简单看作是通过对邮件中`token`在数据库中的静态匹配，进一步计算出此邮件属于ham或spam的概率，所以`bogofilter`的准确率取决于数据库的
训练质量。训练时，使用`bogofilter`中的trainbogo.sh指定spam及ham邮件样本的目录即可。需要注意的是，在训练时保证在$(HOME)下存在.bogofilter目录。
训练完成后，在$(HOME)/.bogofilter下生成wordlist.db即为训练结果。可以观察下该数据库的格式：

    $ file ~/.bogofilter/wordlist.db

    Berkeley DB (Btree, version 9, native byte-order)

可以看到，生成的数据库为bdb格式，这是`bogofilter`默认支持的数据库。`bogofilter`还支持sqllite3、qdbm等，可在编译时进行指定。

后续将对`bogofilter`的实现细节进行分析。

[bogofilter_id1]:http://bogofilter.sourceforge.net
[bayes_id2]:http://http://en.wikipedia.org/wiki/Bayes%27_theorem
