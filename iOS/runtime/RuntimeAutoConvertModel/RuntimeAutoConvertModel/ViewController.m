//
//  ViewController.m
//  RuntimeAutoConvertModel
//
//  Created by wenyongjun on 16/9/8.
//  Copyright © 2016年 wenyongjun. All rights reserved.
//模拟json自动转换model情况

#import "ViewController.h"
#import "JDDog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    NSDictionary *dictionary = @{@"name":@"小黄",@"color":@"黄色"};

    JDDog *dog = [JDDog modelWithDictionary:dictionary];
    NSLog(@"dog.name = %@,dog.color = %@",dog.name,dog.color);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
