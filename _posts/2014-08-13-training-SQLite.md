#Trainning: SQLite
最近做android应用，遇到一些SQLite的问题。看到这遍不错的文章，遂翻译之。也算尝个鲜:)

原文链接:[http://touchlabblog.tumblr.com/post/32793099735/training-sqlite](http://touchlabblog.tumblr.com/post/32793099735/training-sqlite)


一些简介。回到大约10年前，Android发展的路线有些和web相似。当web刚出现的时候，数据库丑陋、古怪、私有并且昂贵。大多数web应用会厂商使用文件，总之会避免使用数据库。开源数据库开始涌现，尽管如此，数据库的发展经历了很长的一段时间。

现在可以想像一下不使用数据库开发一个网络应用，我是无法想像的。数据库已经如同HTPP协议而自身成为必要的组件（当然可能有人要用“NOSQL”反驳我，这个话题同样是我将要在以后说明的）。

为清晰起见，这篇文章不会涉及如何在Android上实现基础的SQLite。网上有很多相关文章。这篇文章大多数内容是在别处找不到的，但是又是一个实际app开发者需要知道的。

＃The Basics

SQLite数据库存储在app应用的home目录，即在"databases"目录中。如果你的app叫"com.myapp.heyo"，数据库就在"/data/data/com.myapp.heyo/databases"下面。

数据库文件和app应用目录下的其他文件一样，也是属于app用户私有的。用户和linux下的用户一样，拥有类似的用户权限。这些文件通常处于安全考虑，对于外界是不可读的。但是如果你的手机如果被root了，或者有某些安全漏洞，读这些文件小菜一碟。心里要清楚自己app的安全需求。有一些项目会对数据库进行磁盘加密，但是超过此次讨论的内容。总之，大多数情况下数据是OK的，如果是一个敏感的app，存储数据时就小心点吧。

通过android Context可以获取数据库文件的句柄。不需要太费心思，通过SQL语句使用版本号，onCreate和onUpdate方法来管理数据库就可以了。同样有些API已经封装了一些，但人生苦短，SQL语句使用起来又很简单。

＃SQLiteOpenHelper

SQLiteOpenHelper是个好帮手，同样不用大费周章。不要尝试去使用那些API来隐藏复杂性，除非你非常了解这些API的实现。

如何管理SQLite的官方文档很少。这里，很简洁的谈几点最佳实践。

1. 对于一个数据库，创建一个并且只有一个SQLiteOpenHelper实例对象。可以通过一个静态变量，或者一个自定义的Application实例来实现。[我要重点强调这一点](http://stackoverflow.com/questions/2493331/what-are-the-best-practices-for-sqlite-on-android/3689883#3689883)

2. 不用考虑关闭数据库链接。这个不象网络连接。SQLite是个本地数据库，一个连接只是一个文件句柄。当进程结束时，所有的文件句柄都会关闭。

3. 一般程序上不会对SQLite文件造成伤害。文件损害只可能发生在存储器有问题或者SQLite自身有bug。不管时哪一种情况，你都无能为力。

使用一个连接的原因是因为连接本身是一个文件句柄。虽然程序不会损害数据库，但是多线程的写操作会导致混乱，而如果调用的是insert方法而不是insertOrThrow，当错误出现时甚至没有任何异样。[看这里](http://stackoverflow.com/questions/2493331/what-are-the-best-practices-for-sqlite-on-android/3689883#3689883)

SQLiteDatabase类会对并发访问进行管理。如果阅读源码,你会发现这些封装利用了java synchronization技术。当同一时间多个线程被调用时，SQLiteDatabase会帮你搞定一切。

在整个流程中，SQLiteDatabase仅维护唯一的SQLiteDatabase实例。使用它来帮助你开发吧。

还有个少为人知的地方是，你请求一个数据库读连接时，十有八九你得到的是一个写数据库的连接。SQLiteDatabase只是返回主连接。

为什么不关闭数据库连接不会有问题？在读操作时，很明显不会有问题。在写操作时，改变的时候会被写入到磁盘。这个过程是非常健壮的。如果数据库可以轻易被一些糟糕的应用破坏，Android将会变的一团糟。Android系统静静的引领你跳过陷阱，到达成功。

##Multiple Writes

如果你可能写多条记录（插、改、删？），用“事务”去实现吧。我在“事务”上加引号实际上是因为这个“事务”和服务端上的事务不是同样的。我对这块不是很清楚，但是我认为SQLite只是将“事务”写在内存中，提交时同一刷新到磁盘上。

Flash设备非常非常慢。如果不使用事务写50条记录，将会持续很长时间。而使用事务后，则只需要很短的时间。我的想法时在事务中，所有的编辑操作是在内存中进行的，当所有编辑完成后再统一写到外部设备上。如果没有事务，应用必须进行载入数据库，编辑，刷新到外部设备。。

总结就是，多次写操作放在一个事务里（单个写操作也可以这样，但没有必要）。

但是！如果在处理时有很多逻辑，还是不要全部放在一个事务中做了。你的其他调用需要等待。如果可能，在内存中做逻辑操作以及修改，然后使用一个事务进行写，再提交。

##Don’t over optimize

这是一个通用原则，不止是SQLite。如果你遵从了上面的原则，即只使用一个连接，把多次写操作放在一个事务里，但是依然有性能问题，那就要仔细想想你需要实现什么。我觉得你的其他地方出现了问题，或者你的设计很糟糕。

##Vacuum

免责申明，我没有测试这一点。当删除某些行，数据库不会回收这些空间，所以你可能需要自己清理。

##Space

数据库不是变魔术。它们占用应用的家目录空间。如果你创建了很多数据，你将占据很多空间。在现在的手机上，可能这个不是个重要问题。但是老的手机很缺乏空间。我曾经看到过一个twitter客户端，占用了25M以上的数据库空间。作为一个开发者，最有价值的地方就是随机应变以及一种通用的感觉。使用它们吧。

##"insert" and "insertOrThrow"

如果我对Android API设计有所遗憾的话，这两个将放在首位。作为一个通用原则，在所有的app或dom中，不要私吞异常。如果森林里一棵树倒下了，我应该知道。“insert” 方法只会给你一些logcat，如果幸运的话，你可能看到它们。更可能的是，你的用户会想为什么有些东西丢失了。

##ORMLite

……（省去120个字）

> 主要讲述ORMLite框架，不是太了解...主要就是将数据库操作转化为对象的操作了。

##Content Providers

> 没有干货，不翻了


##Summary

Use 1 SQLiteOpenHelper. It can be static because static variables only go away when the VM dies.

If you are doing multiple writes, use a transaction.

If you are doing lots of deletes, investigate vacuum.

Content Providers are crap (unless you’re sharing outside of your app).

Don’t Panic. 99% of apps are low volume, and as long as you’re not doing database ops in the main thread, none of this matters (except the single connection ;)

>总结的精华还是留给原文吧，而且困屎了。。

>2014年8月13日 2:35



