//
//  ViewController.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/10.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "ViewController.h"
#import "XYJDetailViewController.h"
#import "XYJSearchTVController.h"
#import "XYJPersonTableViewCell.h"
#import "XYJPerson+database.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor =  [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    
    self.navigationItem.title = @"同学录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addPerson:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查询" style:UIBarButtonItemStylePlain target:self action:@selector(editPerson:)];

    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"XYJPersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //清空数据源里所有的数据
    [self.dataSource removeAllObjects];
    
    //从数据库中取出所有的用户
    NSArray * allPerson = [XYJPerson getAllPersonFromDataBase ];
    
    //NSLog(@"allPerson == %@",allPerson);
    
    //将数据加入到数据源中
    [self.dataSource addObjectsFromArray:allPerson];
    
    //刷新数据
    [self.tableView reloadData];

    
}


- (void) addPerson:(id) sender
{
    XYJDetailViewController * detailVC = [[XYJDetailViewController alloc] initWithNibName:@"XYJDetailViewController" bundle:nil];
    detailVC.isAddPerson = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void) editPerson:(id) sender
{
    
    XYJSearchTVController * vc = [[XYJSearchTVController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XYJPersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //给cell赋值
    XYJPerson * person = self.dataSource[indexPath.row];
    cell.cellNameLabel.text = person.name;
    cell.cellQQNumberLabel.text = person.QQnumber;
    
    NSString * libDirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    NSString * imageDirPath = [libDirPath stringByAppendingPathComponent:@"PersonHeadImages"];
    NSString * headImagePath = [imageDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",person.name]];
    UIImage * image = [UIImage imageWithContentsOfFile:headImagePath];
    cell.cellHeadImageView.image = image;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XYJDetailViewController * vc = [[XYJDetailViewController alloc] init];
    XYJPerson * per = self.dataSource[indexPath.row];
    vc.person = per;
    
    
    vc.isAddPerson = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

//删除行
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        XYJPerson * person = self.dataSource[indexPath.row];
        //删除数据库数据
        [XYJPerson deleteFromDataBaseByName:person.name];
        
        //删除数据源的数据
        [self.dataSource removeObjectAtIndex:indexPath.row];

        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}



#pragma mark - 懒加载

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kScreenWidth , kScreenHeight)];
        _tableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
