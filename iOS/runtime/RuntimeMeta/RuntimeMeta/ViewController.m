//
//  ViewController.m
//  RuntimeMeta
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)easyMeta {
    NSLog(@"==========easyMeta============");
    Class class = [self class];//类对象
    Class metaClass = object_getClass(class);//类元对象
    Class metaOfMetaClass = object_getClass(metaClass);//NSObject类元对象
    Class rootMataClass = object_getClass(metaOfMetaClass);//NSObject类元对象的类元对象
    NSLog(@"当前类类对象是:%p",class);
    NSLog(@"当前类类元对象是:%p",metaClass);
    NSLog(@"当前类类元对象 类元对象:%p",metaOfMetaClass); //注：已到NSObject元对象层级 再找一次还是自身
    NSLog(@"当前类类元对象 的 类元对象 的 类元对象的是:%p",rootMataClass);
    NSLog(@"NSObject类元对象:%p",object_getClass([NSObject class]));
    NSLog(@"NSObject类元对象 的 类元对象:%p",object_getClass(object_getClass([NSObject class])));
}

-(void)allMeta {
     NSLog(@"==========allMeta============");
    Class currentClass = [self class];
    Class superClass = [self class];
    Class metaClass = [self class];
    
    NSLog(@"self 地址 %p==",self);
    NSLog(@"currentClass 类对象地址 %p",currentClass);
    for (int i = 0; i < 5; i++) {
        NSLog(@"==============%d===========",i);
        //1.沿着isa指针找下去
        currentClass = object_getClass(currentClass);
        NSLog(@"currentClass====isa=%@======object_getClass====%p",currentClass,currentClass);
        
        //2.获取元类
        metaClass = objc_getMetaClass(class_getName(superClass));
        NSLog(@"superClass==%@==objc_getMetaClass====%p",superClass,metaClass);
        //3.获取父类
        superClass = class_getSuperclass(superClass);
        NSLog(@"superClass===%@=====class_getSuperclass====%p",superClass,superClass);
    }
    NSLog(@"NSObject's 类是  %p",[NSObject class]);
    NSLog(@"NSObject's 元类 is %p",object_getClass([NSObject class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //1 meta
    
    [self  easyMeta];
    
    //2 meta
//    [self allMeta];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
