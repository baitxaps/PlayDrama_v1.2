//
//  CapturePlayViewController.m
//  PlayDrama
//  http://jiapumin.iteye.com/blog/2109378
//  Created by hairong.chen on 15/8/6.
//  Copyright (c) 2015年 times. All rights reserved.
//
static NSString *const URL      = @"http://up.qiniu.com";
static NSString *const g_token  = @"v2CXWOeGzjrqS9K1MN1lNSluZJO3sJkP_g5bc_wB:1D833J_kbEv7PiMy0Ho5Nr43K9s=:eyJzY29wZSI6InRlc3QiLCJkZWFkbGluZSI6MTQ0MTEwNzU0MX0=";

#define kTextViewTag          0x11010
#define kPlayerLayerHeight    UIScreenHeight - 250
#define kFilterY              (kPlayerLayerHeight +44 +20)


#import "CapturePlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSString+Category.h"
#import "PVideoThemeData.h"
#import "PVideoThemeEntity.h"
#import "PVideoEffect.h"
#import "PFiltersView.h"
#import "UIView+Draw.h"
#import "PBJVideoPlayerController.h"

//#import "CatchImage.h"

@interface CapturePlayViewController ()<UITextViewDelegate,PBJVideoPlayerControllerDelegate>
{
     PFiltersView                                   *_filterView;
    UIImageView                                     *_playButton;
}
@property (strong, nonatomic) UIButton              *backButton;
@property (strong, nonatomic) UIButton              *submitButton;
@property (strong, nonatomic) NSURL                 *videoFileURL;
@property (strong, nonatomic) AVPlayer              *player;
@property (strong, nonatomic) AVPlayerLayer         *playerLayer;
//@property (strong, nonatomic) UIButton              *playButton;

@property (strong, nonatomic) AVPlayerItem          *playerItem;
@property (weak  , nonatomic) IBOutlet UITextView   *destTextView;

@property (copy,   nonatomic) NSURL                 *videoPickURL;
@property (copy,   nonatomic) NSString              *mp4OutputPath;
@property (retain, nonatomic) PVideoEffect          *videoEffects;
@property (assign, nonatomic) BOOL                  hasVideo;
@property (assign, nonatomic) BOOL                  hasMp4;
@property (assign, nonatomic) BOOL                  fromSystemCamera;
@property (strong, nonatomic) PBJVideoPlayerController*videoPlayerController;
@property (retain, nonatomic) UIImageView           *imageViewPreview;
@end

@implementation CapturePlayViewController


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
     withVideoFileURL:(NSURL *)videoFileURL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.videoFileURL           = videoFileURL;
    }
    return self;
}

- (void)dealloc
{
    PDebugLog(@"%s",__FUNCTION__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavbar];
    [self setupViews];
    [self videoData];
    
    [self startPlayerMovie];
}

- (void)videoData
{
    self.mp4OutputPath          = [self getOutputFilePath];//输出视频路径
    self.videoPickURL           = self.filePath;
    self.hasVideo               = YES;
    [self getPreviewImage:self.videoFileURL];//截图
}

#pragma mark - private maths
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (NSString*)getOutputFilePath
{
    NSString *path          = @"outputMovie.mp4";
    NSString* mp4OutputFile = [NSTemporaryDirectory() stringByAppendingPathComponent:path];
    
    return mp4OutputFile;
}

#pragma mark - viewControl lifeCycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    
#pragma mark - m
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AVPlayerItemDidPlayToEndTimeNotification
//                                                  object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(avPlayerItemDidPlayToEnd:)
//                                                 name:AVPlayerItemDidPlayToEndTimeNotification
//                                               object:nil];
//   [self.destTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:AVPlayerItemDidPlayToEndTimeNotification
//                                                  object:nil];
}

#pragma mark - UI
- (void)addNavbar
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [_backButton setImage:[UIImage imageNamed:@"vedio_nav_btn_back_nor.png"] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"vedio_nav_btn_back_pre.png"] forState:UIControlStateHighlighted];
    [_backButton addTarget:self action:@selector(backActionButton)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.submitButton = [[UIButton alloc] initWithFrame:CGRectMake(UIScreenWidth - 60, 0, 60, 44)];
    [self.submitButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.submitButton addTarget:self action:@selector(submitAction:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.submitButton];
}

- (void)initPlayLayer
{
    _imageViewPreview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, UIScreenWidth,kPlayerLayerHeight) ];
    _imageViewPreview.clipsToBounds = TRUE;
    [self.view addSubview:_imageViewPreview];
    
    _videoPlayerController              = [[PBJVideoPlayerController alloc] init];
    _videoPlayerController.delegate     = self;
    _videoPlayerController.view.frame   = _imageViewPreview.frame;
    
    [self addChildViewController:_videoPlayerController];
    [self.view addSubview:_videoPlayerController.view];
//    if (!_videoFileURL) {
//        return;
//    }
//    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:_videoFileURL options:nil];
//    self.playerItem     = [AVPlayerItem playerItemWithAsset:movieAsset];
//    self.player         = [AVPlayer playerWithPlayerItem:_playerItem];
//    self.playerLayer    = [AVPlayerLayer playerLayerWithPlayer:_player];
//    // _playerLayer.frame = CGRectMake(UIScreenWidth - 100, 44, 100,100/*DEVICE_SIZE.width, DEVICE_SIZE.width*/);
//    _playerLayer.frame  = CGRectMake(0, 44, UIScreenWidth,kPlayerLayerHeight);
//    
//    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;//AVLayerVideoGravityResizeAspect;
//    [self.view.layer addSublayer:_playerLayer];
}

- (void)setupViews
{
    //1
    [self initPlayLayer];
    self.view.backgroundColor           = RGBAColor(16, 16, 16, 1.0f);
    
    _playButton         = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_icon"]];
    _playButton.center  = self.imageViewPreview.center;
    [_videoPlayerController.view addSubview:_playButton];
    
//    _playButton                         = [UIButton buttonWithType:UIButtonTypeCustom];
//     _playButton.center                 = self.view.center;
//    [_playButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
//    [_videoPlayerController.view addSubview:_playButton];
    
//    self.playButton             = [[UIButton alloc] initWithFrame:_playerLayer.frame];
//    [_playButton setImage:[UIImage imageNamed:@"video_icon.png"] forState:UIControlStateNormal];
//    [_playButton addTarget:self action:@selector(pressPlayButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_playButton];
    
    //imageView.image = [CatchImage thumbnailImageForVideo:self.videoFileURL atTime:second];
    //2.
//    UILabel *placeholder            = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 280.0, 30)];
//    placeholder.textColor           = RGBAColor(206, 206, 212, 1);
//    placeholder.tag                 = kTextViewTag;
//    placeholder.text                = NSLocalizedString(@"你想说点什么", nil);
//    placeholder.font                = [UIFont systemFontOfSize:14.0];
//    placeholder.textAlignment       = NSTextAlignmentLeft;
//    [self.destTextView addSubview:placeholder];
    
    //3.
    _filterView                     = [PFiltersView initWithNib];
    CGRect  filterFrame             = _filterView.frame;
    filterFrame.size.width          = UIScreenWidth;
    filterFrame.origin.y            = kFilterY;
    _filterView.frame               = filterFrame;

    NSMutableDictionary *themImagesArray = [[PVideoThemeData sharedInstance] getThemeData];
    NSMutableArray *filterDatas          = [NSMutableArray array];
    for (int i = kThemeNone; i < [themImagesArray count]; ++i){
        PVideoThemeEntity *material = [themImagesArray objectForKey:[NSNumber numberWithInt:i]];
        [filterDatas addObject:material];
    }
    [_filterView setScrollViewfilter:filterDatas];
    [self.view addSubview:_filterView];
    [self buildVideoEffiect];
}

- (void)startPlayerMovie
{
    [self showVideoPlayView:TRUE];
     self.videoPlayerController.videoPath = [NSString stringWithFormat:@"%@",self.videoPickURL];
    [self.videoPlayerController playFromBeginning];
}


-(void) getPreviewImage:(NSURL *)url
{
    AVURLAsset *asset           = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen  = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time                 = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error              = nil;
    CMTime actualTime;
    
    CGImageRef image            = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img                = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    _imageViewPreview.image     = img;
}

#pragma mark - 添加视频特效

- (void)buildVideoEffiect
{
    WS(weakSelf);
    _filterView.videoDataBlock = ^(PVideoThemeEntity *vidoeTheme){
        
        if (!weakSelf.hasVideo){
            NSLog(@"There haven't any video now.");
            return;
        }
        
        ThemesType curThemeType  = kThemeNone;
        if ((NSNull*)vidoeTheme != [NSNull null]){
            curThemeType = (ThemesType)vidoeTheme.ID;
        }
        
        if (curThemeType == kThemeNone){
            PDebugLog(@"curThemeType is empty.");
            [weakSelf startPlayerMovie];
            return;
        }
        // Pause play
        if (weakSelf.videoPlayerController.playbackState == PBJVideoPlayerPlaybackStatePlaying){
            [weakSelf.videoPlayerController pause];
        }
        // Build video effect
        [weakSelf buildVideoEffect:curThemeType];
    };
}

- (void) buildVideoEffect:(ThemesType)curThemeType
{
    if (_videoEffects){
        _videoEffects = nil;
    }
    self.videoEffects = [[PVideoEffect alloc] initWithDelegate:self];
    self.videoEffects.themeCurrentType  = curThemeType;
    [self.videoEffects buildVideoBeautify:self.mp4OutputPath
                            inputVideoURL:self.videoPickURL
                         fromSystemCamera:self.fromSystemCamera];
}

- (void) showVideoPlayView:(BOOL)show
{
    if (show){
        _playButton.hidden                  = NO;
        _videoPlayerController.view.hidden  = NO;
    }else{
        _playButton.hidden                  = YES;
        _videoPlayerController.view.hidden  = YES;
    }
}

- (void)pressPlayButton:(UIButton *)button
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    _playButton.alpha = 0.0f;
}

#pragma mark - 返回
- (void)backActionButton
{
    if (self.backBlock) {
        self.backBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    UILabel *placeholderL   = (UILabel *)[textView viewWithTag:kTextViewTag];
    placeholderL.hidden     = [textView.text length]>0;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [UIView animateWithDuration:0.3f animations:^{
        _playButton.alpha = 1.0f;
    }];
}


#pragma mark -
#pragma mark - Video effects status
- (void)AVAssetExportMP4SessionStatusFailed:(id)object
{
    NSString *failed = NSLocalizedString(@"failed", nil);
    [_hud hide:YES];
    
    // Dispose memory
    [self.videoEffects clearAll];
    
    NSString *ok        = NSLocalizedString(@"ok", nil);
    NSString *msgFailed = NSLocalizedString(@"msgConvertFailed", nil);
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:failed message:msgFailed
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:ok, nil];
    [alert show];
    
    PDebugLog(@"videoPickURL is:%@", self.videoPickURL);
}

- (void)AVAssetExportMP4SessionStatusCompleted:(id)object
{
    [self.videoEffects clearAll];
    self.hasMp4         = YES;
   // NSString *success   = NSLocalizedString(@"success", nil);
   
    [_hud hide:YES];
    [self playMp4Video];
}

- (void) playMp4Video
{
    if (!_hasMp4){
        NSLog(@"Mp4 file not found!");
        return;
    }
    
    PDebugLog(@"%@",[NSString stringWithFormat:@"Play file is %@", _mp4OutputPath]);
    [self showVideoPlayView:TRUE];
    _videoPlayerController.videoPath      = _mp4OutputPath;
    [_videoPlayerController playFromBeginning];
}

- (void)AVAssetExportMP4ToAlbumStatusCompleted:(id)object
{
    NSString *success       = NSLocalizedString(@"success", nil);
    NSString *msgSuccess    =  NSLocalizedString(@"msgSuccess", nil);
    NSString *ok            = NSLocalizedString(@"ok", nil);
    UIAlertView *alert      = [[UIAlertView alloc] initWithTitle:success message:msgSuccess
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:ok, nil];
    [alert show];
    
}

- (void)AVAssetExportMP4ToAlbumStatusFailed:(id)object
{
    NSString *failed    = NSLocalizedString(@"failed", nil);
    NSString *msgFailed =  NSLocalizedString(@"msgFailed", nil);
    NSString *ok        = NSLocalizedString(@"ok", nil);
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle: failed message:msgFailed
                                                    delegate:nil
                                           cancelButtonTitle:nil
                                           otherButtonTitles:ok, nil];
    [alert show];
    
}

- (void)retrievingProgressFilter:(id)progress
{
    if (progress && [progress isKindOfClass:[NSNumber class]]){
        NSString *title = NSLocalizedString(@"filter", nil);
        [self updateProgressBarTitle:title status:[NSString stringWithFormat:@"%d%%", (int)([progress floatValue] * 100)]];
    }
}

- (void) updateProgressBarTitle:(NSString*)title status:(NSString*)status
{
    [self showHudWithTitle:@"正在处理中..."];
}

#pragma mark - videoEffiec 保存
- (void) writeExportedVideoToAssetsLibrary:(NSString *)outputURL
{
    __unsafe_unretained typeof(self) weakSelf = self;
    NSURL *exportURL            = [NSURL fileURLWithPath:outputURL];
    ALAssetsLibrary *library    = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:exportURL]){
        [library writeVideoAtPathToSavedPhotosAlbum:exportURL completionBlock:^(NSURL *assetURL, NSError *error){
            if (error){
                [weakSelf AVAssetExportMP4ToAlbumStatusFailed:error];
            }else {
                NSString *albumGroupName = @"VideoBeautify";
                [weakSelf addVideoToAssetGroupWithAssetUrl:assetURL
                                             assertLibrary:library
                                                   toAlbum:albumGroupName
                                           addSuccessBlock:^(ALAssetsGroup *targetGroup, NSURL *currentAssetUrl, ALAsset *currentAsset){
                                               [weakSelf AVAssetExportMP4ToAlbumStatusCompleted:error];
                                               
                                           } addFaieldBlock:^(NSError *error){
                                               
                                           }];
            }
        }];
    }
    else{
        PDebugLog(@"Video could not be exported to camera roll.");
    }
    library = nil;
}


- (void) addVideoToAssetGroupWithAssetUrl:(NSURL*)assetURL
                            assertLibrary:(ALAssetsLibrary*)assertLibrary
                                  toAlbum:(NSString*)name
                          addSuccessBlock:(void (^) (ALAssetsGroup *targetGroup, NSURL *currentAssetUrl, ALAsset *currentAsset))addSuccessBlock
                           addFaieldBlock:(void (^) (NSError *error))addFaieldBlock
{
    
    [self createAssetsAlbumGroupWithName:name
                           assertLibrary:assertLibrary
             enumerateGroupsFailureBlock:^(NSError *error){
                 if (error){
                     addFaieldBlock(error);
                     return ;
                 }
             } hasTheNewGroupBlock:^(ALAssetsGroup *group){
                 
                 [assertLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset){
                     [group addAsset:asset];
                     addSuccessBlock(group,assetURL,asset);
                     
                 } failureBlock:^(NSError *error){
                     if (error){
                         addFaieldBlock(error);
                         return ;
                     }
                 }];
             } createSuccessedBlock:^(ALAssetsGroup *group){
                 
                 [assertLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset){
                     [group addAsset:asset];
                     addSuccessBlock(group,assetURL,asset);
                     
                 } failureBlock:^(NSError *error){
                     if (error){
                         addFaieldBlock(error);
                         return ;
                     }
                 }];
             } createFaieldBlock:^(NSError *error){
                 if (error){
                     addFaieldBlock(error);
                     return ;
                 }
             }];
}

#pragma mark - private Method
- (void) createAssetsAlbumGroupWithName:(NSString*)name
                          assertLibrary:(ALAssetsLibrary*)assertLibrary
            enumerateGroupsFailureBlock:(void (^) (NSError *error))enumerateGroupsFailureBlock
                    hasTheNewGroupBlock:(void (^) (ALAssetsGroup *group))hasGroup
                   createSuccessedBlock:(void (^) (ALAssetsGroup *group))createSuccessedBlock
                      createFaieldBlock:(void (^) (NSError *error))createFaieldBlock
{
    __block BOOL hasTheNewGroup = NO;
    [assertLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        hasTheNewGroup = [name isEqualToString:[group valueForProperty:ALAssetsGroupPropertyName]];
        if (hasTheNewGroup){
            hasGroup(group);
            *stop = YES;
        }
        
        if (!group && !hasTheNewGroup && !*stop){
            [assertLibrary addAssetsGroupAlbumWithName:name resultBlock:^(ALAssetsGroup *agroup){
                createSuccessedBlock(agroup);
                
            } failureBlock:^(NSError *error){
                createFaieldBlock(error);
            }];
        }
    } failureBlock:^(NSError *error){
        enumerateGroupsFailureBlock(error);
    }];
}



#pragma mark -  上传视频
- (void)submitAction:(UIButton *)sender
{
    //保存
    if (_hasMp4)
    {
        [self writeExportedVideoToAssetsLibrary:_mp4OutputPath];
    }
 
    //上传
    /*
    if ([self valid]) {
        return;
    }
    //upload
    [self.view endEditing:YES];
    long long fileSize   = [self fileSizeAtPath:self.movieFilePath];
    NSDictionary *params = @{@"token":g_token,
                             @"file" :self.self.videoFileURL,
                             @"fileSize":@(fileSize)
                             };
    
    [self showHudWithTitle:@"正在上传中..."];
    NSData *videoData    = [NSData dataWithContentsOfFile:self.movieFilePath];
    
    [Networking UploadDataWithUrlString:URL
                             parameters:params
                        timeoutInterval:[NSNumber numberWithDouble:30.0f]
                            requestType:HTTPRequestType
                           responseType:JSONResponseType
              constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                  
                  [formData appendPartWithFileData:videoData
                                              name:@"file"
                                          fileName:@"video.mp4"
                                          mimeType:@"video/mp4"];
                  
              } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  PDebugLog(@"%@",responseObject);
                  [_hud hide:YES];
                  //[self backActionButton];
                  NSString *tips =  [NSString stringWithFormat:@"%@,%@",operation,responseObject];
                  
                  self.destTextView.text = tips;
                  
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  [self.view makeToast:error.localizedDescription duration:1.0 position:@"center" tag:10010];
                  [_hud hide:YES];
                  NSString *tips =  [NSString stringWithFormat:@"%@,errorcode = %ld,%@",operation,(long)error.code,error.description ];
                  self.destTextView.text = tips;
                  
              }];
     */
}

- (BOOL)valid
{
    NSString *destString = [self.destTextView.text stringByTrimmingWhitespace:self.destTextView.text];
    if ([destString length]==0) {
        [self.view makeToast:@"对小伙伴们说点什么吧！" duration:1.0 position:@"center" tag:10010];
        return YES;
    }
    return NO;
}


#pragma mark - PBJVideoPlayerControllerDelegate
- (void)videoPlayerPlaybackWillStartFromBeginning:(PBJVideoPlayerController *)videoPlayer
{
    _playButton.alpha       = 1.0f;
    _playButton.hidden      = NO;
    [UIView animateWithDuration:0.1f animations:^{
        _playButton.alpha   = 0.0f;
        
    } completion:^(BOOL finished){
        _playButton.hidden = YES;

    }];
}

- (void)videoPlayerPlaybackDidEnd:(PBJVideoPlayerController *)videoPlayer
{
    _playButton.hidden = NO;
    [UIView animateWithDuration:0.1f animations:^{
        _playButton.alpha = 1.0f;
    } completion:^(BOOL finished){

    }];
}

- (void)videoPlayerReady:(PBJVideoPlayerController *)videoPlayer{}
- (void)videoPlayerPlaybackStateDidChange:(PBJVideoPlayerController *)videoPlayer{}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end

