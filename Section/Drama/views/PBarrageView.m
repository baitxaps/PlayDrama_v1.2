//
//  PBarrageView.m
//  PlayDrama
//
//  Created by hairong.chen on 15/10/28.
//  Copyright © 2015年 times. All rights reserved.
//

#import "PBarrageView.h"
#import "PWBMessage.h"

@interface PBarrageView()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *attributedCommentArray;

@end

@implementation PBarrageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.attributedCommentArray = [NSMutableArray new];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.attributedCommentArray = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.attributedCommentArray = [NSMutableArray new];
    }
    return self;
}

-(void)openBarrage
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    /*
     用户传进来的是一个普通的commentArray,我们需要做一下转换，把所有的NSString 转换成NSMutableAttributedString，
     然后添加到一个数组当中。新建一个数组
     接下来转换：
     */
    
    for(PWBMessage *entity in self.barrageData){
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:entity.message];
        
        UIColor *color = entity.fromMe ?[UIColor greenColor]:[UIColor whiteColor];
        [attributedStr addAttributes:@{NSForegroundColorAttributeName: color ,NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:23.0f]} range:NSMakeRange(0, entity.message.length)];
        [self.attributedCommentArray addObject:attributedStr];
        
    }
    [self.barrageData removeAllObjects];
    [self initLayer];
}

-(void)addMyComment:(NSString *)comment
{
    NSMutableAttributedString *attrComment = [[NSMutableAttributedString alloc] initWithString:comment];
    [attrComment addAttributes:@{NSForegroundColorAttributeName: [UIColor greenColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:23.0f]} range:NSMakeRange(0, comment.length)];
    [self.attributedCommentArray addObject:attrComment];
}

-(void)closeBarrage
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        [self.attributedCommentArray removeAllObjects];
        [self.barrageData removeAllObjects];
    }
    for(UIView *view in self.subviews){
        [view removeFromSuperview];
    }
}

/*
 我们把字体颜色设置成白色，字号大小设置为15。加一个定时器，每0.3秒生成一个UILabel，从右面往左移动
 接下来就是创建UILabel了，每个label应该能自适应宽度，也就是每个label的宽度应该根据评论内容的宽度动态改变。
 先给label.attributedText赋值。然后，根据attributes计算出评论内容的CGSize, 以这个size重新给label的frame 赋值
 */
-(void)initLayer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(createLabel) userInfo:nil repeats:YES];
}

/*
 需要注意的是：每个label的初始位置x是固定的，但是y的位置是要随机生成的，
 我们让每个label占用20的高度，然后用整个BarrageView的高度/20 就是每个view在y轴上容纳的 label个数：count，
 然后随机出 一个整数，范围在 0~ count-1。然后用count * 20 就是lable的随机y轴位置了。
 
 最后给label添加动画，从右往左移动：
 */
-(void)createLabel
{
    if (self.attributedCommentArray.count ==0) {
        return;
    }
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    
    NSMutableAttributedString *textObject = [self.attributedCommentArray lastObject];
    label.attributedText = textObject;
    [self.attributedCommentArray removeLastObject];
    //[self.attributedCommentArray insertObject:textObject atIndex:0];
    
    [self addSubview:label];
    
    CGSize size = [label.attributedText.string sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:23.0f]}];
    
    CGFloat windowHeight = self.frame.size.height;
    CGFloat windowWidth = self.frame.size.width;
    
    CGFloat yPosition = arc4random()%(((int)windowHeight)/20) * 20.0;
    
    
    CGRect frame = CGRectMake(windowWidth, yPosition, size.width, size.height);
    label.frame = frame;
    
    [self animationWithView:label];
    
}

/*
 没个label动画结束后，要销毁，不然会引起内存泄露，最后。labe调用上述方法，完成动画.
 */

-(void)animationWithView:(UIView *)view
{
    int random = arc4random()%6;
    CGFloat duration = random + 3.0;
    CGPoint endPoint = CGPointMake(0 - view.frame.size.width, view.frame.origin.y);
    CGRect endRect = CGRectMake(endPoint.x, endPoint.y, view.frame.size.width, view.frame.size.height);
    
    [UIView animateWithDuration:duration animations:^{
        
        //[self translationToLeftWithView:view];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [view setFrame:endRect];
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
    
}


-(void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}
@end