//
//  MineHeadView.h
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol MineHeadViewDelegate <NSObject>

-(void)mineHeadViewDidSelecteduserInfo;

//按钮点击事件
-(void)mineHeadViewDidClickBtnWithTag:(NSInteger)tag;

@end

@interface MineHeadView : UIView

@property (nonatomic, weak ) id<MineHeadViewDelegate>delegate;

@property (nonatomic,strong) UserModel  *userModel;
@property (nonatomic,assign) BOOL  unreadMsgState;



@end

