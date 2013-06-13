

#import <UIKit/UIKit.h>
#import <sqlite3.h>


@interface CSDataBaseManager : NSObject {

	NSString * dbFileName;	//database file name
	sqlite3 *database;		//database pointer
}

@property (readonly) NSString *dbFileName;

+ (NSString *)createUuid; 
- (id)initDBWithFileName:(NSString *)file;
- (BOOL)open:(NSString *)file;
- (void)close;

- (NSString *)errorMsg;

- (NSInteger)executeScalar:(NSString *)sql, ...;
- (NSInteger)executeScalar:(NSString *)sql arguments:(NSArray *)args;

- (NSArray *)executeQuery:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql arguments:(NSArray *)args;

- (BOOL)executeNonQuery:(NSString *)sql, ...;
- (BOOL)executeNonQuery:(NSString *)sql arguments:(NSArray *)args;
- (NSInteger) lastInsertRowId;

@end

