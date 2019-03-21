//
//  JDDog.m
//  RuntimeEncode
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "JDDog.h"
#import <objc/runtime.h>
/*
 struct objc_ivar {
 char *ivar_name;
 char *ivar_type;
 int ivar_offset;
 #ifdef __LP64__
 int space;
 #endif
 }
 typedef struct objc_ivar *Ivar;
 */
@implementation JDDog
-(void)encodeWithCoder:(NSCoder *)encoder{
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([JDDog class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        NSLog(@"encodeWithCoder 成员变量名：%s 成员变量类型：%s",name,type);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
 
         NSLog(@"encodeWithCoder===key===%@,value=====%@",key,value);
        [encoder encodeObject:value forKey:key];
        
    }
    free(ivars);
}

//https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
-(id)initWithCoder:(NSCoder *)decoder{
    
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([JDDog class], &count);
        for (int i = 0; i<count; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            const char *type = ivar_getTypeEncoding(ivar);
            NSLog(@"initWithCoder 成员变量名：%s 成员变量类型：%s",name,type);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [decoder decodeObjectForKey:key];
            if(!value) {
                continue;
            }
            [self setValue:value forKey:key];
        }
        free(ivars);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    id copy = [[[self class] allocWithZone:zone] init];
    unsigned int iVarCount = 0;
    unsigned int propVarCount = 0;
    Ivar *ivarList = class_copyIvarList([self class], &iVarCount);/*变量列表，含属性以及私有变量*/
    objc_property_t *propList = class_copyPropertyList([self class], &propVarCount);/*属性列表*/
  
    for (int i = 0; i < iVarCount; i++) {
        const char *varName = ivar_getName(*(ivarList + i));
        NSString *key = [NSString stringWithUTF8String:varName];
        /*valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)*/
        id varValue = [self valueForKey:key];
        NSArray *filters = @[@"superclass", @"description", @"debugDescription", @"hash"];
        if (varValue && [filters containsObject:key] == NO) {
            [copy setValue:varValue forKey:key];
        }
    }
    free(ivarList);
    return copy;
}
@end
