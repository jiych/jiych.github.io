---
layout: post 
title: "Set up mutiple github users on one machine"
description: ""
category: tips
tags: []
---

这个问题在[这里](http://stackoverflow.com/questions/3225862/multiple-github-accounts-ssh-config)有比较详细的讨论，但是还是要花些时间才能搞清楚，我在实际操作的过程中也遇到了其他问题，大致流程如下(假设新账号为newaccount)：

1.创建ssh keys

`ssh-keygen -t rsa -C "newaccout@xxx.com"`

将key文件保存为~/.ssh/id_rsa_newaccount

2.本地添加1中生成的ssh私钥，并在github中添加公钥信息

`ssh-add ~/.ssh/id_rsa_newaccount`

我在操作这一步时候失败了，原因为需要启动ssh-agent，[见这里](http://stackoverflow.com/questions/17846529/could-not-open-a-connection-to-your-authentication-agent)

<code>eval `ssh-agent -s`</code>

`ssh-add ~/.ssh/id_rsa_newaccount`

`ssh-add -l` #查看是否添加成功
在github中添加公钥信息，很简单，见[这里](https://help.github.com/articles/generating-ssh-keys)

3.修改ssh配置，添加新增账号信息

`cat ~/.ssh/config`

>Host github.com
>HostName github.com
>User git
>IdentityFile ~/.ssh/id_rsa
>
>Host newaccount.github.com #这里随便写，和上面不同即可
>HostName github.com
>User git
>IdentityFile ~/.ssh/id_rsa_newaccount

4.测试两个账号是否设置成功

`ssh -T git@github.com`

Hi,XXX! You've successfully authenticated, but GitHub does not provide shell access.

`ssh -T git@newaccount.github.com` #注意这里和3中的配置主机名称一致

Hi,XXX! You've successfully authenticated, but GitHub does not provide shell access.

5.其它问题

也许在步骤4中你还会遇到`Bad owner or permissions on /home/user/.ssh/config`

执行下面命令

`cd ~/.ssh;chmod 600 *`
