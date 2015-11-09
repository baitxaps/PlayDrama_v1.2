//
//  PFiltersView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/10/27.
//  Copyright © 2015年 times. All rights reserved.
//

#define kFilterHeight       50
#define kScrollViewHeight   130-50
#define kFilterWidth        kFilterHeight
#define kFilterSpace        60

#import "PVideoThemeEntity.h"
#import "PFiltersView.h"

@interface PFiltersView ()<UIScrollViewDelegate>

@property (weak,  nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) NSArray               *datas;

@end

@implementation PFiltersView

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

+ (PFiltersView *)initWithNib
{
    PFiltersView *filterView = [[NSBundle mainBundle]loadNibNamed:@"PFiltersView"
                                                            owner:self
                                                          options:nil][0];
    
    return filterView;
}

- (void)setScrollViewfilter:(NSArray *)data;
{
    self.datas      = data;
    NSInteger count = data.count;
    [_scrollView setContentSize:CGSizeMake(count * kFilterWidth + 10 * count, kScrollViewHeight)];
    
    for (NSInteger i = 0; i < count;  i++) {
        PVideoThemeEntity *entity = data[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn addTarget:self action:@selector(eventHandle:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake(kFilterSpace *i +10, 5, kFilterWidth, kFilterHeight)];
        [btn drawBounderWidth:1 Color:[UIColor blackColor]];
        [_scrollView addSubview:btn];
        btn.tag      = i;
        PDebugLog(@"%@",NSStringFromCGRect(btn.frame));
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(kFilterSpace *i +10, kFilterHeight+8, kFilterWidth, 20)];
        if ([data[i] isKindOfClass:[NSNull class]]) {
            lbl.text            = @"还原";
        }else{
            lbl.text            = entity.name;
        }
        
        lbl.textAlignment  = NSTextAlignmentCenter;
        [lbl drawBounderWidth:1 Color:[UIColor blackColor]];
        [_scrollView addSubview:lbl];
    }
}

- (void)eventHandle:(UIButton *)sender
{
    if (self.videoDataBlock) {
        self.videoDataBlock(self.datas[sender.tag]);
    }
}

#pragma mark - UISCrollViewDelegate



@end
