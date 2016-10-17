//
//  XYJPerson+database.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/11.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJPerson+database.h"

#import "XYJDatabaseManager.h"

@implementation XYJPerson (database)

- (BOOL)saveToDataBase
{
    NSString * replaceSQl = @"REPLACE INTO T_PersonList(name, age, sex, qqNumber, phoneNumber, weixinNumber, headImagePath ,updateDate) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
    
    __block BOOL ret = NO;
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:replaceSQl,self.name,@(self.age),self.sex,self.QQnumber,self.phoneNumber,self.weixinNumber,self.headImagePath,@(self.updateDate)];
    }];
    
    return ret;
}

- (BOOL)insertToDataBase
{
    NSString * replaceSQl = @"INSERT INTO T_PersonList(name, age, sex, qqNumber, phoneNumber, weixinNumber, headImagePath ,updateDate) VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
    
    __block BOOL ret = NO;
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:replaceSQl,self.name,@(self.age),self.sex,self.QQnumber,self.phoneNumber,self.weixinNumber,self.headImagePath,@(self.updateDate)];
    }];
    
    return ret;

}

- (BOOL)updateToDataBaseWithName:(NSString *)lastName
{
    NSString * replaceSQl = @"UPDATE T_PersonList SET name = ?, age = ?, sex = ?, qqNumber = ?, phoneNumber = ?, weixinNumber  = ?, headImagePath = ? ,updateDate= ? WHERE name = ?";
    
    __block BOOL ret = NO;
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:replaceSQl,self.name,@(self.age),self.sex,self.QQnumber,self.phoneNumber,self.weixinNumber,self.headImagePath,@(self.updateDate),lastName];
    }];
    
    return ret;

}

+ (BOOL)deleteFromDataBaseByName:(NSString *) name
{
    NSString * deleteSQl = @"DELETE FROM T_PersonList WHERE name = ?";
    
    __block BOOL ret = NO;
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        ret = [db executeUpdate:deleteSQl,name];
    }];
    
    return ret;

}

+ (NSArray *)getAllPersonFromDataBase
{
    //根据时间先后顺序排序
    //ASC 升序 DESC 降序
    NSString * querrySQL = @"SELECT * FROM T_PersonList ORDER BY updateDate ASC";
    
    NSMutableArray * result = [NSMutableArray array];
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * rs = [db executeQuery:querrySQL];
        
        while ([rs next]) {
            
            XYJPerson * person = [[XYJPerson alloc] init];
            
            //给模型赋值
            person.name =   [rs stringForColumn:@"name"];
            person.age  =   [rs intForColumn:@"age"];
            person.sex = [rs stringForColumn:@"sex"];
            person.QQnumber = [rs stringForColumn:@"qqNumber"];
            person.phoneNumber = [rs stringForColumn:@"phoneNumber"];
            person.weixinNumber = [rs stringForColumn:@"weixinNumber"];
            person.updateDate = [rs doubleForColumn:@"updateDate"];
            person.headImagePath = [rs stringForColumn:@"headImagePath"];
            
            [result addObject:person];
        }
        
    }];
    
    return result;
}


+ (NSArray *)getPersonFromDataBasewithName:(NSString *)name
{
    NSString * querrySQL = @"SELECT * FROM T_PersonList WHERE name = ?";
    
    NSMutableArray * result = [NSMutableArray array];
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * rs = [db executeQuery:querrySQL,name];
        
        while ([rs next]) {
            
            XYJPerson * person = [[XYJPerson alloc] init];
            
            //给模型赋值
            person.name =   [rs stringForColumn:@"name"];
            person.age  =   [rs intForColumn:@"age"];
            person.sex = [rs stringForColumn:@"sex"];
            person.QQnumber = [rs stringForColumn:@"qqNumber"];
            person.phoneNumber = [rs stringForColumn:@"phoneNumber"];
            person.weixinNumber = [rs stringForColumn:@"weixinNumber"];
            person.updateDate = [rs doubleForColumn:@"updateDate"];
            person.headImagePath = [rs stringForColumn:@"headImagePath"];
            
            [result addObject:person];
        }
        
    }];
    
    return result;
}

+ (NSArray *)getPersonFromDataBasewithSex:(NSString *)sex
{
    
    NSString * querrySQL = @"SELECT * FROM T_PersonList WHERE sex = ?";
    
    NSMutableArray * result = [NSMutableArray array];
    
    [[XYJDatabaseManager shareManager].databaseQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet * rs = [db executeQuery:querrySQL,sex];
        
        while ([rs next]) {
            
            XYJPerson * person = [[XYJPerson alloc] init];
            
            //给模型赋值
            person.name =   [rs stringForColumn:@"name"];
            person.age  =   [rs intForColumn:@"age"];
            person.sex = [rs stringForColumn:@"sex"];
            person.QQnumber = [rs stringForColumn:@"qqNumber"];
            person.phoneNumber = [rs stringForColumn:@"phoneNumber"];
            person.weixinNumber = [rs stringForColumn:@"weixinNumber"];
            person.updateDate = [rs doubleForColumn:@"updateDate"];
            person.headImagePath = [rs stringForColumn:@"headImagePath"];
            
            [result addObject:person];
        }
        
    }];
    
    return result;

}
@end
