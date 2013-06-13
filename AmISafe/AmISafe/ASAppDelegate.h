//
//  ASAppDelegate.h
//  AmISafe
//
//  Created by Sadasivan Arun on 3/26/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAI.h"
@class ASViewController;
@class ASHomeViewController;
@interface ASAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ASViewController *viewController;
@property (strong, nonatomic) ASHomeViewController *homeViewController;
@property(nonatomic, retain) id<GAITracker> tracker;
-(BOOL) addDatabaseToDocumentsFolder;
-(BOOL) addSettingsFileToDocumentsFolder;
@end
