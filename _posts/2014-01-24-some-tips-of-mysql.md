---
layout: default
title: "some tips of mysql"
description: ""
category: tips
tags: []
---

在bash中检查mysql是否连接成功：

方法1:
> mysql -uroot database </dev/null
>
> echo $?

or

方法2:
> mysql -uroot database -e "exit"
>
> echo $?

起初以为方法1会有连接没有关闭的问题，下面命令看了下没有问题，所以两种方法都是可以的。
> mysqladmin processlis
