//
//  ASSMSComposerViewController.h
//  AmISafe
//
//  Created by Sadasivan Arun on 4/4/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
@interface ASSMSComposerViewController : UIViewController<MFMailComposeViewControllerDelegate,
MFMessageComposeViewControllerDelegate>
{
    
}

@property (nonatomic, strong)NSMutableArray *numberArray;
@property (nonatomic, strong)NSString *messageString;
-(id)initWithSingleNumber:(NSDictionary *)dict;
-(id)initWithAllNumber:(NSMutableArray *)array;
-(void)displaySMSComposerSheet;

@end
