//
//  XYJPerson.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/10.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJPerson.h"

@implementation XYJPerson

- (NSString *)description
{
    return [NSString stringWithFormat:@"name == %@ \n age == %ld \n sex == %@ \n QQnumber == %@ \n phoneNumber == %@ \n weixinNumber == %@ \n headImagePath == %@ \n updateDate == %f",self.name,self.age,self.sex,self.QQnumber,self.phoneNumber,self.weixinNumber,self.headImagePath,self.updateDate];
    
}

@end
