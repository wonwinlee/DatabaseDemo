//
//  XYJPerson+database.h
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/11.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJPerson.h"

@interface XYJPerson (database)


/**
 *  添加或更新 一条数据到数据库中
 *
 *  @return 成功或失败
 */
- (BOOL) saveToDataBase;


/**
 *  插入一条数据到数据库中
 *
 *  @return 成功或失败
 */
- (BOOL) insertToDataBase;


/**
 *  根据名字修改数据库中的那条数据
 *
 *  @param lastName 修改之前的名字
 *
 *  @return 成功或失败
 */
- (BOOL) updateToDataBaseWithName:(NSString *) lastName;


/**
 *  从数据库中读出所有的人的信息
 *
 *  @return 所有的人数组
 */
+ (NSArray *) getAllPersonFromDataBase;


/**
 *  根据名字从数据库中查找人的信息
 *
 *  @param name 名字
 *
 *  @return 人的数组
 */
+ (NSArray *) getPersonFromDataBasewithName:(NSString *) name;


/**
 *  根据性别从数据库中查找人的信息
 *
 *  @param sex 性别
 *
 *  @return 人的数组
 */
+ (NSArray *) getPersonFromDataBasewithSex:(NSString *) sex;


/**
 *  根据名字从数据库中删除信息
 *
 *  @param name 要删除的名字
 *
 *  @return 成功或失败
 */
+ (BOOL) deleteFromDataBaseByName:(NSString *) name;

@end
