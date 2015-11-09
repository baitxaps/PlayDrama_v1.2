//
//  PVideoThemeEntity.m
//  PlayDrama
//
//  Created by hairong.chen on 15/10/27.
//  Copyright © 2015年 times. All rights reserved.
//

#import "PVideoThemeEntity.h"

@implementation PVideoThemeEntity

- (id)init
{
    if (self = [super init]){
        _ID                 = -1;
        _thumbImageName     = nil;
        _name               = nil;
        _textStar           = nil;
        _textSparkle        = nil;
        _textGradient       = nil;
        _scrollText         = nil;
        _bgMusicFile        = nil;
        _imageFile          = nil;
        _animationImages    = nil;
        _keyFrameTimes      = nil;
        _filter             = nil;
        _animationActions   = nil;
    }
    return self;
}
@end
