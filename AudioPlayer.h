//
//  AudioPlayer.h
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CircleProgressView.h"

@class AudioStreamer;


@interface AudioPlayer : NSObject {
    AudioStreamer *streamer;
    UIButton *button;   
    NSURL *url;
    CircleProgressView *circleView;
    NSTimer *timer;
}

@property (nonatomic, retain) AudioStreamer *streamer;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) CircleProgressView *circleView;

- (void)createStreamer;
- (void)destroyStreamer;
- (void)playOrPause;
- (void)spinButton;
- (void)setButtonImage:(UIImage *)image;

@end
