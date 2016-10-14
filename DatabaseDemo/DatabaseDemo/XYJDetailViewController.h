//
//  XYJDetailViewController.h
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/10.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XYJPerson;

@interface XYJDetailViewController : UIViewController

@property (nonatomic,strong) XYJPerson * person;

@property (nonatomic,assign) BOOL  isAddPerson;  //!< 是否是添加成员

@end
