//
//  JDModel.m
//  RuntimeAutoConvertModel
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "JDModel.h"
#import <objc/runtime.h>

@implementation JDModel
+ (instancetype)modelWithDictionary:(NSDictionary *)dic {

    JDModel *model = [[self alloc] init];
    unsigned int count = 0;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t aProperty = propertyList[i];
        //1.获取属性名
        const char *name = property_getName(aProperty);

        //2.获取字典里德数据
        id value = dic[[NSString stringWithUTF8String:name]];
        if (!value) {

        } else {
            //3.赋值
            [model setValue:value forKey:[NSString stringWithUTF8String:name]];
        }
    }
    return model;
}
@end
