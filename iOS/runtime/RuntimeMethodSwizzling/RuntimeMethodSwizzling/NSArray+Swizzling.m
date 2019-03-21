//
//  NSArray+Swizzling.m
//  RuntimeMethodSwizzling
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "NSArray+Swizzling.h"
#import <objc/runtime.h>
@implementation NSArray (Swizzling)
/*
 ＋load //在一个类对象加载到Runtime的时候调用
 */
+(void)load{
    
    
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //1、获取两个类的方法
            //1、class_getClassMethod 2、class_getInstanceMethod
            Method m1 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(addObject:));
            Method m2 = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(jd_addObject:));
            //2、开始交换方法实现
            method_exchangeImplementations(m1, m2);
    //
            Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
            Method toMethod = class_getInstanceMethod([self class], @selector(jd_objectAtIndex:));
            method_exchangeImplementations(fromMethod, toMethod);
        });
}

-(void)jd_addObject:(id)object{
    //注意：系统也在调用
    NSLog(@"jd_addObject=%@",object);
    if (object) {
        [self jd_addObject:object];
    }
}

-(id)jd_objectAtIndex:(NSUInteger)index{
//    NSLog(@"index=%lu,self.count=%lu",(unsigned long)index,(unsigned long)self.count);
    if (index < self.count) {
        return  [self jd_objectAtIndex:index];
    }else {
        // 异常处理
        @try {
            return [self jd_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息，方便我们调试。
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    }
}
@end
