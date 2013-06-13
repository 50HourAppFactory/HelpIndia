//
//  YAGrouponView.h
//  YpoAlpine
//
//  Created by experion on 16/04/13.
//  Copyright (c) 2013 Ypo-Alpine. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YAGrouponView : UIView

@property(nonatomic,strong)IBOutlet UIScrollView *m_scrollView;

-(void)setGrouponSlider:(NSArray *)arrayTitle toScrollView:(UIScrollView *)scrollView;
- (void)changeTitleColorForIndex:(NSInteger )index;
-(void)startScrollViewToFirst;
-(void)moveScrollViewTo:(NSInteger)index;
@end
