//
//  CSDatabase.m
//  
//
//  Created by admin on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
/*CSDatabase manages the opening and closing the shared instance of the application database.
It also manages the copying of database file to the application sandbox area if it is not 
already there.
*/

#import <Foundation/Foundation.h>
#import <sqlite3.h>

#import "CSDataBaseManager.h"
#import "CSUtility.h"

@interface CSDatabase : NSObject {
	
}
	
/*
 sharedDatabase returns the shared instance of the application database. If the database is still 
 not created then first copies the sqlite file from the Bundle and places it in the sandbox 
 of the Application.
 */

//+ (sqlite3*) sharedDatabaseforUser:(NSString*)username;

+ (CSDataBaseManager *) sharedDatabase;

/*
 closeDatabase closes the shared instance of the application database. This function is assumed to 
 be called at the time of log out.
 */
+ (bool) closeDatabase;

@end
