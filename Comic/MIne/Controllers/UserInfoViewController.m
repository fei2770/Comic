//
//  UserInfoViewController.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "UserInfoViewController.h"
#import "BRPickerView.h"
#import "NSDate+Extend.h"

@interface UserInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    NSArray *titles;
}

@property (nonatomic,strong) UIView       *narbarView;
@property (nonatomic,strong) UIView       *headView;
@property (nonatomic,strong) UIImageView  *headImgView;
@property (nonatomic,strong) UITableView  *userTableView;
@property (nonatomic,strong) UITextField  *nameTextField;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isHiddenNavBar = YES;
    
    titles = @[@"Nama akun",@"Kelamin",@"Tanggal Lahir"];
    
    [self initUserInfoView];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = titles[indexPath.row];
    if (indexPath.row==0) {
        cell.detailTextLabel.text = kIsEmptyString(self.useInfo.name)?@"":self.useInfo.name;
    }else if (indexPath.row==1){
        if ([self.useInfo.sex integerValue]>0) {
            cell.detailTextLabel.text = [self.useInfo.sex integerValue]==1?@"Laki-laki":@"Perempuan";
        }else{
            cell.detailTextLabel.text = @"";
        }
    }else{
        cell.detailTextLabel.text = [self.useInfo.birthday integerValue]>0?[[ComicManager sharedComicManager] timeWithTimeIntervalNumber:self.useInfo.birthday format:@"MM/dd/yyyy"]:@"";
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        [self modifyUserName];
    }else if (indexPath.row==1){
        [self setUserSex];
    }else{
        [self setUserBirthday];
    }
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    UIImage *curImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = [UIImage zipNSDataWithImage:curImage];
    NSString *encodeResult = [imageData base64EncodedStringWithOptions:0]; //base64
    [[HttpRequest sharedInstance] postWithURLString:kUploadPicAPI showLoading:YES parameters:@{@"pic":encodeResult} success:^(id responseObject) {
        self.useInfo.head_portrait = [responseObject objectForKey:@"data"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:self.useInfo.head_portrait] placeholderImage:[UIImage imageNamed:@"default_head"]];
        });
    } failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark UITextFieldDelegate
#pragma mmark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isFirstResponder]) {
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([[ComicManager sharedComicManager] isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([[ComicManager sharedComicManager] hasEmoji:string] || [[ComicManager sharedComicManager] strIsContainEmojiWithStr:string]){
                return NO;
            }
        }
    }
    
    if (1 == range.length) {//按下回格键
        return YES;
    }
    if (self.nameTextField==textField) {
        if ([textField.text length]<8) {
            return YES;
        }
    }
    return NO;
}


#pragma mark -- Event response
#pragma mark 编辑头像
-(void)editUserHeadImageAction{
    [self addPhoto];
}

#pragma mark 保存
-(void)rightNavigationItemAction{
    NSDictionary *params = @{@"token":kUserTokenValue,@"name":self.useInfo.name,@"head_portrait":self.useInfo.head_portrait,@"sex":self.useInfo.sex,@"birthday":self.useInfo.birthday};
    [[HttpRequest sharedInstance] postWithURLString:kSetUserInfoAPI showLoading:YES parameters:params success:^(id responseObject) {
        [ComicManager sharedComicManager].isMineReload = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userTableView reloadData];
            [self.view makeToast:@"Informasi pribadi telah berhasil diubah" duration:1.0 position:CSToastPositionCenter];
        });
    }failure:^(NSString *errorStr) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view makeToast:errorStr duration:1.0 position:CSToastPositionCenter];
        });
    }];
}

#pragma mark -- Private methods
#pragma mark 初始化
-(void)initUserInfoView{
    [self.view addSubview:self.userTableView];
    self.userTableView.tableHeaderView = self.headView;
    [self.view addSubview:self.narbarView];
}

#pragma mark 修改姓名
-(void)modifyUserName{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Nama akun" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [textField setTextAlignment:NSTextAlignmentCenter];
        [textField setReturnKeyType:UIReturnKeyDone];
        textField.delegate=self;
        self.nameTextField = textField;
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Batal" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"Yakin" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController.textFields.firstObject resignFirstResponder];
        alertController.textFields.firstObject.text = [alertController.textFields.firstObject.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *toBeString=alertController.textFields.firstObject.text;
        if (toBeString.length<1) {
            [self.view makeToast:@"Nickname tidak boleh kosong" duration:1.0 position:CSToastPositionCenter];
        }else{
            self.useInfo.name = toBeString;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.userTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    alertController.view.layer.cornerRadius = 20;
    alertController.view.layer.masksToBounds = YES;
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark 设置性别
-(void)setUserSex{
    NSArray *sexArr = @[@"Laki-laki",@"Perempuan"];
    NSString *defaultValue = nil;
    if ([self.useInfo.sex integerValue]>0) {
        defaultValue = [self.useInfo.sex integerValue]==1?@"Laki-laki":@"Perempuan";
    }else{
        defaultValue = @"Laki-laki";
    }
    [BRStringPickerView showStringPickerWithTitle:@"Kelamin" dataSource:sexArr defaultSelValue:defaultValue isAutoSelect:NO resultBlock:^(id selectValue) {
        MyLog(@"selectValue:%@",selectValue);
        NSInteger index= [sexArr indexOfObject:selectValue];
        self.useInfo.sex = [NSNumber numberWithInteger:index+1];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
        [self.userTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark 设置生日
-(void)setUserBirthday{
    NSString *defaultDate = [NSDate currentDateTimeWithFormat:@"MM/dd/yyyy"];
    NSString *defaultDateStr = [self.useInfo.birthday integerValue]>0?[[ComicManager sharedComicManager] timeWithTimeIntervalNumber:self.useInfo.birthday format:@"MM/dd/yyyy"]:defaultDate;
    [BRDatePickerView showDatePickerWithTitle:@"Tanggal Lahir" dateType:UIDatePickerModeDate defaultSelValue:defaultDateStr minDateStr:nil maxDateStr:defaultDate isAutoSelect:NO resultBlock:^(NSString *selectValue) {
        self.useInfo.birthday = [[ComicManager sharedComicManager] timeSwitchTimestamp:selectValue format:@"MM/dd/yyyy"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        [self.userTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

#pragma mark -- Getters
#pragma mark 导航栏
-(UIView *)narbarView{
    if (!_narbarView) {
        _narbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
        
       UIButton *backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
        [backBtn setImage:[UIImage drawImageWithName:@"return_white"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
        [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_narbarView addSubview:backBtn];
        
        UILabel *titleLabel =[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-180)/2, KStatusHeight+12, 180, 22)];
        titleLabel.textColor=[UIColor whiteColor];
        titleLabel.font=[UIFont mediumFontWithSize:18];
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text = @"Informasi diri";
        [_narbarView addSubview:titleLabel];
        
        UIButton *saveBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-65, KStatusHeight+2, 60, 40)];
        [saveBtn setTitle:@"Simpan" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.titleLabel.font=[UIFont regularFontWithSize:16];
        [saveBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
        [_narbarView addSubview:saveBtn];
    }
    return _narbarView;
}

#pragma mark 头部视图
-(UIView *)headView{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 233)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:_headView.bounds];
        imgView.image = [UIImage imageNamed:@"personal_data_background"];
        [_headView addSubview:imgView];
        
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-90)/2.0, kNavHeight+25, 90, 90)];
        if (kIsEmptyString(self.useInfo.head_portrait)) {
            _headImgView.image = [UIImage imageNamed:@"default_head"];
        }else{
            [_headImgView sd_setImageWithURL:[NSURL URLWithString:self.useInfo.head_portrait] placeholderImage:[UIImage imageNamed:@"default_head"]];
        }
        [_headImgView setBorderWithCornerRadius:45 type:UIViewCornerTypeAll];
        _headImgView.userInteractionEnabled = YES;
        [_headView addSubview:_headImgView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editUserHeadImageAction)];
        [_headImgView addGestureRecognizer:tap];
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(_headImgView.right-25, _headImgView.bottom-22, 22, 22)];
        [editBtn setImage:[UIImage imageNamed:@"upload_head_sculpture"] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editUserHeadImageAction) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:editBtn];
        
        UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 213, kScreenWidth, 20)];
        aView.backgroundColor = [UIColor whiteColor];
        [aView setBorderWithCornerRadius:16 type:UIViewCornerTypeTop];
        [_headView addSubview:aView];
    }
    return _headView;
}

#pragma mark 用户
-(UITableView *)userTableView{
    if (!_userTableView) {
        _userTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _userTableView.delegate = self;
        _userTableView.dataSource = self;
        _userTableView.tableFooterView = [[UIView alloc] init];
        _userTableView.showsVerticalScrollIndicator = NO;
        
        if (@available(iOS 11.0, *)) {
            _userTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _userTableView;
}

@end
