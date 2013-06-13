//
//  ASSlider.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/29/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASSlider.h"

@implementation ASSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.maximumTrackTintColor = [UIColor clearColor];
        self.minimumTrackTintColor = [UIColor clearColor];
        [self setValue:0.0];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
   
}
*/

-(void)setBackgroundColorForSlider:(UIColor *)backgroundColor
{
    [self setBackgroundColor:backgroundColor];
}

-(void)makeFrameForSlider:(CGRect)frame
{
    [self setFrame:frame];
}









@end
