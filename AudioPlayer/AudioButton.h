//
//  CircularProgressView.h
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import <UIKit/UIKit.h>

extern NSString *playImage, *stopImage;

@interface AudioButton : UIButton {

	CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
	
	CGFloat _progress;
	
	CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    UIImage *image;
    UIImageView *loadingView;
}

@property (nonatomic, retain) UIImage *image;

- (id)initWithFrame:(CGRect)frame;
- (void)startSpin;
- (void)stopSpin;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)newProgress;		
- (void)setColourR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b A:(CGFloat)a;	

@end
