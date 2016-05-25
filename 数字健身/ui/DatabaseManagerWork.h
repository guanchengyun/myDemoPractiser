//
//  DatabaseManagerWork.h
//  O了
//
//  Created by macmini on 14-03-10.
//  Copyright (c) 2014 QYB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@interface DatabaseManagerWork : NSObject{
    NSString *sqliteFilename;
    
}
@property (readonly,nonatomic) FMDatabase *db;
@property(readonly,nonatomic)FMDatabaseQueue *dataQueue;
@property (strong,nonatomic) NSDictionary *tables;
@property (readonly) int ddlVersion;

- (void)open;
- (void)close;

- (void)InsertToTable:(NSString *)table dataArray:(NSArray *)dataArray;
- (void)initDDL;
- (NSDictionary *)columnsFromTable:(NSString *)table;
-(void)deleteAllTable:(NSString *)tableName;

+(DatabaseManagerWork *)sharedInstanse;

-(void)deleteMessageWithMessageId:(NSString *)messageId;
@end
