//
//  BaseViewController.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2018年 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic ,assign) BOOL        isHiddenBackBtn;       //隐藏返回按钮
@property (nonatomic ,assign) BOOL        isHiddenNavBar;       //隐藏导航栏
@property (nonatomic , copy ) NSString    *baseTitle;           //标题
@property (nonatomic , copy ) NSString    *leftImageName;       //导航栏左侧图片名称
@property (nonatomic , copy ) NSString    *leftTitleName;       //导航栏左侧标题名称
@property (nonatomic , copy ) NSString    *rightImageName;      //导航栏右侧图片名称
@property (nonatomic , copy ) NSString    *rigthTitleName;      //导航栏右侧标题名称

@property (nonatomic ,strong)UIButton   *rightBtn;

@property (nonatomic ,strong)UIImagePickerController *imgPicker;


-(void)leftNavigationItemAction;
-(void)rightNavigationItemAction;

//上传头像
-(void)addPhoto;

//去登录
-(void)presentLoginVC;


@end
