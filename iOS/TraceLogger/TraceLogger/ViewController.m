//
//  ViewController.m
//  TraceLogger
//
//  Created by wenyongjun on 2019/3/26.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//

//这是一个强大且轻量的线程调用栈分析器，只有一个类，四百行代码。它支持现有所有模拟器、真机的 CPU 架构，可以获取任意线程的调用栈，因此可以在检测到 runloop 检测到卡顿时获取卡顿处的代码执行情况。

#import "ViewController.h"
#import "BSBacktraceLogger.h"


@interface ViewController ()

@end

@implementation ViewController
- (void)foo {
    [self bar];
}

- (void)bar {
    while (true) {
        ;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BSLOG_MAIN  // 打印主线程调用栈， BSLOG 打印当前线程，BSLOG_ALL 打印所有线程
        // 调用 [BSBacktraceLogger bs_backtraceOfCurrentThread] 这一系列的方法可以获取字符串，然后选择上传服务器或者其他处理。
    });
    [self foo];
    
}


@end
