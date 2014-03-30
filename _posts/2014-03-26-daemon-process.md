---
layout: post 
title: "daemon process"
description: ""
category: linux 
tags: []
---

Linux中的守护进程是运行于后台的服务进程。它独立于控制终端并且周期性的执行某种任务或处理某些事件。

创建守护进程的几个步骤：

1.创建子进程，父进程退出

用于子进程脱离控制终端，父进程先退出导致子进程成为孤儿进程，这样1号进程（init）就会主动领养此子进程。

2.子进程中创建新会话

此步骤利用系统调用setsid实现，首先需要了解**进程组**及**会话期**的概念:

**进程组**：是一个或多个进程的集合。进程组用进程组ID标识，每个进程组有一个进程组长，进程组长ID即为进程组ID。进程组ID不会因为进程组长的退出而改变。

**会话期**：是一个或多个进程组的集合。

setsid作用：
用于创建新会话，并担任该会话组的组长。调用setsid由以下作用：
*让进程摆脱原会话的控制
*让进程摆脱原进程组的控制
*让进程摆脱原控制终端的控制

在创建守护进程的步骤1中调用了fork函数创建子进程，再将父进程退出。由于在调用fork函数后，子进程全盘拷贝了父进程的会话期、进程组、控制终端等，虽然父进程退出了，但会话期、进程组、控制终端等并没有改变，因此，还还不是真正意义上的独立开来，而setsid函数能够使子进程完全独立出来，从而摆脱其他进程的控制。

3.改变当前目录为根目录

fork创建的子进程继承了父进程的当前工作目录。进程在运行期间其工作路径所在目录是不可以卸载的，这对以后的使用会造成诸多的麻烦。所以一般会使用chdir改变守护进程的工作路径。

4.重设文件权限掩码

文件权限掩码是指屏蔽掉文件权限中的对应位。比如，有个文件权限掩码是050，它就屏蔽了文件组拥有者的可读与可执行权限。由于使用fork函数新建的子进程继承了父进程的文件权限掩码，这就给该子进程使用文件带来了诸多的麻烦。因此，把文件权限掩码设置为0，可以大大增强该守护进程的灵活性。设置文件权限掩码的函数是umask。在这里，通常的使用方法为umask(0)。

5.关闭文件描述符

同文件权限码一样，用fork函数新建的子进程会从父进程那里继承一些已经打开了的文件。这些被打开的文件可能永远不会被守护进程读写，但它们一样消耗系统资源，而且可能导致所在的文件系统无法卸下。

参照上面的步骤，创建一个守护进程：

    #include <stdlib.h>
    #include <stdio.h>
    #include <fcntl.h>
    
    void daemonize(void)
    {
    	pid_t  pid;
    
    	/*
    	 * Become a session leader to lose controlling TTY.
    	 */
    	if ((pid = fork()) < 0) {
    		perror("fork");
    		exit(1);
    	} else if (pid != 0) /* parent */
    		exit(0);
    	setsid();
    
    	/*
    	 * Change the current working directory to the root.
    	 */
    	if (chdir("/") < 0) {
    		perror("chdir");
    		exit(1);
    	} 
    
    	/*
    	 * Attach file descriptors 0, 1, and 2 to /dev/null.
    	 */
    	close(0);
    	open("/dev/null", O_RDWR);
    	dup2(0, 1);
    	dup2(0, 2);
    }
    
    int main(void)
    {
    	daemonize();
    	while(1);
    }

在编译运行后，使用`ps jx`查看：

`$./a.out`

>ps  xj | grep a.out
>1 11421 11420  8460 pts/0    11422 R      500   0:08 ./a.out
>8460 11423 11422  8460 pts/0    11422 S+     500   0:00 grep a.out

其中，参数x表示不仅列出有控制终端的进程，也列出所有无控制终端的进程，参数j表示列出与作业控制相关的信息。

可以用`ps ajx`查看系统中相关作业进程信息。


<pre><code>$ ps axj
PPID   PID  PGID   SID TTY      TPGID STAT   UID   TIME COMMAND
0     1     1     1 ?           -1 Ss       0   0:01 /sbin/init
0     2     0     0 ?           -1 S<       0   0:00 [kthreadd]
2     3     0     0 ?           -1 S<       0   0:00 [migration/0]
2     4     0     0 ?           -1 S<       0   0:00
[ksoftirqd/0]
...
1  2373  2373  2373 ?           -1 S<s      0   0:00
/sbin/udevd --daemon
...
1  4680  4680  4680 ?           -1 Ss       0   0:00
/usr/sbin/acpid -c /etc
...
1  4808  4808  4808 ?           -1 Ss     102
0:00 /sbin/syslogd -u syslog
...
</code></pre>

其中，TPGID一栏写着-1的都是没有控制终端的进程，也就是守护进程。在COMMAND一列用[]括起来的名字表示内核线程，这些线程在内核里创建，没有用户空间代码，因此没有程序文件名和命令行，通常采用以k开头的名字，表示Kernel。


参考：

- http://learn.akae.cn/media/ch34s03.html
- http://my.oschina.net/guol/blog/121865
- http://www.cnblogs.com/mickole/p/3188321.html
