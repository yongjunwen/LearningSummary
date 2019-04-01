//
//  ViewController.m
//  Lock
//
//  Created by wenyongjun on 2019/4/1.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//

#import "ViewController.h"
#import <libkern/OSAtomic.h>
#import <os/lock.h>

#import <pthread.h>




@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [self spinLock];
//    [self unfairLock];
//    [self semaphoreLock];
    
//    [self pthreadMutexLock];
    
//    [self pthreadMutexRecursiveLock];
    
//    [self normalLock];
    
//    [self NSCondition_lock];
    
//    [self NSRecursiveLock_lock];
    
    [self NSConditionLock_lock];

}

/*
 自旋锁  已被苹果废弃 os_unfair_lock替代
 */
-(void)spinLock{
    __block OSSpinLock oslock = OS_SPINLOCK_INIT;
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        OSSpinLockLock(&oslock);
        sleep(4);
        NSLog(@"线程1");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程1 解锁成功");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        OSSpinLockLock(&oslock);
        NSLog(@"线程2");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程2 解锁成功");
    });
}

/*
 os_unfair_lock
 #import <os/lock.h>

 */
-(void)unfairLock{
    __block os_unfair_lock theLock = OS_UNFAIR_LOCK_INIT;
;
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        os_unfair_lock_lock(&theLock);
        sleep(4);
        NSLog(@"线程1");
        os_unfair_lock_unlock(&theLock);
        NSLog(@"线程1 解锁成功");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        os_unfair_lock_lock(&theLock);
        sleep(2);

        NSLog(@"线程2");
        os_unfair_lock_unlock(&theLock);
        NSLog(@"线程2 解锁成功");
    });
}

/*
 信号锁
 
 比喻：停车场剩余4个车位，那么即使同时来了四辆车也能停的下。如果此时来了五辆车，那么就有一辆需要等待。
 信号量的值（signal）就相当于剩余车位的数目，dispatch_semaphore_wait 函数就相当于来了一辆车，dispatch_semaphore_signal 就相当于走了一辆车。停车位的剩余数目在初始化的时候就已经指明了（dispatch_semaphore_create（long value）），调用一次 dispatch_semaphore_signal，剩余的车位就增加一个；调用一次dispatch_semaphore_wait 剩余车位就减少一个；当剩余车位为 0 时，再来车（即调用 dispatch_semaphore_wait）就只能等待。有可能同时有几辆车等待一个停车位。有些车主没有耐心，给自己设定了一段等待时间，这段时间内等不到停车位就走了，如果等到了就开进去停车。而有些车主就像把车停在这，所以就一直等下去。
 */
-(void)semaphoreLock{
    dispatch_semaphore_t signal = dispatch_semaphore_create(1); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 等待ing");
        dispatch_semaphore_wait(signal, overTime); //signal 值 -1
        NSLog(@"线程1");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程1 发送信号");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 等待ing");
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal);
        NSLog(@"线程2 发送信号");
    });
}

/*
 互斥锁
 #import <pthread.h>

 */
-(void)pthreadMutexLock{
    
    static pthread_mutex_t pLock;
    pthread_mutex_init(&pLock, NULL);
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        pthread_mutex_lock(&pLock);
        sleep(3);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
    });
    
    //1.线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
    });
}

/*
 递归锁
 #import <pthread.h>
 
 经过上面几种例子，我们可以发现：加锁后只能有一个线程访问该对象，后面的线程需要排队，并且 lock 和 unlock 是对应出现的，同一线程多次 lock 是不允许的，而递归锁允许同一个线程在未释放其拥有的锁时反复对该锁进行加锁操作。
 
 */
-(void)pthreadMutexRecursiveLock{
    
    static pthread_mutex_t pLock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
    pthread_mutex_init(&pLock, &attr);
    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
    
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                NSLog(@"value: %d", value);
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&pLock);
        };
        RecursiveBlock(5);
    });
}

/*
 NSLock 普通锁
 lock、unlock：不多做解释，和上面一样
 trylock：能加锁返回 YES 并执行加锁操作，相当于 lock，反之返回 NO
 lockBeforeDate：这个方法表示会在传入的时间内尝试加锁，若能加锁则执行加锁操作并返回 YES，反之返回 NO
 */

-(void)normalLock{
    
    
    NSLock *lock = [NSLock new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 尝试加速ing...");
        [lock lock];
        sleep(3);//睡眠5秒
        NSLog(@"线程1");
        [lock unlock];
        NSLog(@"线程1解锁成功");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 尝试加速ing...");
        BOOL x =  [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        if (x) {
            NSLog(@"线程2");
            [lock unlock];
        }else{
            NSLog(@"失败");
        }
    });
}

/*
 NSCondition
 
 wait：进入等待状态
 waitUntilDate:：让一个线程等待一定的时间
 signal：唤醒一个等待的线程
 broadcast：唤醒所有等待的线程
 */

-(void)NSCondition_lock{
    //demo1===========等待2秒================
//    NSCondition *cLock = [NSCondition new];
//    //线程1
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"start");
//        [cLock lock];
//        [cLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
//        NSLog(@"线程1");
//        [cLock unlock];
//    });

    //demo2===========唤醒一个等待线程================
    NSCondition *cLock = [NSCondition new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程1加锁成功");
        [cLock wait];
        NSLog(@"线程1");
        [cLock unlock];
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lock];
        NSLog(@"线程2加锁成功");
        [cLock wait];
        NSLog(@"线程2");
        [cLock unlock];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        sleep(2);
//        NSLog(@"唤醒一个等待的线程");
//        [cLock signal];
        
        NSLog(@"唤醒所有等待的线程");
        [cLock broadcast];

    });
    
}

/*
 NSRecursiveLock 递归锁
 
 上面已经大概介绍过了：
 递归锁可以被同一线程多次请求，而不会引起死锁。这主要是用在循环或递归操作中。
 
 */

-(void)NSRecursiveLock_lock{
    
//    NSLock *rLock = [NSLock new]; 这段代码是一个典型的死锁情况。在我们的线程中，RecursiveMethod 是递归调用的。所以每次进入这个 block 时，都会去加一次锁，而从第二次开始，由于锁已经被使用了且没有解锁，所以它需要等待锁被解除，这样就导致了死锁，线程被阻塞住了。
//    NSLock *rLock = [NSLock new];//用这个会造成死锁
    
    NSRecursiveLock *rLock = [NSRecursiveLock new]; //这个锁不会

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [rLock lock];
            if (value > 0) {
                NSLog(@"线程%d", value);
                RecursiveBlock(value - 1);
            }
            [rLock unlock];
        };
        RecursiveBlock(4);
    });
}

/*
 NSConditionLock 条件锁
 
 
 我们在初始化 NSConditionLock 对象时，给了他的标示为 0
 执行 tryLockWhenCondition:时，我们传入的条件标示也是 0,所 以线程1 加锁成功
 执行 unlockWithCondition:时，这时候会把condition由 0 修改为 1
 因为condition 修改为了 1， 会先走到 线程3，然后 线程3 又将 condition 修改为 3
 最后 走了 线程2 的流程
 从结果我们可以发现，NSConditionLock 还可以实现任务之间的依赖。
 */

-(void)NSConditionLock_lock{
    
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
            [cLock unlockWithCondition:1];
        }else{
            NSLog(@"失败");
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"线程2");
        [cLock unlockWithCondition:2];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程3");
        [cLock unlockWithCondition:3];
    });
}
@end
