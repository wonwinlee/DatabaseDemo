//
//  XYJDatabaseManager.h
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/11.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

/**
 *  数据库管理类 单例 为了使用方便
 */
@interface XYJDatabaseManager : NSObject

@property (nonatomic,strong,readonly) FMDatabaseQueue * databaseQueue;  //!< 用户数据库操作的队列，线程安全的
/**
 *  单例入口
 */
+ (instancetype) shareManager;

@end
