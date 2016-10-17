//
//  XYJPerson.h
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/10.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYJPerson : NSObject

@property (nonatomic,copy)  NSString * name;  //!<  姓名
@property (nonatomic,assign) NSInteger  age;  //!<  年龄
@property (nonatomic,copy) NSString *  sex;  //!<  性别
@property (nonatomic,copy) NSString *  QQnumber;  //!<  qq号
@property (nonatomic,copy) NSString *  phoneNumber;  //!<  手机号
@property (nonatomic,copy) NSString *  weixinNumber;  //!<  微信号
@property (nonatomic,copy) NSString * headImagePath;  //!<  头像
@property (nonatomic,assign) NSTimeInterval updateDate; //!<  添加的时间

@end
