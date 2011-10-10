//
//  CircularProgressView.h
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import <UIKit/UIKit.h>


typedef enum {
    AudioStateReady,
    AudioStatePlaying,
    AudioStateInit,
    AudioStateStop
} AudioState;

@interface AudioButton : UIButton {

	CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
	
	CGFloat _progress;
	
	CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    BOOL list;
    AudioState state;
}

@property (nonatomic, assign) BOOL list;
@property (nonatomic, assign) AudioState state;

- (id)initWithFrame:(CGRect)frame list:(BOOL)isList;
// set the component's value
- (void) setProgress:(CGFloat) newProgress;		
// set component colour, set using RGBA system, each value should be between 0 and 1.
- (void) setColourR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a;	
- (CGFloat) progress; // returns the component's value.
- (void)startSpin;
- (void)stopSpin;

@end
