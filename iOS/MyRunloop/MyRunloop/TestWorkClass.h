//
//  TestWorkClass.h
//  MyRunloop
//
//  Created by wenyongjun on 2019/3/20.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestWorkClass : NSObject
- (void)launchThreadWithPort:(NSPort *)port;

@end

NS_ASSUME_NONNULL_END
