//
//  XYJDatabaseManager.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/11.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJDatabaseManager.h"

@implementation XYJDatabaseManager

+ (instancetype)shareManager
{static XYJDatabaseManager * manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[XYJDatabaseManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        //数据库存放路径
        NSString * libDirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject];
        NSString * dbPath = [libDirPath stringByAppendingPathComponent:@"databaseDemo.sqlite"];
        NSLog(@"dbpath == %@",dbPath);
        
        //创建数据库
        _databaseQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        if (_databaseQueue == nil) {
            
            NSLog(@"数据库创建失败");
            
            [NSException raise:NSInternalInconsistencyException format:@"数据库创建异常"];
        }
        else
        {
            //创建一个表
            NSString *createTablSQL = @"CREATE TABLE IF NOT EXISTS T_PersonList (name text PRIMARY KEY NOT NULL, age integer NOT NULL,sex text,qqNumber text,phoneNumber text,weixinNumber text,headImagePath text,updateDate double)";
            
            [_databaseQueue inDatabase:^(FMDatabase *db) {
                
                BOOL ret = [db executeUpdate:createTablSQL];
                if (ret)
                {
                    NSLog(@"创建T_PersonList 表成功");
                }
                else
                {
                    NSLog(@"创建T_PersonList 表失败");
                }
            }];
        }
    }
    return self;
}

@end
