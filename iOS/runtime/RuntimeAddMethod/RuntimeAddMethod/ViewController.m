//
//  ViewController.m
//  RuntimeAddMethod
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1、添加方法
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self performSelector:@selector(dynamicSelector) withObject:nil];
#pragma clang diagnostic pop
    
    [self performSelector:@selector(dynamicSelector) withObject:nil];
    
    //2.添加属性   已经存在的类不能添加成员变量
    class_addIvar([self class], "_gayFriend", sizeof(id), log2(sizeof(id)), @encode(id));
   Ivar ivar= class_getInstanceVariable([self class], "_gayFriend");
    const char *name = ivar_getName(ivar);
    
    
    //3.
}

void myMehtod(id self,SEL _cmd){
    NSLog(@"------This is added dynamic");
}

//动态方法解析
/*
 首先，Objective-C运行时会调用 +resolveInstanceMethod:或者 +resolveClassMethod:，让你有机会提供一个函数实现。如果你添加了函数并返回YES， 那运行时系统就会重新启动一次消息发送的过程。
 */
+(BOOL)resolveInstanceMethod:(SEL)sel{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    if (sel == @selector(dynamicSelector)) {
#pragma clang diagnostic pop
        //class_addMethod(Class cls, SEL name, IMP imp,const char *types)
    //https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
        class_addMethod([self class],sel, (IMP)myMehtod,"v@:");
        return YES;
    }else{
        return [super resolveInstanceMethod:sel];
    }
}

@end
