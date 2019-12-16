//
//  ReplyToolBarView.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyToolBarView;
@protocol ReplyToolBarViewDelegate <NSObject>

@optional
-(void)replyToolBarViewDidShowBar:(ReplyToolBarView *)barView;

-(void)replyToolBarView:(ReplyToolBarView *)barView didSendText:(NSString *)text;

@end


@interface ReplyToolBarView : UIView

@property (nonatomic, weak ) id<ReplyToolBarViewDelegate>delegate;
@property (nonatomic,strong) UITextField  *replyTextFiled;
@property (nonatomic,assign) BOOL         noInput;

@end


