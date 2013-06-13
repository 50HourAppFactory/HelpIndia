//
//  ASSlider.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/29/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASSlider : UISlider

-(void)makeFrameForSlider:(CGRect)frame;
-(void)setBackgroundColorForSlider:(UIColor *)backgroundColor;
- (void)sliderDrag:(id)sender;
- (void)sliderTouched:(id)sender;
@end
