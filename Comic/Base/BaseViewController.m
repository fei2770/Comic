//
//  BaseViewController.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2018年 vision. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseNavigationController.h"
#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "MXActionSheet.h"

@interface BaseViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate>{
    UIView        *navView;
    UIButton      *backBtn;
    UILabel       *titleLabel;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout=UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.interactivePopGestureRecognizer.enabled=YES;
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    
    [self.navigationController setNavigationBarHidden:YES];
    
    [self customNavBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

#pragma mark 状态栏样式
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark -- Delegate
#pragma mark  UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- Event response
#pragma mark 左侧返回方法
-(void)leftNavigationItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 导航栏右侧按钮事件
-(void)rightNavigationItemAction{
    
}

#pragma mark 去登录
-(void)presentLoginVC{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:loginVC];
    nav.modalPresentationStyle = 0;
    [self presentViewController:nav animated:YES completion:nil];
}


#pragma mark --Private Methods
#pragma mark 自定义导航栏
-(void)customNavBar{
    navView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavHeight)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    backBtn=[[UIButton alloc] initWithFrame:CGRectMake(5,KStatusHeight + 2, 40, 40)];
    [backBtn setImage:[UIImage drawImageWithName:@"return_black"size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-10.0, 0, 0)];
    [backBtn addTarget:self action:@selector(leftNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(60, KStatusHeight+12,kScreenWidth-120, 22)];
    titleLabel.textColor=[UIColor commonColor_black];
    titleLabel.font=[UIFont mediumFontWithSize:18];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    
    self.rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-55, KStatusHeight+2, 50, 40)];
    [self.rightBtn addTarget:self action:@selector(rightNavigationItemAction) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:self.rightBtn];
}

#pragma mark  上传照片
-(void)addPhoto{
    NSArray *buttonTitles = @[@"Ambil gambar",@"Pilih dari album ponsel",];
    [MXActionSheet showWithTitle:nil cancelButtonTitle:@"Batal" destructiveButtonTitle:nil otherButtonTitles:buttonTitles selectedBlock:^(NSInteger index) {
         self.imgPicker=[[UIImagePickerController alloc]init];
         self.imgPicker.delegate=self;
         self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        if (index==1) {
           if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) //判断设备相机是否可用
           {
               self.imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
               [self presentViewController:self.imgPicker animated:YES completion:nil];
           }else{
               [self.view makeToast:@"Kamera anda tidak bisa digunakan" duration:1.0 position:CSToastPositionCenter];
               return ;
           }
        }else if (index==2){
            self.imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imgPicker animated:YES completion:nil];
        }
        
    }];
}


#pragma mark -- setters and getters
#pragma mark 设置是否隐藏导航栏
-(void)setIsHiddenNavBar:(BOOL)isHiddenNavBar{
    _isHiddenNavBar = isHiddenNavBar;
    navView.hidden = isHiddenNavBar;
}

#pragma mark 设置是否隐藏返回按钮
-(void)setIsHiddenBackBtn:(BOOL)isHiddenBackBtn{
    _isHiddenBackBtn = isHiddenBackBtn;
    backBtn.hidden = isHiddenBackBtn;
}

#pragma makr 设置导航栏左侧按钮图片
-(void)setLeftImageName:(NSString *)leftImageName{
    _leftImageName=leftImageName;
    if (!kIsEmptyString(leftImageName)) {
        backBtn.hidden=NO;
        if ([_leftImageName isEqualToString:@"return"]) {
           [backBtn setImage:[UIImage drawImageWithName:_leftImageName size:CGSizeMake(12, 18)] forState:UIControlStateNormal];
        }else{
          [backBtn setImage:[UIImage drawImageWithName:_leftImageName size:CGSizeMake(24, 24)] forState:UIControlStateNormal];
        }
    }
}
#pragma mark 设置导航栏左侧按钮文字
- (void)setLeftTitleName:(NSString *)leftTitleName{
    _leftTitleName = leftTitleName;
    [backBtn setTitle:leftTitleName forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
    backBtn.titleLabel.font=[UIFont regularFontWithSize:16];
    backBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
}

#pragma mark 设置导航栏右侧按钮图片
-(void)setRightImageName:(NSString *)rightImageName{
    _rightImageName=rightImageName;
    if (!kIsEmptyString(rightImageName)) {
        [self.rightBtn setImage:[UIImage drawImageWithName:rightImageName size:CGSizeMake(24, 20)] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
    }
}

-(void)setRightBtnWithImge:(NSString *)imgName imgSize:(CGSize)imageSize{
    if (!kIsEmptyString(imgName)) {
        [self.rightBtn setImage:[UIImage drawImageWithName:imgName size:imageSize] forState:UIControlStateNormal];
    }else{
        [self.rightBtn setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark 设置导航栏右侧按钮文字
-(void)setRigthTitleName:(NSString *)rigthTitleName{
    _rigthTitleName=rigthTitleName;
    self.rightBtn.enabled = !kIsEmptyString(rigthTitleName);
    
    [self.rightBtn setTitle:rigthTitleName forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor commonColor_black] forState:UIControlStateNormal];
    if (rigthTitleName.length>=4) {
        CGSize size = [rigthTitleName boundingRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) withTextFont:[UIFont regularFontWithSize:16]];
        self.rightBtn.frame = CGRectMake(kScreenWidth-size.width-10,KStatusHeight +5, size.width, 32);
    }
    self.rightBtn.titleLabel.font=[UIFont regularFontWithSize:16];
    self.rightBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
}

#pragma mark 设置标题
-(void)setBaseTitle:(NSString *)baseTitle{
    _baseTitle=baseTitle;
    titleLabel.text=baseTitle;
}

@end
