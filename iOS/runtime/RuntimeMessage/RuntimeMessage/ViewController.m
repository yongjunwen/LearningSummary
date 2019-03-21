//
//  ViewController.m
//  RuntimeMessage
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "ViewController.h"
#import "Dog.h"
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Dog *dog = [[Dog alloc]init];
    
    //1.objc_msgSend
    [self testSendMsg:@"dogo========="];
    ((void ( *)(id, SEL,id))objc_msgSend)(self, @selector(testSendMsg:),@"ceshi");
    
    //2.消息转发
    [dog performSelector:@selector(eat)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)testSendMsg:(NSString *)msg {
    NSLog(@"testSendMsg====objc_msgSend===%@",msg);
}

@end
