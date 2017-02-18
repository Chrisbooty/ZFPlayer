//
//  ViewController.m
//  AVPlayer.Test
//
//  Created by Cijian on 2017/2/18.
//  Copyright © 2017年 Cijian. All rights reserved.
//

#import "ViewController.h"
#import "MoviePlayerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    MoviePlayerViewController *movie = [MoviePlayerViewController new];
    
    NSURL *URL                       = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456117847747a_x264.mp4"];
    movie.videoURL                   = URL;
    
    movie.view.frame = CGRectMake(0, 0, 300, 300);
    
    [self addChildViewController:movie];
    [self.view addSubview:movie.view];
}

@end
