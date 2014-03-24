---
layout: post 
title: "结构体字节对齐问题"
description: ""
category: c
tags: []
---

编译器对结构体进行内存对齐，出于两个方面的原因：

- 某些计算机体系只能从某些特定地址处进行访问，如4的整数地址，否则会抛出异常。
- 加快cpu存取数据速度，如果字节不对齐，可能需要多次操作数据总线，再将获取到的字节进行拼接，严重降低数据存取效率，参看[这里](http://www.alexonlinux.com/aligned-vs-unaligned-memory-access)。

----------------------------

编译器对机构体字节对齐遵循以下几个原则（未指定pack时）：

1.  第一个成员从offset 0开始存储
2.  后续成员以自身长度（数组：单个成员，结构体：此结构体内部最长成员）的整数倍地址进行排列
3.  总大小为内部成员的整数倍，不足补齐

当指定pack为n时，上面几条变为：

1.  第一个成员从offset 0开始存储
2.  后续成员以n的整数倍地址进行排列
3.  总大小为n的整数倍，不足补齐

------------------------------

分析几个实例,以下环境为redhat3.2，gcc版本3.2.2,x86
    
未指定pack，gcc默认4字节对齐

    struct A1{
    	char c1;   //offset:0
    	short s1;  //offset:2
    	char c2;   //offset:4
    	int i1;    //offset:8
    }a1;           //total:12


    struct A2{   
    	char c1;  //offset:0
    	char c2;  //offset:1
    	short s1; //offset:2
    	int i1;   //offset:4
    }a2;          //total:8
	
    
    struct A3{
    	int i1;     //offset:0
    	char c1;    //offset:4
    	short s1[2];//offset:6
    	float f1;   //offset:12
    }a3;            //total:16
	
	struct A4{
		short s1;     //offset:0
		struct A3 a3; //offset:4,a3中最大成员长度为4
		int i1;       //offset:20
	}a4;              //total:24

指定pack，只支持指定1，2，4
    
    #pragma pack(2)
    struct B1{
    	int i1;  //offset:0
    	char c1; //offset:4
    	short s1;//offset:6
    	char c2; //offset:8
    }b1;         //total:10
    #pragma pack()

指定为其他n时，可类似分析。
