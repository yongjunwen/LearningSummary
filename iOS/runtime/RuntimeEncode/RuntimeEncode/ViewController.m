//
//  ViewController.m
//  RuntimeEncode
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "ViewController.h"
#import "JDDog.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface ViewController ()
-(id)unarchiveModel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JDDog *dog = [[JDDog alloc] init];
//    JDDog *dog = ( ((id ( *)(id, SEL))objc_msgSend(objc_msgSend([JDDog class], @selector(alloc)), "init")));

//    ((void ( *)(id, SEL))objc_msgSend)(self, @selector(unarchiveModel));
    dog.name = @"xiaohuang";
    dog.color = @"yellow";
    
    
    NSLog(@"Before archiver:\n%@", [dog description]);
    
    //1、copy
//    JDDog *copydog = [dog copy];
//    NSLog(@" copydog:\n%@", [copydog description]);
//     NSLog(@"copydog====name=%@\ncolor=%@", copydog.name,copydog.color);
    
//    //2、archive
//    [self archiveModel:dog];
//    
//    //3、unarchive
//    [self unarchiveModel];
}

-(NSString *)filePath {
    
    NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [documents stringByAppendingPathComponent:@"model.archiver"];
    return path;
}

-(void)archiveModel:(id)model{
    
    
    [NSKeyedArchiver archiveRootObject:model toFile:[self filePath]];
    
}

//读取
-(id)unarchiveModel{
    id model = [NSKeyedUnarchiver unarchiveObjectWithFile:[self filePath]];
    NSLog(@"unarchiveModel====%@",model);
    return model;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
