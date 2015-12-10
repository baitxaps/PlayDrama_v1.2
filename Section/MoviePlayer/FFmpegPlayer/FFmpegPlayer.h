//
//  PMoviePlayerView.h
//  PlayDrama
//
//  Created by RHC on 15/5/26.
//  Copyright (c) 2015年 times. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PBarrageView.h"

typedef void (^LimitFullScreenBlock)(BOOL isFullScreen);
typedef void (^BarrageTextBlock)(NSString * string);
typedef void (^CancelKeyViewBlock)(BOOL removeNotice);
@interface FFmpegPlayer : UIView

@property (copy,nonatomic)LimitFullScreenBlock              limitFullScreenBlock;
@property (copy,nonatomic)BarrageTextBlock                  barrageTextBlock;
@property (copy,nonatomic)CancelKeyViewBlock                cancelKeyViewBlock;
@property (weak,nonatomic) IBOutlet UILabel                 *movieTextLabel;//影片名称
@property (weak,nonatomic) UIViewController                 *viewController;
@property (readonly) BOOL                                   playing;
@property (strong,nonatomic)IBOutlet PBarrageView           *barrageView;
@property (weak, nonatomic) IBOutlet UITextField            *barrawTextField;


+ (FFmpegPlayer *)initNib;
- (void)playWithContentPath: (NSString *) path parameters: (NSDictionary *) parameters;
- (void)hidetopContainerView:(BOOL)hide;
- (void)viewDidAppear;
- (void)viewWillDisappear;
- (void)selectorWithUrl:(NSString *)urlString;
@end
