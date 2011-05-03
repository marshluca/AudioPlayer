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
	[button.layer removeAllAnimations];
    
    [button setImage:image forState:UIControlStateNormal];		    
}

/*
 *  stop and destroy the streamer
 */
- (void)destroyStreamer
{
    [self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
    
	if (streamer)
	{
        // remove notification observer for streamer
		[[NSNotificationCenter defaultCenter] removeObserver:self 
                                                        name:ASStatusChangedNotification
                                                      object:streamer];		

        // release streamer
		[streamer stop];
		[streamer release];
		streamer = nil;
	}
}


/*
 *  initialize a streamer 
 */
- (void)createStreamer
{   
    if (streamer) return;
    
	[self destroyStreamer];
    
    // NSString *urlString = @"http://58.254.132.8/90115000/fulltrack_dl/MP3_40_16_Stero/2011032303/300018.mp3";
	self.streamer = [[AudioStreamer alloc] initWithURL:self.url];
    
    // register the streamer on notification
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackStateChanged:)
                                                 name:ASStatusChangedNotification
                                               object:streamer];
}


/*
 *  handle the playback when loading an audio
 */
-(void)startPlaying
{    
    [self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
    [streamer start];
}

-(void)pausePlaying
{
	[self setButtonImage:[UIImage imageNamed:@"pausebutton.png"]];
    [streamer pause];
}

- (void)playOrPause
{        
    if (!streamer) [self createStreamer]; // for it may be destroyed 

    @try {
        if (streamer.state == AS_PLAYING) {
            [self pausePlaying];
        } else {
            [self startPlaying];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"got an exception when play or pause: %@", [exception reason]);
    }
    @finally {
        
    }
}

/*
 *  observe the notification listener when loading an audio
 */
- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
		[self setButtonImage:[UIImage imageNamed:@"loadingbutton.png"]];
        
        [self spinButton];
    }
    else if ([streamer isPlaying])
	{
		[self setButtonImage:[UIImage imageNamed:@"stopbutton.png"]];
	}
	else if ([streamer isIdle])
	{
		[self destroyStreamer];
		[self setButtonImage:[UIImage imageNamed:@"playbutton.png"]];
	}
}


@end
