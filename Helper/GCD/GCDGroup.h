//
//  GCDGroup.h
//  GCD
//  Created by hairong.chen on 15/7/21.
//  Copyright (c) 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDGroup : NSObject

@property (strong, nonatomic, readonly) dispatch_group_t dispatchGroup;

#pragma 初始化以及释放
- (instancetype)init;

#pragma 用法
- (void)enter;
- (void)leave;
- (void)wait;
- (BOOL)wait:(int64_t)delta;

@end