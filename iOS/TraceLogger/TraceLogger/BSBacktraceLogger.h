//
//  BSBacktraceLogger.h
//  BSBacktraceLogger
//
//  Created by 张星宇 on 16/8/27.
//  Copyright © 2016年 bestswifter. All rights reserved.
// 来自：https://github.com/bestswifter/BSBacktraceLogger

/*
 符号化就是给一个内存地址 0x00001234 找到其符号 -[ViewController viewDidLoad] 的过程，因为mach-o文件中包含了LC_SYMTAB段，该段中包含符号表。
 注意，iOS系统做了优化，系统库的符号不在内存中，会提示 <redacted>
 */

#import <Foundation/Foundation.h>

#define BSLOG NSLog(@"%@",[BSBacktraceLogger bs_backtraceOfCurrentThread]);
#define BSLOG_MAIN NSLog(@"%@",[BSBacktraceLogger bs_backtraceOfMainThread]);
#define BSLOG_ALL NSLog(@"%@",[BSBacktraceLogger bs_backtraceOfAllThread]);

@interface BSBacktraceLogger : NSObject

+ (NSString *)bs_backtraceOfAllThread;
+ (NSString *)bs_backtraceOfCurrentThread;
+ (NSString *)bs_backtraceOfMainThread;
+ (NSString *)bs_backtraceOfNSThread:(NSThread *)thread;

@end
