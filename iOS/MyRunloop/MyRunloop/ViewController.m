//
//  ViewController.m
//  MyRunloop
//
//  Created by wenyongjun on 2019/3/20.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//https://www.jianshu.com/p/07313bc6fd24

#import "ViewController.h"
#import "FirstSample.h"
#import "SecondSample.h"
#import "TestWorkClass.h"




@interface ViewController ()<NSPortDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    1
//    FirstSample *firstSample = [[FirstSample alloc]init];
    
    
//    SecondSample *ssSample = [[SecondSample alloc]init];
        [[NSThread currentThread] setName:@"VC--Thread"];
    [self launchThreadForPort];
    
    
    UIButton *testButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"test-==" forState:UIControlStateNormal];
    testButton.frame = CGRectMake(20, 60, 80, 40);
    [testButton addTarget:self action:@selector(testAction) forControlEvents:UIControlEventTouchUpInside];
    testButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:testButton];

}

-(void)testAction{
    NSLog(@"testActiontestActiontestActiontestAction");
}

//测试线程间通信
- (void)launchThreadForPort
{
    NSPort* myPort = [NSMachPort port];
    if (myPort)
    {
        //这个类持有即将到来的端口消息
        [myPort setDelegate:self];
        //将端口作为输入源安装到当前的 runLoop
        [[NSThread currentThread] setName:@"launchThreadForPort---Thread"];
        [[NSRunLoop currentRunLoop] addPort:myPort forMode:NSDefaultRunLoopMode];
        //当前线程去调起工作线程
        TestWorkClass *work = [[TestWorkClass alloc] init];
        [NSThread detachNewThreadSelector:@selector(launchThreadWithPort:) toTarget:work withObject:myPort];
    }
}

//NSPortDelegate
#define kCheckinMessage 100
//处理从工作线程返回的响应
- (void) handlePortMessage: (id)portMessage {
    //消息的 id
    unsigned int messageId = (int)[[portMessage valueForKeyPath:@"msgid"] unsignedIntegerValue];
    
    if (messageId == kCheckinMessage) {
        
        //1. 当前主线程的port
        NSPort *localPort = [portMessage valueForKeyPath:@"localPort"];
        //2. 接收到消息的port（来自其他线程）
        NSPort *remotePort = [portMessage valueForKeyPath:@"remotePort"];
        //3. 获取工作线程关联的端口，并设置给远程端口，结果同2
        NSPort *distantPort = [portMessage valueForKeyPath:@"sendPort"];
        
        NSMutableArray *arr = [[portMessage valueForKeyPath:@"components"] mutableCopy];
        if ([arr objectAtIndex:0]) {
            NSData *data = [arr objectAtIndex:0];
            NSString * str  =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"handlePortMessage====%@",str);
            
        }
        NSLog(@"");
        
        NSString *str1 = @"hahafhah";
        NSString *str2 = @"bbdfafjjjjb222";
        arr = [[NSMutableArray alloc] initWithArray:@[[str1 dataUsingEncoding:NSUTF8StringEncoding],[str2 dataUsingEncoding:NSUTF8StringEncoding]]];
        //发送消息到其他线程，操作1
        [remotePort sendBeforeDate:[NSDate date]
                             msgid:200
                        components:arr
                              from:localPort
                          reserved:0];
        
        //为了以后的使用保存工作端口
        //        [self storeDistantPort: distantPort];
    } else {
        //处理其他的消息
    }
}

@end
