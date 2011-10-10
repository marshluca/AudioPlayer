//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioButton.h"
#import "AudioStreamer.h"

@implementation AudioPlayer

@synthesize streamer, button, url;


- (id)init
{
    self = [super init];
    if (self) {
        
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
    [url release];
    [streamer release];
    [button release];
    [timer invalidate];
}


- (void)play
{        
    if (!streamer) {
        
        self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
        
        // set up display updater
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
                                    [self methodSignatureForSelector:@selector(updateProgress)]];    
        [invocation setSelector:@selector(updateProgress)];
        [invocation setTarget:self];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                             invocation:invocation 
                                                repeats:YES];
        
        // register the streamer on notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playbackStateChanged:)
                                                     name:ASStatusChangedNotification
                                                   object:streamer];

    }
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }
        
    [button setNeedsLayout];    
    [button setNeedsDisplay];
}


- (void)stop
{
    [button setProgress:0];
    [button stopSpin];
    [button release]; 
    // 避免播放器的闪烁问题
    button = nil;
    
    // release streamer
	if (streamer)
	{        
		[streamer stop];
		[streamer release];
		streamer = nil;
        
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:streamer];		
	}
}


- (void)setButtonImage:(UIImage *)image
{
	// [button.layer removeAllAnimations];    
    // [image drawInRect:button.bounds];
    // [button setImage:image forState:UIControlStateNormal];		    
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];        
    } else {
        [button setProgress:0.0f];        
    }
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
    // AudioStreamer *theStreamer = [notification object];    
    // LOG(@"streamer's state: %d", streamer.state);
    
	if ([streamer isWaiting])
	{
        button.image = [UIImage imageNamed:@"stop"];
        [button startSpin];
    } else if ([streamer isIdle]) {
        button.image = [UIImage imageNamed:@"play"];
		[self stop];		
	} else if ([streamer isPaused]) {
        button.image = [UIImage imageNamed:@"play"];
    } else if ([streamer isPlaying] || [streamer isFinishing]) {
        button.image = [UIImage imageNamed:@"stop"];
        [button stopSpin];        
	} else {
        
    }
}


@end
