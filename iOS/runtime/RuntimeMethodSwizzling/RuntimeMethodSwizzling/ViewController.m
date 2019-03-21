//
//  ViewController.m
//  RuntimeMethodSwizzling
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
    [array addObject:@1];
    [array addObject:@2];
    [array addObject:@3];
    [array addObject:@4];
    NSLog(@"array======%@",array);
    //
    
    id obj = [array objectAtIndex:6];
//    [array addObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
