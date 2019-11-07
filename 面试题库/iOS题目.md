## iOS技术面试题
| 提供者| 大概时间| 
| ------ |-------| 
| 文永军 |90min左右| 

##1、简单的做下自我介绍
```
关注点：考察下介绍和简历是否一致，现场的把控和语言表达能力。
```
##2、控制器的生命周期
```
参考答案：
1、 alloc                                   创建对象，分配空间
2、init (initWithNibName) 初始化对象，初始化数据
3、loadView                          从nib载入视图 ，通常这一步不需要去干涉。除非你没有使用xib文件创建视图
4、viewDidLoad                   载入完成，可以进行自定义数据以及动态创建其他控件
5、viewWillAppear              视图将出现在屏幕之前，马上这个视图就会被展现在屏幕上了
6、viewDidAppear               视图已在屏幕上渲染完成
7、dealloc 销毁 （通过该方法内还可以检测什么？ 答案：返回后看时候回调该函数 来判断是否有内存泄露）
.
.
.

要求：对生命周期要熟悉精通，中间可以根据情况自己把握 讨论具体某个函数
```
##3、如何使UILabel显示多行？
```
参考答案：numberOfLines = 0
```
##4、frame和bounds有什么不同？
```
参考答案：相对父 与 自身
```
##5、 assign、retain、copy、strong、weak什么时候用？区别？
```
参考答案：
assign 基本数据类型与代理使用
retain 引用计数在用来的基础上加1
copy 开辟个新的内存空间
strong 相当于老版本的retain,而且可以不再需要做release操作了
weak 相当于老版本的assign。但是只适应于对象
```
##6、imageName与imageContentOfFile的区别
```
参考答案：
后者没有缓存 适用于只需要一次使用  减少对系统内存的耗用情况
```
##7、对于单元格重用的理解？
```
参考答案：
1、当屏幕上滑出屏幕时，系统会把这个单元格添加到重用队列中，等待被重用。
2、当有新单元从屏幕外滑入屏幕内时，从重用队列中找看有没有可以重用的单元格，
若有，就直接用，没有就重新创建一个。
```
##8、Category的优缺点
```
参考答案：
优点：可以不创建子类的前提下扩展方法、可以对比较胖的类进行拆分。
缺点：如果和类的方法起的重名会覆盖类中的方法、不能添加实例变量。

```
##9、Delegate、Notification、Block区别与使用场景
```
参考答案：
Delegate是一对一的回调机制
Notification是一对多的对所有添加观察者的通知
Block代码比较简洁不需要像代理一样定义协议方法
```

##10、GCD中队列都是哪几种？
参考答案：以下四种队列

| 串行队列 | 并行队列 | 全局队列 |主队列|
| ------ |-------| -----| -----|
| DISPATCH_QUEUE_SERIAL | DISPATCH_QUEUE_CONCURRENT| dispatch_get_global_queue | dispatch_get_main_queue |
| 队列中的任务只会顺序执行 | 队列中的任务通常会并发执行| 是系统的 |在多线程开发中，使用主队列更新UI |

##11、有A、B 2个异步请求，如何判断A、B都完成执行？如果需要A、B顺序执行，该如何实现？
```
参考答案：能说出group和group_notify即可
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_group_t group = dispatch_group_create();
dispatch_group_async(group, queue, ^{ /*任务A */ });
dispatch_group_async(group, queue, ^{ /*任务B */ });
dispatch_group_notify(group,dispatch_get_main_queue(), ^{
 // 在A、B异步执行完成后，会回调这里
});

第二问：能说出把用串行队列即可
```
##12、自动布局之autoresizingMask UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin含义和内部原理是怎么样的？
```
参考答案：
知道这段代码的表面含义：左右间距不变自动调整宽度 和 顶部间距不变
其次知道枚举的状态和选项模式 
外部通过按位或 
内部实现是通过位与操作运算实现的（可要求拿笔书写大致内部实现代码流程）
```
##13、什么是 RunLoop？
```
参考答案：
从字面上讲就是运行循环，它内部就是do-while循环，在这个循环内部不断地处理各种任务。
一个线程对应一个RunLoop，基本作用就是保持程序的持续运行，处理app中的各种事件。通过runloop，有事运行，没事就休息，可以节省cpu资源，提高程序性能。

主线程的run loop默认是启动的。iOS的应用程序里面，程序启动后会有一个如下的main()函数
int main(int argc, char * argv[]) {
	@autoreleasepool {
    	return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}

然后顺势承接下一题
```
##14、滑动tableview的时候 定时器不执行的原因？解决办法？
```
和上一题做承接
参考答案：
首先：将NSTimer添加到主线程NSRunLoop的默认模式下，只有主线程是默认模式下才能执行NSTimer
（滚动scrollView，RunLoop默认进入Tracking模式，所以NSTimer不会有效果）。
其次：只要将 timer 添加到 Common 占位模式下，timer就可以在Default和UITrackingRunLoopMode模式下都能运行（Common是一个表示，它是将NSDefaultRunLoopMode 和 UITrackingRunLoopMode标记为了Common）
```
##15、哪些情况下会造成内存泄露？
```
参考答案：
A、B对象进行强引用、代理强引用、block循环引用、timer、N次循环造成的内存上涨(autoReleasePool添加) 、用到Core Foundation对象（CFRelease）等。
```
##16、Runtime实现的机制是什么，一般用于什么场景？
```
参考答案：
1). 使用时需要导入的头文件 <objc/message.h> <objc/runtime.h>
2). Runtime 运行时机制，它是一套C语言库。
3). 实际上我们编写的所有OC代码，最终都是转成了runtime库的东西。

应用场景：
    （1）获取类里面的所有成员变量。
    （2）为类动态添加成员变量。
    （3）动态改变类的方法实现。
    （4）为类动态添加新的方法等。
用于模型抽象
```
##17、什么是 Method Swizzle？
```
参考答案：
1). 在没有一个类的实现源码的情况下，想改变其中一个方法的实现，除了继承它重写、和借助类别重名方法暴力抢先之外，还有更加灵活的方法 Method Swizzle。
2). Method Swizzle 指的是改变一个已存在的选择器对应的实现的过程。OC中方法的调用能够在运行时通过改变，通过改变类的调度表中选择器到最终函数间的映射关系。
3). 在OC中调用一个方法，其实是向一个对象发送消息，查找消息的唯一依据是selector的名字。利用OC的动态特性，可以实现在运行时偷换selector对应的方法实现。
4). 每个类都有一个方法列表，存放着selector的名字和方法实现的映射关系。IMP有点类似函数指针，指向具体的方法实现。
5). 我们可以利用 method_exchangeImplementations 来交换2个方法中的IMP。
6). 我们可以利用 class_replaceMethod 来修改类。
7). 我们可以利用 method_setImplementation 来直接设置某个方法的IMP。
8). 归根结底，都是偷换了selector的IMP。
```
##18、通过简历中开发过的项目，了解下项目分工和面试者负责的模块，怎么进行开发、维护的？
```
参考答案：对负责的模块应该有清晰的思路
```
##19、在iOS中业务模块的编程风格是怎样的？
```
参考答案：
MVC、业务逻辑与用户界面分离、代码按区区域划分、多用组合、
用类别防止类过胖保持易维护易扩展等等
（只要编程习惯保证代码的简洁性、可阅读下皆可）  良好的编程风格可减少内存泄露和其它bug的出现。
```
##20、最近在技术方面最有成就感的事？或者说最有成就感的项目是哪个？
```
参考答案：
一般为攻破了某个技术难题。可以针对面试者开发的项目 多聊聊 了解下面试者的思路。
```
##21、上面的技术难题怎么攻破的？
```
参考答案：
了解该面试者解决问题的方式、渠道。
```
##22、未来几年的职业规划？
```
参考答案：
暂无具体  （多聊聊 感受下性格以及与人相处，
至于职业规划只要符合部门的需要即可）
```
##23、问下面试者他想了解哪些？
```
目的：了解下面试者的诉求、看他对公司是否有兴趣、看性格和表达能力
```