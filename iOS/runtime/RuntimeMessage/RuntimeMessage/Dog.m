//
//  Dog.m
//  RuntimeMessage
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "Dog.h"
#import "RuntimeHelper.h"
#import <objc/runtime.h>

@interface Dog () {
    RuntimeHelper *_runtimeHelper;
}

@end
@implementation Dog

- (id)init{
    self = [super init];
    if (self) {
      _runtimeHelper = [[RuntimeHelper alloc]init];
    }
    return self;
}

#pragma mark - runtime

//1、动态方法解析
//+ (BOOL)resolveInstanceMethod:(SEL)sel{
//
//    if (sel == @selector(eat)) {
//        class_addMethod([self class], @selector(eat), (IMP)runtimeEatMethod, "");
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

////2、备用接收者
//如果目标对象实现了-forwardingTargetForSelector:，Runtime 这时就会调用这个方法，给你把这个消息转发给其他对象的机会。
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//
//    NSLog(@"forwardingTargetForSelector");
//
//    NSString *selectorString = NSStringFromSelector(aSelector);
//
//    // 将消息转发给_helper来处理
//    if ([selectorString isEqualToString:@"eat"]) {
//        return _runtimeHelper;
//    }
//
//    return [super forwardingTargetForSelector:aSelector];
//}
//
////3、完整消息转发
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
//    https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
    if (!signature) {
        if ([RuntimeHelper instancesRespondToSelector:aSelector]) {
            signature = [RuntimeHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([RuntimeHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_runtimeHelper];
    }
}
//
//-(void)doesNotRecognizeSelector:(SEL)aSelector {
//
//}
#pragma mark - add method

void runtimeEatMethod(id obj, SEL _cmd){
    NSLog(@"消息接受类 ====%@",obj);
    NSLog(@"The SEL is ========%@",NSStringFromSelector(_cmd));
    NSLog(@"添加方法");
}
@end
