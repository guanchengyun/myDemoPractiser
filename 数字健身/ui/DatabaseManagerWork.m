//
//  DatabaseManagerWork.m
//  O了
//
//  Created by macmini on 14-03-10.
//  Copyright (c) 2014 QYB. All rights reserved.
//

#import "DatabaseManagerWork.h"
#import "JsonManager.h"
#import "FMDatabaseAdditions.h"

static DatabaseManagerWork* databasWorketance;
@implementation DatabaseManagerWork
@synthesize db,ddlVersion,tables,dataQueue;

- (void)open{
    if (db) {
        //已经打开了，什么都不做
        return;
    }
    
    if (!sqliteFilename) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir = [paths objectAtIndex:0];
        sqliteFilename = [cachesDir stringByAppendingPathComponent:@"fitness.sqlite"];
    }
    
    //打开数据库连接
    db = [FMDatabase databaseWithPath:sqliteFilename];
    dataQueue=[FMDatabaseQueue databaseQueueWithPath:sqliteFilename];
    //设置timeout，防止sqlite被锁住后程序死循环
    db.busyRetryTimeout = 1000;
    
    if (![db open]) {
        //打开数据库失败，显示提示，退出程序
        [self alertDBError];
    }
}
- (void)close
{
    if (!db) {
        //已经关闭了，什么都不做
        return;
    }
    
    [db close];
    
    db = nil;
}

//显示没有数据库的提示，用户按下按钮后退出程序
- (void)alertDBError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能打开数据库文件"
                                                    message:@"实在抱歉，无法在您的设备上打开数据库文件."
                                                   delegate:self
                                          cancelButtonTitle:@"好吧，真遗憾"
                                          otherButtonTitles:nil];
    [alert show];

}

+(DatabaseManagerWork *)sharedInstanse{
    if (!databasWorketance) {
        databasWorketance = [[self alloc]init];
        databasWorketance.tables = [[NSDictionary alloc]init];
        databasWorketance.tables = [databasWorketance getDDLTables];
        [databasWorketance open];
        [databasWorketance initDDL];
        [databasWorketance close];
    }
    return databasWorketance;
}

#pragma mark - DDL初始化

//初始化数据库表DDL结构和默认数据
- (void)initDDL
{
    //注意，当前DDL版本为1
    ddlVersion = 1;
    int v = 0;

    //得到当前DDL版本
    FMResultSet *rs = [db executeQuery:@"PRAGMA user_version"];
    if ([rs next]) {
        v = [rs intForColumnIndex:0];
    }
    
    [rs close];
    
    if (v < 0) {
        v = 0;
    }
    
    if (v == ddlVersion) {
        //DDL版本一致，啥也不用做，再检查一下初始化的系统数据
//        [self initData];
        
        return;
    }
    
    //开始处理DDL，启动事务
    [db beginTransaction];
    
    //取得要创建的表结构，是个dict，key为表名，value为内含columns、indexes的dict
    
    for (NSString *tableName in tables.allKeys) {
        NSDictionary *tableDict = [tables objectForKey:tableName];
        
        if (![self createTable:tableName columns:[tableDict objectForKey:@"columns"] indexes:[tableDict objectForKey:@"indexes"]]) {
            //创建表失败，事务回滚，结束函数
//            NSLog(@"init table DDL '%@':'%@' failed, last db message is %d: %@", tableName, tableDict, [db lastErrorCode], [db lastErrorMessage]);
            
            [db rollback];
            
            return;
        }
    }
    
    //DDL处理完成，设置ddl_version pragma，提交事务
    if (![db executeUpdate:[NSString stringWithFormat:@"PRAGMA user_version = %d", ddlVersion]]) {
        //设置pragma失败，回滚事务
//        NSLog(@"DDL inited but pragma user_version set to '%d' wrong!", ddlVersion);
        
        [db rollback];
        
        return;
    }
    
    //一切OK，提交事务，前去初始化城市等系统数据
    [db commit];
    
//    [self initData];
}

//在这里定义要初始化的本地sqlite表结构
//注意，数据类型一定写在最后且为小写，否则会导致自动添加的"NOT NULL DEFAULT 0"执行失败

-(NSDictionary *)getDDLTables{
    NSMutableDictionary *dict   = [NSMutableDictionary dictionaryWithCapacity:2];
    NSArray *keyArrays          = [NSArray arrayWithObjects:@"columns", @"indexes", nil];

    [dict setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                         [NSArray arrayWithObjects:
                                                          @"id integer",
                                                          @"name text",
                                                          @"type text",
                                                          @"filePath text",
                                                          @"httpPath text",
                                                          nil],
                                                         [NSArray arrayWithObjects:
                                                          @"id",
                                                          @"name",
                                                          @"type",
                                                          @"filePath",
                                                          @"httpPath",
                                                          nil],
                                                         nil]
                                                forKeys:keyArrays]
             forKey:SqlitFitnessTestList
     ];
    
    [dict setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                         [NSArray arrayWithObjects:
                                                          @"AU_ID integer",
                                                          @"AU_Content text",
                                                          @"AU_Address text",
                                                          @"AU_Img text",
                                                          nil],
                                                         [NSArray arrayWithObjects:
                                                          @"AU_ID",
                                                          @"AU_Content",
                                                          @"AU_Address",
                                                          @"AU_Img",
                                                          nil],
                                                         nil]
                                                forKeys:keyArrays]
             forKey:SqlitAboutOur
     ];
    
//    资讯
    [dict setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                         [NSArray arrayWithObjects:
                                                          @"ID integer",
                                                          @"IC_Name text",
                                                          nil],
                                                         [NSArray arrayWithObjects:
                                                          @"ID",
                                                          @"IC_Name",
                                                          nil],
                                                         nil]
                                                forKeys:keyArrays]
             forKey:SqlitGetInfo_Col
     ];
    
    [dict setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                         [NSArray arrayWithObjects:
                                                          @"ID integer",
                                                          @"TypeId integer",
                                                          @"rownum integer",
                                                          @"II_Name text",
                                                          @"II_Createdate text",
                                                          @"II_ImgUrl text",
                                                          nil],
                                                         [NSArray arrayWithObjects:
                                                          @"ID",
                                                          @"TypeId",
                                                          @"rownum",
                                                          @"II_Name",
                                                          @"II_Createdate",
                                                          @"II_ImgUrl",
                                                          nil],
                                                         nil]
                                                forKeys:keyArrays]
             forKey:SqlitGetInfo_Title
     ];
    
//    教练圈
    [dict setObject:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:
                                                         [NSArray arrayWithObjects:
                                                          @"ID integer",
                                                          @"TypeId integer",
                                                          @"rownum integer",
                                                          @"CC_Title text",
                                                          @"CC_Createdate text",
//                                                          @"II_ImgUrl text",
                                                          nil],
                                                         [NSArray arrayWithObjects:
                                                          @"ID",
                                                          @"TypeId",
                                                          @"rownum",
                                                          @"CC_Title",
                                                          @"CC_Createdate",
//                                                          @"II_ImgUrl",
                                                          nil],
                                                         nil]
                                                forKeys:keyArrays]
             forKey:SqliteList_Circle
     ];
    
    return dict;
}


- (void)InsertToTable:(NSString *)table dataArray:(NSArray *)dataArray{
    if (![dataArray isKindOfClass:[NSArray class]]) {
//        NSLog(@"dataArray wrong %@", dataArray);
        
        return;
    }
    
    if (dataArray.count < 1) {
        return;
    }
    
    NSDictionary *dict      = [self columnsFromTable:table];
    NSMutableArray *columns = [[NSMutableArray alloc] init];
    NSMutableArray *updates = [[NSMutableArray alloc] init];
    NSMutableArray *qmarks = [[NSMutableArray alloc] init];
    
    NSArray *data      = [[tables objectForKey:table] objectForKey:@"indexes"];
    
    for (NSString *k in data){
        if ([[[tables objectForKey:table] objectForKey:@"indexes"]containsObject:k]) {
            [columns addObject:k];
            [updates addObject:[k stringByAppendingString:@"=?"]];
            [qmarks addObject:@"?"];
            
        }
    }
    
    //构造insert into和update子句
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES(%@)",
                           table,
                           [columns componentsJoinedByString:@","],
                           [qmarks componentsJoinedByString:@","]
                           ];
    
    for (NSMutableDictionary *datain in dataArray) {

        
        
        NSMutableArray *argArray = [[NSMutableArray alloc]init];
        //            NSLog(@"data::%@",messagelist);
       
        
        for (NSString *k in columns) {
            if (([[datain objectForKey:k] isKindOfClass:[NSArray class]])||([[datain objectForKey:k] isKindOfClass:[NSDictionary class]])) {
                [argArray addObject:[JsonManager jsonFromDict:[datain objectForKey:k]]];
            }else{
                [argArray addObject:[NSString stringWithFormat:@"%@",[datain objectForKey:k]]];
            }
        }

        if ([dict.allKeys containsObject:[NSString stringWithFormat:@"%@",[datain objectForKey:@"id"]]]){
            NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE id=%@",
                                   table,
                                   [updates componentsJoinedByString:@","],
                                   [datain objectForKey:@"id"]
                                   ];
//            [db executeUpdate:updateSql withArgumentsInArray:argArray];
//            NSLog(@"===%@",updateSql);
            [dataQueue inDatabase:^(FMDatabase *db_01) {
                [db_01 executeUpdate:updateSql withArgumentsInArray:argArray];
            }];
            
        }else{
//            [db executeUpdate:insertSql withArgumentsInArray:argArray];
            
//            NSLog(@"---%@",insertSql);
//            NSLog(@"+++%@",argArray);
            [dataQueue inDatabase:^(FMDatabase *db_01) {
                [db_01 executeUpdate:insertSql withArgumentsInArray:argArray];
            }];
            
            
        }
    }
    
}
//删除消息
-(void)deleteMessageWithMessageId:(NSString *)messageId{
    NSString *sqlStr=[NSString stringWithFormat:@"delete from messagelist where ID = %@",messageId];
    [dataQueue inDatabase:^(FMDatabase *db_01) {
        [db_01 executeUpdate:sqlStr];
    }];
}
-(void)deleteAllTable:(NSString *)tableName{
//    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"DELETE FROM                                       '%@'", tableName]];
//    [rs close];
//    NSLog(@"---%@",[NSString stringWithFormat:@"delete from '%@'",tableName]);
//    [db executeUpdate:[NSString stringWithFormat:@"delete from '%@'",tableName]];
    [dataQueue inDatabase:^(FMDatabase *db_01) {
        [db_01 executeUpdate:[NSString stringWithFormat:@"delete from '%@'",tableName]];
    }];
}
    
//得到本地sqlite数据库里表名为table的所有字段，返回的dict中key为字段名，value为字段类型字符串，本方法主要给jsonInsertToTable用
- (NSDictionary *)columnsFromTable:(NSString *)table
{
    //首先拿到该表的DDL结构
     NSMutableDictionary *dict   = [[NSMutableDictionary alloc] init];
    [dataQueue inDatabase:^(FMDatabase *db_01) {
//        [db_01 executeUpdate:[NSString stringWithFormat:@"delete from '%@'",tableName]];
        FMResultSet *rs = [db_01 executeQuery:[NSString stringWithFormat:@"select id FROM                                       '%@'", table]];
        
        while ([rs next]) {
            [dict setObject:@"id" forKey:[rs stringForColumn:@"id"]];
        }
        
        [rs close];
    }];
    

    return dict;
}

//建表的方便方法，传入表名和字段名的字符串数组，再传入要建立索引的字段名字符串数组就可以了，如果表已存在则会drop后重新建新表
- (BOOL)createTable:(NSString *)table columns:(NSArray *)columns indexes:(NSArray *)indexes
{
    BOOL success    = true;
    BOOL shouldDrop = false;
    NSString *ddl   = [NSString stringWithFormat:@"select count(*)"
                       " from sqlite_master"
                       " where type ='table' and name = '%@'", table];
    FMResultSet *rs = [db executeQuery:ddl];
    
    if ([rs next]
        && [rs intForColumnIndex:0]
        ) {
        shouldDrop = true;
    }
    
    [rs close];
    
    if (shouldDrop) {
        ddl     = [NSString stringWithFormat:@"DROP TABLE %@", table];
        success = success && [db executeUpdate:ddl];
    }
    
    //根据columns数组拼DDL，所有columns均设置为NOT NULL
    NSMutableArray *notNullColumns = [NSMutableArray arrayWithCapacity:columns.count];
    
    [columns enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSString class]]) {
            return;
        }
        
        NSString *c = (NSString *)obj;
        NSString *d = nil;
        
        if ([c hasSuffix:@"text"]) {
            d = @" NOT NULL DEFAULT ''";
            
        } else if ([c hasSuffix:@"integer"]
                   || [c hasSuffix:@"real"]
                   || [c hasSuffix:@"numeric"]
                   ) {
            d = @" NOT NULL DEFAULT 0";
        } else if ([c hasSuffix:@"integer primary key autoincrement"]){
            d = @" NOT NULL DEFAULT 0";
        }
        
        [notNullColumns addObject:[obj stringByAppendingString:d]];
    }];
    
    //拼出CREATE TABLE语句
    ddl     = [NSString stringWithFormat:@"CREATE TABLE %@(%@)", table, [notNullColumns componentsJoinedByString:@", "]];
    success = success && [db executeUpdate:ddl];
    
    //建立索引
    for (NSString *idx in indexes) {
        ddl     = [NSString stringWithFormat:@"CREATE INDEX %@_%@_idx ON %@(%@)", table, idx, table, idx];
        success = success && [db executeUpdate:ddl];
    }
    
    return success;
}
#pragma mark 创建工作圈成员信息
- (BOOL)createTableMemberList
{
    BOOL result=YES;
    if (![db tableExists:@"menberInfo"]) {
        NSString *createTable=@"CREATE TABLE menberInfo(id INTEGER,orgNum INTEGER,partName TEXT,telNum TEXT,menberName TEXT,shortNum TEXT,reserve1 TEXT,reserve2 TEXT,reserve3 TEXT,reserve4 TEXT,reserve5 TEXT,reserve6 TEXT,reserve7 TEXT,reserve8 TEXT,reserve9 TEXT,reserve10 TEXT,avatar TEXT,circleID INTEGER)";
        NSString *triggerMI=@"CREATE TRIGGER mi_Insert BEFORE INSERT ON menberInfo FOR EACH ROW BEGIN DELETE FROM menberInfo WHERE circleID=new.id; END;";
        [db beginTransaction];
        result=[db executeUpdate:createTable]&&[db executeUpdate:triggerMI];
        if (!result) {
            [db rollback];
        }else{
            [db commit];
        }
    }
    return result;
}

@end
