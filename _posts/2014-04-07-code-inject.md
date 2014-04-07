---
layout: post 
title: "代码植入问题"
description: ""
category: secure
tags: []
---

在做*0day安全：软件漏洞分析技术（第二版）*书中2.4节代码植入问题时，按照书本中给出的方法：利用depands工具计算MessageBoxA的入口地址，出现了一些问题。

我的环境为XP
SP2、VC++6.0（SP6），我在使用debug版本时，发现使用depands工具未发现使用user32.dll动态库，怀疑编译器自动识别没有调用库中接口，所以没有将库导入，所以我手动在代码中调用了`MessageBoxA(NULL,"joy","joy",NULL);`。

重新编译链接后，在depands中看到了库user32.dll，然后根据书中的方法计算得出了MessageBoxA的地址，将书中给定的shellcode作相应的适配，即可得到想要的弹窗效果。
