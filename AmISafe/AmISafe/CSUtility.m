//
//  CSUtility.m
//  Cabsher
//
//  Created by Sadasivan Arun on 4/23/12.
//  Copyright (c) 2012 Experion Global. All rights reserved.
//

#import "CSUtility.h"
#import <SystemConfiguration/SCNetworkReachability.h>
@implementation CSUtility


#define CSDatabaseNameWithExt @"amisafe.sqlite"


// get the complete path of the database file from the Document Folder
+ (NSString *) getDocumentPathForUser
{
	//---get the path of the Documents folder---
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	
	NSString *documentsDir = [paths objectAtIndex:0];
	
	//NSString *filePath = [documentsDir stringByAppendingPathComponent:MCDatabaseNameWithExt];
	
	return documentsDir;
}


+(void)saveToFilePath:(NSString *)getSelectedLanguage
{
    NSString *languageSelected = getSelectedLanguage;
    NSLog(@"Language From Utility is %@",languageSelected);
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
        
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        
        //here add elements to data file and write data to file
        
        
        [data setObject:languageSelected forKey:@"language"];
        
        [data writeToFile: path atomically:YES];        
    }
    else
    {
        NSLog(@"File Already Found");
        NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        
        //load from savedStock example int value
        NSString *get_lang;
        get_lang = [savedStock objectForKey:@"language"] ;
    }
}

+(NSString *)getDocumentPathForUserDB
{
    NSString *databaseSaveLocation = [CSUtility getDocumentPathForUser];
    
    NSString *dbName = CSDatabaseNameWithExt;
    
    return [databaseSaveLocation stringByAppendingPathComponent:dbName];
}




+ (NSString *)stringValueForNil :(NSString *)value
{
    if(nil == value)
    {
        value = @"";
    }

    return value;
}





/*
 * Method to get value of a given key from the specified plist
 */
+ (id)getValueForKey:(NSString *)plistItem fromPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *userConfigFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc]initWithContentsOfFile:userConfigFile] ;
    
   // NSLog(@"Config Dict is %@",configDic);
    
    id retString = [configDic valueForKey:plistItem];
    
    return retString;
}

/*
 * Method to set value of a given key to the specified plist
 */

+ (void)setValueForKey:(NSString *)key withValue:(id)value toPlistFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);  
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *userConfigFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *configDic = [[NSMutableDictionary alloc]initWithContentsOfFile:userConfigFile];
    
    [configDic setObject:value forKey:key];
    
    
    [configDic writeToFile:userConfigFile atomically: YES];
}
@end
