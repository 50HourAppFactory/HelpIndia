//
//  YAGrouponView.m
//  YpoAlpine
//
//  Created by experion on 16/04/13.
//  Copyright (c) 2013 Ypo-Alpine. All rights reserved.
//

#import "YAGrouponView.h"
#define TITLEFONTSIZE 16.0f

@interface YAGrouponView() {
    UILabel *titleLabel;
    UIFont *selectedTitleFont;
    UIFont *titleFont;
    NSMutableArray *titleLabelArray;
}

@end

@implementation YAGrouponView
@synthesize m_scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.m_scrollView;
    }
    return nil;
}

-(void)setGrouponSlider:(NSArray *)arrayTitle toScrollView:(UIScrollView *)scrollView
{
    if (titleLabelArray==nil) {
        titleLabelArray = [[NSMutableArray alloc]init];
    }
    else{
        for (UILabel *label in titleLabelArray) {
            label.text = @"";
        }
        [titleLabelArray removeAllObjects];
    }
    
    selectedTitleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    titleFont = [UIFont fontWithName:@"Helvetica" size:15.0f];
    self.m_scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    
    scrollView.contentSize = CGSizeMake([arrayTitle count]*scrollView.frame.size.width, scrollView.frame.size.height);
    
    for (int i= 0; i<[arrayTitle count]; i++)
    {
        titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*scrollView.frame.size.width, 0,scrollView.frame.size.width, scrollView.frame.size.height)];
        titleLabel.text = [arrayTitle objectAtIndex:i];
        titleLabel.textAlignment = UIBaselineAdjustmentAlignCenters;
        [titleLabel setAdjustsFontSizeToFitWidth:YES];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        if(i == 0){
            titleLabel.font = selectedTitleFont;
        }
        else{
            titleLabel.font = titleFont;
        }
        [scrollView addSubview:titleLabel];
        [titleLabelArray addObject:titleLabel];
    }
    [self changeTitleColorForIndex:0];
}

- (void)changeTitleColorForIndex:(NSInteger )index{
   // CAGradientLayer *gradient = [CAGradientLayer layer];
    //gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithRed:34.0f/255.0f green:115.0f/255.0f blue:151.0f alpha:1.0]CGColor], (id)[[UIColor colorWithRed:21.0f/255.0f green:80.0f/255.0f blue:107.0f/255.0f alpha:1.0]CGColor], nil];
    
    for (int i = 0; i < titleLabelArray.count; i++) {
        UILabel *label = [titleLabelArray objectAtIndex:i];
     //   gradient.frame = label.bounds;
        if(i == index){
            label.font = selectedTitleFont;
            label.textColor = [UIColor colorWithPatternImage:[self gradientImage]];
        }
        else{
           // [label.layer removeFromSuperlayer];
            label.textColor = [UIColor colorWithRed:96.0f/255.0f green:93.0f/255.0f blue:92.0f/255.0f alpha:1.0];
            label.font = titleFont;
        }
    }
}

- (UIImage *)gradientImage
{
    CGSize textSize = [titleLabel.text sizeWithFont:titleFont];
    CGFloat width = textSize.width;         // max 1024 due to Core Graphics limitations
    CGFloat height = textSize.height;       // max 1024 due to Core Graphics limitations
    
    // create a new bitmap image context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // push context to make it current (need to do this manually because we are not drawing in a UIView)
    UIGraphicsPushContext(context);
    
    //draw gradient
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {0.078, 0.310, 0.412 , 1.0,  // Start color
        0.125, 0.439, 0.573, 1.0 }; // End color
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace, components, locations, num_locations);
    CGPoint topCenter = CGPointMake(0, 0);
    CGPoint bottomCenter = CGPointMake(0, textSize.height);
    CGContextDrawLinearGradient(context, glossGradient, topCenter, bottomCenter, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
    
    // pop context
    UIGraphicsPopContext();
    // get a UIImage from the image context
    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
    // clean up drawing environment
    UIGraphicsEndImageContext();
    return  gradientImage;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)startScrollViewToFirst
{
    [self.m_scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)moveScrollViewTo:(NSInteger)index
{
    [self.m_scrollView setContentOffset:CGPointMake(index*self.m_scrollView.frame.size.width, 0)];
}

@end
