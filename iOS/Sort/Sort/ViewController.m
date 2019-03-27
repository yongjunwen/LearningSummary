//
//  ViewController.m
//  Sort
//
//  Created by wenyongjun on 2019/3/27.
//  Copyright © 2019年 wenyongjun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:@100,@2,@6,@4,@8,@1,@5,@9, nil];
    
    [self insert_sort:tempArray];
}

/*
 *直接插入排序
 */

-(void)insert_sort:(NSMutableArray *)array {
    for (NSInteger i=1; i < array.count; i ++) {
        
        NSNumber *tempNum = array[i];
        NSInteger tempValue = tempNum.integerValue;
        
        NSInteger inserIndex = i;
        for (NSInteger j=i-1; j>=0; j--) {
            NSNumber *preNum = array[j];
            NSInteger preValue = preNum.integerValue;
            if (preValue > tempValue) {
                inserIndex = j;
            }
        }
        
        [array insertObject:tempNum atIndex:inserIndex];
        [array removeObjectAtIndex:i + 1];
    }
    
    NSLog(@"%@",array);
}
@end
