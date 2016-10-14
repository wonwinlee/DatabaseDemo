//
//  XYJSearchTVController.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/14.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJSearchTVController.h"
#import "XYJPersonTableViewCell.h"
#import "XYJDetailViewController.h"
#import "XYJPerson+database.h"

@interface XYJSearchTVController ()<UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray * dataSource;

@property (nonatomic,strong) UISearchBar * searchBar;

@end

@implementation XYJSearchTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.searchBar;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"XYJPersonTableViewCell" bundle:nil] forCellReuseIdentifier:@"SCell"];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBBIDidClicked:)];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XYJPersonTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SCell" forIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    // Configure the cell...
    //给cell赋值
    
    if (self.dataSource.count > 0) {
        XYJPerson * person = self.dataSource[indexPath.row];
        cell.cellNameLabel.text = person.name;
        cell.cellQQNumberLabel.text = person.QQnumber;
        
        NSString * libDirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
        NSString * imageDirPath = [libDirPath stringByAppendingPathComponent:@"PersonHeadImages"];
        NSString * headImagePath = [imageDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",person.name]];
        UIImage * image = [UIImage imageWithContentsOfFile:headImagePath];
        cell.cellHeadImageView.image = image;

    }
   
    return cell;
}

#pragma mark - 事件响应

- (void) backBBIDidClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSLog(@"searchBar.text == %@",searchBar.text);
    
    NSArray * array = @[];
    
    if ([searchBar.text isEqualToString:@"男"]) {
        
        array = [XYJPerson getPersonFromDataBasewithSex:@"男"];
        
    } else if ([searchBar.text isEqualToString:@"女"]){
        array = [XYJPerson getPersonFromDataBasewithSex:@"女"];
    } else{
        array =  [XYJPerson getPersonFromDataBasewithName:searchBar.text];
    }
    
    if (array.count == 0) {
        
        
        NSString * msg = [NSString stringWithFormat:@"数据库中没有关于[%@]的信息",searchBar.text];
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        
        self.dataSource = [[NSMutableArray alloc] initWithArray:array];
        
        [self.tableView reloadData];
        

    }
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

#pragma mark - 懒加载

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UISearchBar *)searchBar
{
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
        
        
        _searchBar.barTintColor = [UIColor darkGrayColor];
        _searchBar.placeholder = @"输入名字或性别";
        _searchBar.delegate = self;

    }
    return _searchBar;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
