//
//  InputToolbarView.h
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputToolbarView;
@protocol InputToolbarViewDelegate <NSObject>


@optional
-(void)inputToolbarView:(InputToolbarView *)barView didSelectedBarrageType:(NSInteger)type; //选择弹幕样式
-(void)inputToolbarView:(InputToolbarView *)barView choosePhotoAtcion:(NSInteger)tag; //选择评论图片
-(void)inputToolbarView:(InputToolbarView *)barView toastViewHanderActionWithType:(NSInteger)type; //type 0开通会员 1确定消耗金币 2 去充值

//发送弹幕或评论
-(void)inputToolbarView:(InputToolbarView *)barView didSendText:(NSString *)text images:(NSArray *)images;

@end

typedef enum : NSUInteger {
    InputToolbarViewTypeBarrage  = 0,
    InputToolbarViewTypeComment  = 1,
} InputToolbarViewType;

@interface InputToolbarView : UIView

@property (nonatomic,assign) InputToolbarViewType  type;
@property (nonatomic, weak ) id<InputToolbarViewDelegate>delegate;
@property (nonatomic,strong) UITextView  *commentTextView;
@property (nonatomic, copy ) NSString  *contentImageUrl; //评论图片
@property (nonatomic,strong) NSMutableArray *purchasedStylesArray; //已买弹幕样式



@end


