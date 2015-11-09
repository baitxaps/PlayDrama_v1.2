//
//  PBarrageView.h
//  PlayDrama
//
//  Created by hairong.chen on 15/10/28.
//  Copyright © 2015年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 我们把他封装成一个UIView的子类,起名为BarrageView , 然后添加一个评论数组的属性：CommentArray 。
 还需要暴露出两个方法，打开弹幕：openBarrage，添加自己的评论：addMyComment:。
 大家去弹幕网站就应该会注意到，别人的评论一般是白色的，而当我们输入自己评论，然后显示的时候，
 网站会把我们的评论设置成彩色的以便与别人区分。所以，加一个输入自己评论的方法，
 我们会把评论内容生成NSMutableAttributedString。这种字符串可以存储字体颜色、大小等属性，方便我们统一修改和操作
 */
@interface PBarrageView : UIView

@property (nonatomic, strong) NSMutableArray *barrageData;
//开启弹幕
-(void)openBarrage;
-(void)closeBarrage;

//自己评论内容，颜色彩色
-(void)addMyComment:(NSString *)comment;


@end
