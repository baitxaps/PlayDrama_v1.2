//
//  PVideoEffect.h
//  PlayDrama
//
//  Created by hairong.chen on 15/10/27.
//  Copyright © 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PVideoThemeData.h"


@interface PVideoEffect : NSObject

@property (assign, nonatomic) ThemesType themeCurrentType;

- (id)initWithDelegate:(id)delegate;
- (void)buildVideoBeautify:(NSString *)exportVideoFile
              inputVideoURL:(NSURL*)inputVideoURL
           fromSystemCamera:(BOOL)fromSystemCamera;
- (BOOL)buildVideoEffectsToMP4:(NSString *)exportVideoFile
                  inputVideoURL:(NSURL*)inputVideoURL;

- (void)clearAll;
- (void)pause;
- (void)resume;
@end
