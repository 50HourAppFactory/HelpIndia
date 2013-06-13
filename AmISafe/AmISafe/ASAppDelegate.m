//
//  ASAppDelegate.m
//  AmISafe
//
//  Created by Sadasivan Arun on 3/26/13.
//  Copyright (c) 2013 Sadasivan Arun. All rights reserved.
//

#import "ASAppDelegate.h"
#import "CSUtility.h"
#import "ASHomeViewController.h"
#import "GAI.h"

#define CSDatabaseNameWithExt @"amisafe.sqlite"
#define CSDatabaseNameWithoutExt @"amisafe"

#define ASSettingsWithExt @"amiSafeProperty.plist"
#define ASSettingsWithoutExt @"amiSafeProperty"

static NSString *const kTrackingId = @"UA-40758614-1";

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [GAI sharedInstance].debug = YES;
    [GAI sharedInstance].dispatchInterval = 120;
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kTrackingId];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BOOL val = [self addDatabaseToDocumentsFolder];
    BOOL retVal = [self addSettingsFileToDocumentsFolder];
    
    // Override point for customization after application launch.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.homeViewController = [[ASHomeViewController alloc] initWithNibName:@"ASHomeViewController" bundle:nil];
    } else {
        self.viewController = [[ASHomeViewController alloc] initWithNibName:@"ASHomeViewController" bundle:nil];
    }
    
    UINavigationController *appNavController = [[UINavigationController alloc]initWithRootViewController:self.homeViewController];
    
    self.window.rootViewController = appNavController;
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(BOOL) addDatabaseToDocumentsFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destPath = [CSUtility getDocumentPathForUserDB];
    
    NSString *pathToFileInBundle = [[NSBundle mainBundle]pathForResource:CSDatabaseNameWithoutExt ofType:@"sqlite"];
    
    NSError *error = nil;
    
    return [fileManager copyItemAtPath:pathToFileInBundle toPath:destPath error:&error];
}

-(BOOL) addSettingsFileToDocumentsFolder
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //---get the path of the Documents folder---
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	
	NSString *documentsDir = [paths objectAtIndex:0];
	
    NSString *settingsSaveLocation = documentsDir;
    
    NSString *settingsName = ASSettingsWithExt;
    
    NSString *destPath = [settingsSaveLocation stringByAppendingPathComponent:settingsName];
    
    NSString *pathToFileInBundle = [[NSBundle mainBundle]pathForResource:ASSettingsWithoutExt ofType:@"plist"];
    
    NSError *error = nil;
    
    return [fileManager copyItemAtPath:pathToFileInBundle toPath:destPath error:&error];
}

@end
