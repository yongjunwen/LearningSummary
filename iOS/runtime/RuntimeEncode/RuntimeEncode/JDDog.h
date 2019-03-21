//
//  JDDog.h
//  RuntimeEncode
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDDog : NSObject<NSCopying, NSCoding>
{
    NSInteger _num;
    NSString *_father;
}
    
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* color;
@end
