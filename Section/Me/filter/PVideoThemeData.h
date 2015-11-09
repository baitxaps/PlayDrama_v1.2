//
//  PFilterThemeModel.h
//  PlayDrama
//
//  Created by hairong.chen on 15/10/27.
//  Copyright © 2015年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
// Effects
typedef NS_ENUM(NSInteger,AnimationActionType){
    kAnimationNone = 0,
    kAnimationFireworks,
    kAnimationSnow,
    kAnimationSnow2,
    kAnimationHeart,
    kAnimationRing,
    kAnimationStar,
    kAnimationMoveDot,
    kAnimationSky,
    kAnimationMeteor,
    kAnimationRain,
    kAnimationFlower,
    kAnimationFire,
    kAnimationSmoke,
    kAnimationSpark,
    kAnimationSteam,
    kAnimationBirthday,
    kAnimationBlackWhiteDot,
    kAnimationScrollScreen,
    kAnimationSpotlight,
    kAnimationScrollLine,
    kAnimationRipple,
    kAnimationImage,
    kAnimationImageArray,
    kAnimationVideoFrame,
    kAnimationTextStar,
    kAnimationTextSparkle,
    kAnimationTextScroll,
    kAnimationTextGradient,
    kAnimationFlashScreen
};

// Themes
typedef NS_ENUM(NSInteger ,ThemesType){
    // 无
    kThemeNone = 0,
    
    // 心情
    kThemeMood,
    
    // 怀旧
    kThemeNostalgia,
    
    // 老电影
    KThemeOldFilm,
    
    // Nice day
    kThemeNiceDay,
    
    // 星空
    kThemeSky,
    
    // 时尚
    kThemeFashion,
    
    // 生日
    kThemeBirthday,
    
    // 心动
    kThemeHeartbeat,
    
    // 浪漫
    kThemeRomantic,
    
    // 星光
    kThemeStarshine,
    
    // 雨天
    kThemeRain,
    
    // 花语
    kThemeFlower,
    
    // 经典
    kThemeClassic,
};


@interface PVideoThemeData : NSObject

+ (PVideoThemeData *) sharedInstance;
- (NSMutableDictionary*) getThemeData;
- (NSMutableDictionary*) getThemeFilter:(BOOL)fromSystemCamera;


@end
