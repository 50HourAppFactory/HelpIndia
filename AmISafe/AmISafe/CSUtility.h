//
//  CSUtility.h
//  Cabsher
//
//  Created by Sadasivan Arun on 4/23/12.
//  Copyright (c) 2012 Experion Global. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSUtility : NSObject
{
    
}


+ (NSString *) getDocumentPathForUser;
+(void)saveToFilePath:(NSString *)getSelectedLanguage;
+(NSString *)getDocumentPathForUserDB;

+ (NSString *)stringValueForNil :(NSString *)value;

+ (id)getValueForKey:(NSString *)plistItem fromPlistFile:(NSString *)fileName;
+ (void)setValueForKey:(NSString *)key withValue:(id)value toPlistFile:(NSString *)fileName;

@end
