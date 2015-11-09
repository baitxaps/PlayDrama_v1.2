//
//  PFiltersView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/10/27.
//  Copyright © 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PVideoThemeEntity.h"

typedef void (^VideoDataBlock) (PVideoThemeEntity *videoTheme);

@interface PFiltersView : UIView

@property(nonatomic,copy)VideoDataBlock videoDataBlock;

+ (PFiltersView *)initWithNib;
- (void)setScrollViewfilter:(NSArray *)data;

@end
