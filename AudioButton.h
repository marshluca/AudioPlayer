//
//  CircularProgressView.h
//  QuatzTest
//
//  Created by soroush khodaii (soroush@turnedondigital.com) on 24/01/2011.
//  Copyright 2011 Turned On Digital. You are free todo whatever you want with this code :)
//

#import <UIKit/UIKit.h>


@interface AudioButton : UIButton {

	CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
	
	CGFloat _progress;
	
	CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    BOOL list;
}

@property (nonatomic, assign) BOOL list;

- (id)initWithFrame:(CGRect)frame list:(BOOL)isList;
-(void) setProgress:(CGFloat) newProgress;		// set the component's value
-(void) setColourR:(CGFloat) r G:(CGFloat) g B:(CGFloat) b A:(CGFloat) a;	// set component colour, set using RGBA system, each value should be between 0 and 1.
-(CGFloat) progress; // returns the component's value.

@end
