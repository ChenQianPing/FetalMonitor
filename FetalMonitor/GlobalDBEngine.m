#import "GlobalDBEngine.h"
#import "Global.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"
#import "NSDictionary+Utils.h"

#define kTableNameGrardianshipData @"grardianship_data"
#define kGrardianshipDataTableSchema @" \
CREATE TABLE grardianship_data (\
id TEXT NOT NULL, \
filename TEXT NOT NULL PRIMARY KEY, \
create_time TEXT NOT NULL, \
duration TEXT NOT NULL, \
upload_status TEXT NOT NULL \
);"

@interface GlobalDBEngine ()
{
    FMDatabaseQueue* _dbQueue;
}

@end

@implementation GlobalDBEngine

#pragma mark -
#pragma mark NSObject

- (id)init
{
    self = [super init];
    if(self)
    {
        [self commonInit];
//        [self createTableForGrardianship];
    }
    return self;
}

#pragma mark -
#pragma mark Public

+ (GlobalDBEngine *)sharedDB
{
    static GlobalDBEngine *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _instance = [[GlobalDBEngine alloc] init];
    });
    
    return _instance;
}

- (BOOL)insertGrardianshipData:(GrardianshipData *)grardianshipData
{
    __block BOOL success = NO;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        NSString* SQL = @"INSERT INTO grardianship_data(id, filename, create_time, duration, upload_status) VALUES(?, ?, ?, ?, ?)";
        success = [db executeUpdate:SQL,grardianshipData.grardianshipID, grardianshipData.fileName, grardianshipData.createTime, grardianshipData.duration, grardianshipData.uploadStatus];
        *rollback = !success;
        
    }];
    
    return success;
}

#pragma mark -
#pragma mark - Select All GrardianshipData With grardianshipId
- (NSArray *)getLocalGrardianshipDataWithType:(NSString *)grardianshipId
{
    __block NSMutableArray* array = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
    {
        NSString* SQL = @"SELECT id, filename, create_time, duration, upload_status FROM grardianship_data WHERE id=? AND upload_status=? ORDER BY create_time DESC";
        
        FMResultSet* resultSet = [db executeQuery:SQL, grardianshipId,@"0"];
        
        while ([resultSet next])
        {
            GrardianshipData *grardianshipData = [[GrardianshipData alloc] init];
            grardianshipData.grardianshipID = [resultSet stringForColumnIndex:0];
            grardianshipData.fileName = [resultSet stringForColumnIndex:1];
            grardianshipData.createTime = [resultSet stringForColumnIndex:2];
            grardianshipData.duration = [resultSet stringForColumnIndex:3];
            grardianshipData.uploadStatus = [resultSet stringForColumnIndex:4];
            [array addObject:grardianshipData];
        }
        
        [resultSet close];
        
    }];
    return array;
}

// 未上传数据查询
- (NSArray *)getUnUploadGrardianshipDataWithType:(NSString *)grardianshipId
{
    __block NSMutableArray* array = [[NSMutableArray alloc] init];
    [_dbQueue inDatabase:^(FMDatabase *db)
    {
        NSString* SQL = @"SELECT id, filename, create_time, duration FROM grardianship_data WHERE id=? AND upload_status=? ORDER BY create_time DESC";
        
        FMResultSet* resultSet = [db executeQuery:SQL, grardianshipId,@"0"];
        
        while ([resultSet next])
        {
            GrardianshipData *grardianshipData = [[GrardianshipData alloc] init];
            grardianshipData.grardianshipID = [resultSet stringForColumnIndex:0];
            grardianshipData.fileName = [resultSet stringForColumnIndex:1];
            grardianshipData.createTime = [resultSet stringForColumnIndex:2];
            grardianshipData.duration = [resultSet stringForColumnIndex:3];
            [array addObject:grardianshipData];
        }
        
        [resultSet close];
        
    }];
    return array;
}


#pragma mark - update
- (BOOL)updateGrardianshipDataWith:(NSString *)grardianshipId andFilename:(NSString *)filename
{
    __block BOOL success = NO;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        NSString* SQL = @"UPDATE grardianship_data SET upload_status=? WHERE id=? AND filename=?";
        success = [db executeUpdate:SQL,@"1",grardianshipId,filename];
        *rollback = !success;
    }];
    
    return success;
}

-(BOOL)deleGrardianshipDataWithFilename:(NSString *)filename
{
    __block BOOL success = NO;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        NSString* SQL = @"DELETE FROM grardianship_data WHERE filename=?";
        success = [db executeUpdate:SQL,filename];
        *rollback = !success;
        
    }];
    
    return success;
}

- (NSString *)uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}

#pragma mark -
#pragma mark Private

- (void)commonInit
{
    NSString* dbFilePath = TTPathForDocumentsResource(@"fm.db");
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        db.logsErrors = YES;
        [db setShouldCacheStatements:YES];
        [db executeUpdate:@"PRAGMA foreign_keys = ON"];
        
        if(![db tableExists:kTableNameGrardianshipData])
        {
            [db executeUpdate:kGrardianshipDataTableSchema];
        }
    }];
}

-(void)createTableForGrardianship
{
    // 监护本地数据表
    NSString* dbFilePath = TTPathForDocumentsResource(@"fm.db");
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback)
    {
        db.logsErrors = YES;
        [db setShouldCacheStatements:YES];
        [db executeUpdate:@"PRAGMA foreign_keys = ON"];
        
        if(![db tableExists:kTableNameGrardianshipData])
        {
            [db executeUpdate:kGrardianshipDataTableSchema];
        }
    }];
}

@end


