//
//  AudioPlayer.m
//  Share
//
//  Created by Lin Zhang on 11-4-26.
//  Copyright 2011年 www.eoemobile.com. All rights reserved.
//

#import "AudioPlayer.h"
#import "AudioStreamer.h"

#import <QuartzCore/CoreAnimation.h>
#import <CFNetwork/CFNetwork.h>

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

/*
 *  rotate the button when player is wating
 */
- (void)spinButton
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	CGRect frame = [button frame];
	button.layer.anchorPoint = CGPointMake(0.5, 0.5);
	button.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
	[CATransaction commit];
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
	[CATransaction setValue:[NSNumber numberWithFloat:2.0] forKey:kCATransactionAnimationDuration];
    
	CABasicAnimation *animation;
	animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
	animation.fromValue = [NSNumber numberWithFloat:0.0];
	animation.toValue = [NSNumber numberWithFloat:2 * M_PI];
	animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
	animation.delegate = self;
	[button.layer addAnimation:animation forKey:@"rotationAnimation"];
    
	[CATransaction commit];
}

#pragma mark - Animation Delegate methods

- (void)animationDidStart:(CAAnimation *)anim
{
}

/* Called when the animation either completes its active duration or
 * is removed from the object it is attached to (i.e. the layer). 'flag'
 * is true if the animation reached the end of its active duration
 * without being removed. */
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished
{
	if (finished)
	{
		[self spinButton];
	}
}

- (void)setButtonImage:(UIImage *)image
{
	//[button.layer removeAllAnimations];
    
    //[image drawInRect:button.bounds];
    
    //[button setImage:image forState:UIControlStateNormal];		    
}

- (void)updateAudioProgress
{
    if (streamer.progress <= streamer.duration ) {
        [button setProgress:streamer.progress/streamer.duration];        
    } else {
        [button setProgress:0.0f];        
    }
}


- (void)destroyStreamer
{
    button.state = AudioStateStop;
    [button.layer removeAllAnimations];
    [self.button setProgress:0];
    
	if (streamer)
	{
        // release streamer
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

- (void)showProgress
{
    //[button setColourR:0.1 G:1.0 B:0.1 A:1.0];
    [button setProgress:0.0];
        
    // set up display updater
    NSInvocation *updateAudioDisplayInvocation = 
    [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(updateAudioProgress)]];
    
    [updateAudioDisplayInvocation setSelector:@selector(updateAudioProgress)];
    [updateAudioDisplayInvocation setTarget:self];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                         invocation:updateAudioDisplayInvocation 
                                            repeats:YES];
}


- (void)play
{        
    // the player may be destroyed 
    if (!streamer) [self createStreamer]; 

    @try {
        if (streamer.state == AS_PLAYING) {
            //[self setButtonImage:[UIImage imageNamed:button.list ? @"play" : @"play"]];
            [streamer pause];
        } else  {
            // [self setButtonImage:[UIImage imageNamed:button.list ? @"loading" : @"loading"]];
            [streamer start];
        }
        
        [button setNeedsLayout];    
        [button setNeedsDisplay];
    }
    @catch (NSException *exception) {
        NSLog(@"got an exception when play: %@", [exception reason]);
    }
    @finally {

    }
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
        [self spinButton];
    }
    else if ([streamer isPlaying])
	{
        [button.layer removeAllAnimations];
        button.state = AudioStatePlaying;
        [self showProgress];
	}
    else if ([streamer isPaused])
    {
        
    }
    else if ([streamer isFinishing])
    {
        [button.layer removeAllAnimations];        
        button.state = AudioStatePlaying;
        [self showProgress];
    }
	else if ([streamer isIdle])
	{
        [button.layer removeAllAnimations];        
        button.state = AudioStateStop;
		[self destroyStreamer];		
	}
}


@end
