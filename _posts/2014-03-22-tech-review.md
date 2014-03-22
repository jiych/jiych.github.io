---
layout: post 
title: "面试常见问题汇总"
description: ""
category: life 
tags: []
---

这里记述我的几次面试感想，以备参考。

----------------------------

##H公司##

H公司面试时，面试官比较倾向于从你对所做项目的讲述中得到信息。所以需要你对所做过东西有比较整体的把握，能够将项目的来龙去脉理清，并叙述出来。总体来讲，H公司的技术面试似乎看中面试者的工作经验，而不会去考察某个具体的细节问题。这种面试看似简单，但是需要平时注意积累，好多东西做的时候很清楚，但是平时不积累总结，临时就很难把做过的描述清楚。另外，平时还要把眼光放远些，不能只关注自己所做的模块，还要关心自己模块的上下游，以及整个系统的大致流程。把握上面几个地方，讲述的时候才能游刃有余。H公司的上机网考就完全是鸡肋，基本上都不会有问题的。H公司有个比较蛋痛的地方是所谓的性格测试，这个还是不能上当(如果有人告诉你怎么想就怎么填的话)，还是按你的理智填写吧(比如问你喜欢:1.独处;2.和很多人一起什么的;还是选2吧^_^)。如果挂了，那...就挂了吧，这个没人知道对错。


##Z公司##

Z公司面试比较杂乱，部门与部门之间似乎没有资源共享，所以可能面了A部门还会面B部门。Z公司会先笔试(bs)你，其实bs题挺基础的，但是保不准有些语言特性你很久不用就忘记了。这样就导致很简单的问题，你却犯错了，所以会有损形象。比如(字节对齐)[http://jiych.github.io/posts/memory-align.html]，或是让你写位域的申明（做上层应用基本不会用到的）。Z公司同样会问做过的项目，而且会更细节。比如你遇到过哪些棘手的问题，如何解决的等。所以还是如上所说，平时要多总结，尤其是我这过脑就忘的。Z公司似乎HR的功能比较小，只要你技术过关，要钱不超线，那就来吧，哈哈。

##T公司##

T公司在我看来是有些装的成分的，也难怪，毕竟号称自己是外资。T公司同样会先bs你，bs题里有些比较有意思的。如猜猜下面这个函数的作用：


  //已知pcs中为lower-case ascii
  int unnamed(const char *pcs)
  {
  	int len = strlen(pcs);
  	int i = 0;
  	unsigned checker = 0;
  
  	while(i < len){
  		unsigned val = pcs[i] - 'a';
  		if((checker& (1<<val)) > 0)
  			return TRUE;
  		checker |= (1<<val);
  		i++;
  	}
  
  	return FALSE;
  }


我觉得这个题目实现的挺好的，一开始我也看得有点闷，所以印象很深。又比如：

> 假定你要把4G的数据放到一个hash表里，在1G内存情况下怎么样实现？

我不太清楚这个题目答案应该是什么样，我回答是：在内存中存放key值，指向的value值存放在外部存储器中。也不知道对不对，回头学习下。还有题目是找数字规律，就和我朝zf招工时候的试题类似，我完全不会。

T公司的面试就挺扯的，可能因为我的背景和他们相差太多的缘故，总觉得沟通起来有些困难。他们问了一些问题，也大概只是为了提高自己的b格。比如，你认为XX行业未来可能的趋势是怎么样的？我心里想，我tm哪里知道？！又比如，你觉得XX行业未来可以做的有哪些？我心里想，我tm哪里知道？！总之，觉得有些扯淡，我难以理解面试官想考察什么，或者真的只是为了提高b格吗？！

另外，还有些东拼西凑的面试题目，如：

- 让你手写个strstr；
- 说说你对linux进程管理的理解；
- 网络处理中，如何避免恶意用户的连接。

------------------------------

总结一下：

1.<b>注意平时的积累，工作中遇到的问题要及时记录，很重要</b>；否则，面试时很容易就哑火；

2.注意自己工作所在项目的整体性，要对全局有把握；

3.多看看内核、驱动，深入学习一个模块；(很多面试官顺嘴就是你看过内核吗？)

4.面试要提前做些准备，要刷些面经，常用算法，计算机理论等。
