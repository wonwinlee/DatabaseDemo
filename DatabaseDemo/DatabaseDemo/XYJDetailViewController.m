//
//  XYJDetailViewController.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/10.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJDetailViewController.h"
#import "XYJPerson.h"
#import "XYJPerson+database.h"

@interface XYJDetailViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *sexTF;
@property (weak, nonatomic) IBOutlet UITextField *qqNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTF;
@property (weak, nonatomic) IBOutlet UITextField *weixinNumberTF;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

//系统的图片选择器，
@property (nonatomic,strong) UIImagePickerController * imagePicker;
//选择的图片的信息
@property (nonatomic,strong) NSDictionary * imageInfo;

@property (nonatomic,assign) double  updateDate;
@property (nonatomic,copy) NSString * lastName;

@end

@implementation XYJDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    //设置返回键类型
    [self.nameTF setReturnKeyType:UIReturnKeyDone];
    [self.nameTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.nameTF.delegate = self;

    [self.ageTF setReturnKeyType:UIReturnKeyDone];
    [self.ageTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.ageTF.delegate = self;
    
    [self.sexTF setReturnKeyType:UIReturnKeyDone];
    [self.sexTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.sexTF.delegate = self;
    
    [self.phoneNumberTF setReturnKeyType:UIReturnKeyDone];
    [self.phoneNumberTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.phoneNumberTF.delegate = self;
    
    [self.qqNumberTF setReturnKeyType:UIReturnKeyDone];
    [self.qqNumberTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.qqNumberTF.delegate = self;
    
    [self.weixinNumberTF setReturnKeyType:UIReturnKeyDone];
    [self.weixinNumberTF setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.weixinNumberTF.delegate = self;
    
    //给头像添加点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    self.headImageView.userInteractionEnabled = YES ;
    [self.headImageView addGestureRecognizer:tap];
    
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = 7;
    self.headImageView.clipsToBounds = YES;
    
    
    self.saveBtn.layer.cornerRadius = 4;
    self.saveBtn.clipsToBounds = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBBIDidClicked:)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isAddPerson == NO) {
        
        self.navigationItem.title = @"修改个人信息";
        
        NSLog(@"%@",self.person);
        
        //赋值
        self.nameTF.text = self.person.name;
        self.ageTF.text = [NSString stringWithFormat:@"%ld",self.person.age];
        self.sexTF.text = self.person.sex;
        self.qqNumberTF.text = self.person.QQnumber;
        self.phoneNumberTF.text = self.person.phoneNumber;
        self.weixinNumberTF.text = self.person.weixinNumber;
        
        //在子线程中 从沙盒中读取照片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            NSString * libDirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
            NSString * imageDirPath = [libDirPath stringByAppendingPathComponent:@"PersonHeadImages"];
            NSString * headImagePath = [imageDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",self.person.name]];
            UIImage * image = [UIImage imageWithContentsOfFile:headImagePath];

            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            self.headImageView.image = image;
            });
        });

        
    
        
        self.updateDate = self.person.updateDate;
        self.lastName = self.person.name;
    }
    else
    {
        self.navigationItem.title = @"添加个人信息";
    }
    
}


#pragma mark - 事件响应

- (void) backBBIDidClicked:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)finishBtnDidClicked:(id)sender {
    
    NSLog(@"finishBtnDidClicked");
    
    if ([self checkInputData] == YES) {
        
        [self addInputDataToDataBase];
    }
    
    
}
- (void) tapGestureHandle:(UITapGestureRecognizer *) tap
{
    //显示图片选择界面
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 辅助方法

//将图片写入到沙盒中,并返回图片的保存路径
- (NSString * ) imageWriteToSandBox:(XYJPerson *) person
{
    NSFileManager * fm = [NSFileManager defaultManager];
    NSString * libDirPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject];
    NSString * imageDirPath = [libDirPath stringByAppendingPathComponent:@"PersonHeadImages"];
    
    BOOL isDir = NO;  //是否是文件夹
    if ([fm fileExistsAtPath:imageDirPath isDirectory:&isDir] == NO || isDir == NO) {
        //创建文件夹
        [fm createDirectoryAtPath:imageDirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //Library/UserHeadImages/1234.jpg
    //把用户的名字作为图片的文件名
    NSString * headImagePath = [imageDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",person.name]];
    
    NSData * imageData = UIImageJPEGRepresentation(self.headImageView.image, 1.0f);
    
    //如果存在旧的照片，先把旧的照片删掉
    if ([fm fileExistsAtPath:headImagePath] == YES) {
        [fm removeItemAtPath:headImagePath error:nil];
    }
    
    BOOL ret = [fm createFileAtPath:headImagePath contents:imageData attributes:nil];
    if (ret == YES) {
        NSLog(@"保存照片到本地成功");
        return [headImagePath lastPathComponent];
    }
    else
    {
        NSLog(@"保存照片到本地失败");
        return  nil;
    }
}

//检查输入的信息是否完整
- (BOOL) checkInputData
{
    BOOL ret = YES;
    if ([self.nameTF.text isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message: @"请输入姓名"delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    if ([self.ageTF.text isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入年龄" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    if ([self.sexTF.text isEqualToString:@""]) {

        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入性别" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    if ([self.qqNumberTF.text isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入QQ号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    if ([self.phoneNumberTF.text isEqualToString:@""]) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入手机号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    if ([self.weixinNumberTF.text isEqualToString:@""]) {
        
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入微信号" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    return ret;
}

//保存输入的信息到数据库
- (void) addInputDataToDataBase
{
    //子线程保存数据到数据库中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        XYJPerson * person = [[XYJPerson alloc] init];
        person.name = self.nameTF.text;
        person.age = [self.ageTF.text integerValue];
        person.sex = self.sexTF.text;
        NSLog(@"self.sex == %@",self.sexTF.text);
        person.QQnumber = self.qqNumberTF.text;
        person.phoneNumber = self.phoneNumberTF.text;
        person.weixinNumber = self.weixinNumberTF.text;
        
        if (self.isAddPerson == YES) {
            
            //当前时间的时间戳，当前时间到1970年1月1日有多少秒
            person.updateDate = [[NSDate date] timeIntervalSince1970];
            
            //把选择的图片保存到本地，并获取它的路径
            person.headImagePath = [self imageWriteToSandBox:person];
            
            NSLog(@"person : %@",person);
            
            BOOL ret = [person insertToDataBase];
            
            //这样也可以
            //BOOL ret = [person saveToDataBase];
            
            if (ret) {
                
                NSLog(@"插入数据 到数据库成功");
                
            } else {
                NSLog(@"插入数据 到数据库失败");
            }

            
        }
        else
        {
            person.updateDate = self.updateDate;
            
            //把选择的图片保存到本地，并获取它的路径
            person.headImagePath = [self imageWriteToSandBox:person];
            
            NSLog(@"更新 person : %@",person);

            
            if ([person updateToDataBaseWithName:self.lastName]) {
                NSLog(@"更新数据 到数据库成功");
            }
            else {
                NSLog(@"更新数据 到数据库失败");
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
    

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIImagePickerControllerDelegate
//当选择一张照片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //先把图片保存起来，点击done的时候，再把图片拷贝到沙盒路径下
    self.imageInfo = info;
    
    //显示选中的照片
    self.headImageView.image = info[UIImagePickerControllerOriginalImage];
    
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

//取消选择照片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - 懒加载

- (UIImagePickerController *) imagePicker
{
    if (_imagePicker== nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        
        //设置照片选择器的照片来源类型
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        //设置代理
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}



@end
