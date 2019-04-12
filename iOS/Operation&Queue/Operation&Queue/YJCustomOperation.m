//
//  YJCustomOperation.m
//  Operation&Queue
//
//  Created by wenyongjun on 2019/4/12.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//

#import "YJCustomOperation.h"

@implementation YJCustomOperation

- (void)main {
    if (!self.isCancelled) {
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"YJCustomOperation==1---%@", [NSThread currentThread]);
        }
    }
}

@end
