//
//  PVideoThemeEntity.h
//  PlayDrama
//
//  Created by hairong.chen on 15/10/27.
//  Copyright © 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PVideoThemeEntity : NSObject

@property (nonatomic, assign)int            ID;
@property (nonatomic, copy)NSString         *thumbImageName;
@property (nonatomic, copy)NSString         *name;
@property (nonatomic, copy)NSString         *textStar;
@property (nonatomic, copy)NSString         *textSparkle;
@property (nonatomic, copy)NSString         *textGradient;
@property (nonatomic, copy)NSString         *bgMusicFile;
@property (nonatomic, copy)NSString         *imageFile;
@property (nonatomic, retain)NSMutableArray *scrollText;
@property (nonatomic, retain)NSMutableArray *animationImages;
@property (nonatomic, retain)NSArray        *keyFrameTimes;
@property (nonatomic, retain)NSArray        *animationActions;
@property (nonatomic, retain)GPUImageOutput<GPUImageInput> *filter;

@end