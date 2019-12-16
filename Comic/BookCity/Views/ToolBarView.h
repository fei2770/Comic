//
//  ToolBarView.h
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarViewDelegate <NSObject>

//开启或关闭弹幕
-(void)toolBarViewSetBarrageOpen:(BOOL)isOpen;
//评论或者弹幕
-(void)toolBarViewStartEditWithType:(NSInteger)type; //type 0弹幕 1评论
//上一话 下一话
-(void)toolBarViewShowBookNewChapterWithTag:(NSInteger)tag;
//目录 评论 分享 设置
-(void)toolBarViewHandleEventWithTag:(NSInteger)tag;

@end


@interface ToolBarView : UIView

@property (nonatomic, weak ) id<ToolBarViewDelegate>delegate;
@property (nonatomic,assign) NSInteger commentCount; //评论数


@end


