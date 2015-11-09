//
//  PWBMessage.m
//  PlayDrama
//
//  Created by hairong.chen on 15/10/28.
//  Copyright © 2015年 times. All rights reserved.
//

#import "PWBMessage.h"

@implementation PWBMessage
@synthesize message = _message;
@synthesize fromMe = _fromMe;

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;
{
    self = [super init];
    if (self) {
        _fromMe = fromMe;
        _message = message;
    }
    
    return self;
}
@end
