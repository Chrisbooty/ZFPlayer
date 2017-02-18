//
//  MoviePlayerViewController.m
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Masonry.h"
#import "ZFPlayer.h"

@interface MoviePlayerViewController () <ZFPlayerDelegate>
/** 播放器View的父视图*/
@property (strong, nonatomic)  UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;
/**
 状态栏
 */
@property (nonatomic, assign) BOOL isLightContent;
@end

@implementation MoviePlayerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isLightContent = YES;
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)setIsLightContent:(BOOL)isLightContent
{
    _isLightContent = isLightContent;
    [self preferredStatusBarStyle];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (_isLightContent) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isLightContent = NO;
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    self.playerFatherView = [[UIView alloc] init];
    [self.view addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.leading.trailing.mas_equalTo(0);
        // 这里宽高比16：9,可自定义宽高比
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    */
    
    _playerFatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    [self.view addSubview:_playerFatherView];
    
    self.playerView = [[ZFPlayerView alloc] init];
    
    /*****************************************************************************************
     *   // 指定控制层(可自定义)
     *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
     *   // 设置控制层和播放模型
     *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
    ******************************************************************************************/
    [self.playerView playerControlView:nil playerModel:self.playerModel];
    
    // 设置代理
    self.playerView.delegate = self;
    
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    // self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    // 打开下载功能（默认没有这个功能）
    self.playerView.hasDownload    = NO;
    // 打开预览图
    self.playerView.hasPreviewView = YES;
    
    // 是否自动播放，默认不自动播放
//    [self.playerView autoPlayTheVideo];
    
}

// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Getter

- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"这里设置视频标题";
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;

    }
    return _playerModel;
}


@end
