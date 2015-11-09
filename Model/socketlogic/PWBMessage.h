//
//  PWBMessage.h
//  PlayDrama
//
//  Created by hairong.chen on 15/10/28.
//  Copyright © 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWBMessage : NSObject
- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;

@property (nonatomic, retain, readonly) NSString *message;
@property (nonatomic, readonly)  BOOL fromMe;
@end
