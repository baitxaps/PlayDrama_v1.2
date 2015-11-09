//
//  CapturePlayViewController.h
//  PlayDrama
//
//  Created by hairong.chen on 15/8/6.
//  Copyright (c) 2015年 times. All rights reserved.
//

typedef void (^DoneBlock)(void);

#import <UIKit/UIKit.h>

@interface CapturePlayViewController : PBasicViewController

@property (nonatomic,  copy)DoneBlock backBlock;        //block
@property (nonatomic,strong)NSURL    *filePath;         //play
@property (nonatomic,strong)NSString *movieFilePath;   //upload
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideoFileURL:(NSURL *)videoFileURL;

- (void)AVAssetExportMP4SessionStatusFailed:(id)object;
- (void)AVAssetExportMP4SessionStatusCompleted:(id)object;
- (void)AVAssetExportMP4ToAlbumStatusCompleted:(id)object;
- (void)AVAssetExportMP4ToAlbumStatusFailed:(id)object;
- (void) writeExportedVideoToAssetsLibrary:(NSString *)outputURL;
@end
