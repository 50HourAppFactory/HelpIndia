//
//  MCDatabase.m
//  CoPlus
//
//  Created by admin on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSDatabase.h"
#define CSDatabaseNameWithExt @"amisafe.sqlite"

static sqlite3 *sharedDatabase = nil;

static CSDataBaseManager *databaseManager = nil;

@implementation CSDatabase

// Name of the database file

+ (CSDataBaseManager *) sharedDatabase
{
	if(nil == databaseManager)
	{
		NSString *filePath = [CSUtility getDocumentPathForUser];
        
        filePath = [filePath stringByAppendingPathComponent:CSDatabaseNameWithExt];
		
		databaseManager = [[CSDataBaseManager alloc] initDBWithFileName:filePath];
	}
	return databaseManager;
}


// Close the shared instance of the databse. 
+ (bool) closeDatabase {
	bool success = false;
	@synchronized(self)
	{
		if (sharedDatabase != nil){
			success = sqlite3_close(sharedDatabase);
		}
	}
	return success;
}


@end
