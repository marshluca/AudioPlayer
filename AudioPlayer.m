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


- (void)destroyStreamer
{
    button.state = AudioStateStop;
    [button stopSpin];
    [self.button setProgress:0];
    
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

- (void)createStreamer
{   
    if (streamer) return;
    
	[self destroyStreamer];
    
	self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
    
    // register the streamer on notification
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:streamer];
}


- (void)setButtonImage:(UIImage *)image
{
	//[button.layer removeAllAnimations];    
    //[image drawInRect:button.bounds];
    //[button setImage:image forState:UIControlStateNormal];		    
}

- (void)updateProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];        
    } else {
        [button setProgress:0.0f];        
    }
}


- (void)showProgress
{    
    [button setProgress:0.0];
    // [button setColourR:0.1 G:1.0 B:0.1 A:1.0];       
    
    // set up display updater
    NSInvocation *updateAudioDisplayInvocation = 
    [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(updateProgress)]];
    
    [updateAudioDisplayInvocation setSelector:@selector(updateProgress)];
    [updateAudioDisplayInvocation setTarget:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                         invocation:updateAudioDisplayInvocation 
                                            repeats:YES];
}


- (void)play
{        
    // the player may be destroyed 
    if (!streamer) [self createStreamer]; 
    
    if ([streamer isPlaying]) {
        [streamer pause];
    } else {
        [streamer start];
    }
        
    [button setNeedsLayout];    
    [button setNeedsDisplay];
}

- (void)buffer
{
    [button startSpin];
}


- (void)stop
{
    [self destroyStreamer];
}


/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)notification
{
    // AudioStreamer *theStreamer = [notification object];    
    LOG(@"streamer's state: %d", streamer.state);
    
	if ([streamer isWaiting])
	{
        button.state = AudioStateReady;
        [self buffer];
    }
    else if ([streamer isPlaying])
	{
        [button stopSpin];
        button.state = AudioStatePlaying;
        [self showProgress];
	}
    else if ([streamer isPaused])
    {
        
    }
    else if ([streamer isFinishing])
    {
        [button stopSpin];
        button.state = AudioStatePlaying;
        [self showProgress];
    }
	else if ([streamer isIdle])
	{
        [button stopSpin];
        button.state = AudioStateStop;
		[self destroyStreamer];		
	}
}


@end
