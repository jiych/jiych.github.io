---
layout: post 
title: "crackme之splish的逆向过程"
description: ""
category: security
tags: []
---

今天学习一个名为splish的crackme逆向分析，参看[这里](http://bbs.pediy.com/showthread.php?t=187565)。

##01 分析


首先，打开splish，进行注册试用，第一个硬编码的很简单，直接在OD中就可以看到：

![image][1]

在此不再赘述，直接看第二个。

通过`Ctrl+N`查看当前模块中的名称，`GetWindowTextA`函数看起来是获取输入用的，在此函数设置断点。
F9运行后填入Name:2Name和Serial:2Serial之后，点击Check。程序果然断了下来，执行到返回后，在数据
窗口中跟随函数的buffer地址，可以看到输入的序列号信息被保存下来了。

![image][2]

![image][3]

![image][4]

继续F9运行后，发现程序又一次中断在`GetWindowTextA`处，同样执行到返回后，可以看到输入的Name信息被保存了下来。

![image][5]

F8单步执行，代码中首先对Name的每个字符进行依次处理。

处理流程：遍历Name的每个字符，将每个字符的ascii码除以10后取余数，再将余数和当前字符的索引进行下xor操作；xor后的结果加2以后的值和10比较，若比10大，则将值减去10，然后进行下一个字符的处理；否则，直接处理下一个字符。最终处理完成后的结果存储在403258处。

![image][6]

Name处理完成后，对Serial进行了类似处理。

处理流程：遍历Serial的每个字符，将每个字符的ascii码除以10后的余数存储到40324D处。

![image][7]


继续单步，最终的判断只是将前面的两处（403258、40324D）结果进行对比，只对比Name长度（保存在403463处）的字符。

![image][8]

##02 注册机代码

基于前面的分析，可以很容易写出对应的注册机。实现原理：遍历Name的每个字符，除以10后的余数xor字符的索引，再将所得值加上10的若干倍数就可以获取序列号。所以，这里一个Name的序列号不是唯一的。实现代码如下：

![image][9]


[1]:http://github-jiych.qiniudn.com/a645e24bf5e35d070f680cd79511e98fa409bd20-51066bf955fe18bf1072c68e1006c3f176b8d346.png
[2]:http://github-jiych.qiniudn.com/35695d00621362852d17542d505cbb510d334198-6fb4b3dffe2947fad127d7dbe402762209f0a6c8.png
[3]:http://github-jiych.qiniudn.com/750e0ad8f215b367f497d761ec46dae7203d9cfb-3258362d6c5f3850f7b10960c1bf4e555cec9417.png
[4]:http://github-jiych.qiniudn.com/5e887755cc27cca0c892938da33de9d430a082b3-9a3bac3416772bcce3c8aa31d21efd2f91257485.png
[5]:http://github-jiych.qiniudn.com/fed277c5581260d9b518fee60dfc48398d8f9bee-ba62b89473aa80abfdd55835c47c3f187ae68c54.png
[6]:http://github-jiych.qiniudn.com/1991a4887498c2adaf64740ab04d2480aa55d118-0947700313598b0ae995ed7ba95eefd60d9b5d3c.png
[7]:http://github-jiych.qiniudn.com/0bd1b627e98b1fb470d2d56d071b0e0a95ab92e3-9995991d32779d11fdbda7c2c1cce616c1c3e1a2.png
[8]:http://github-jiych.qiniudn.com/0f9a583def2c73cb41d638a81bdacadcc24021ae-3d09e06a01f37f8b3b1007c56415ae0a2b9c9b3f.png
[9]:http://github-jiych.qiniudn.com/67e93f1ac976e14e7fbd8e97a95bc40993843438-52b0b4d11822cc1f28e1d0fdfc916ed03d06d453.png
