//
//  FirstSample.m
//  MyRunloop
//
//  Created by wenyongjun on 2019/3/20.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//主要测试 runloop的用法

#import "FirstSample.h"

@implementation FirstSample
-(id)init{
   self = [super init];
    
    [self startNewThread];
    return  self;
}


/**
 *
 *  在辅助线程使用timer
 *
 */
-(void)startNewThread{
    NSLog(@"The new thread will start...");
    [NSThread detachNewThreadSelector:@selector(newThreadAction) toTarget:self withObject:nil];
}
-(void)newThreadAction{
//    创建当前子线程的runloop
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    
    // 创建Run loop observer对象
    // 第一个参数用于分配该observer对象的内存
    // 第二个参数用以设置该observer所要关注的的事件，详见回调函数myRunLoopObserver中注释
    // 第三个参数用于标识该observer是在第一次进入run loop时执行还是每次进入run loop处理时均执行
    // 第四个参数用于设置该observer的优先级
    // 第五个参数用于设置该observer的回调函数
    // 第六个参数用于设置该observer的运行环境
    CFRunLoopObserverContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault,kCFRunLoopAllActivities, YES, 0, &myRunLoopObserver, &context);
    if (observer){
        CFRunLoopRef cfLoop = [runloop getCFRunLoop];
        CFRunLoopAddObserver(cfLoop, observer, kCFRunLoopDefaultMode);
    }
    //在当前线程中注册事件源
    [NSTimer scheduledTimerWithTimeInterval: 10 target: self selector:@selector(printMessage:) userInfo: nil
                                    repeats:YES];
    
    //    NSInteger loopCount = 2;
    //    do{
    [runloop run];
    //        loopCount--;
    //
    //    }while (loopCount);
}

static int a;
-(void)printMessage:(NSTimer *)timer{
    a++;
    NSLog(@"printMessage======%d",a);
}


/*
 注意查看runloop通知的状态   每一次都从睡眠中唤醒
*/
void myRunLoopObserver(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
//    NSLog(@"================开始通知=============");
    switch(activity)
    {
            // 即将进入Loop
        case kCFRunLoopEntry:
            NSLog(@"run loop entry");
            break;
        case kCFRunLoopBeforeTimers://即将处理 Timer
            NSLog(@"run loop before timers");
            break;
        case kCFRunLoopBeforeSources://即将处理 Source
            NSLog(@"run loop before sources");
            break;
        case kCFRunLoopBeforeWaiting://即将进入休眠
            NSLog(@"run loop before waiting");
            break;
        case kCFRunLoopAfterWaiting://刚从休眠中唤醒
            NSLog(@"run loop after waiting");
            break;
        case kCFRunLoopExit://即将退出Loop
            NSLog(@"run loop exit");
            break;
        default:
            break;
    }
    
//    NSLog(@"================结束通知=============");
}

@end
