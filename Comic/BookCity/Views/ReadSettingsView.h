//
//  ReadSettingsView.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ReadSettingsViewDelegate <NSObject>

//更多设置
@optional
-(void)readSettingsViewDidMoreSettings;

//设置成功回调
-(void)readSettingsViewDidSetSuccess;

@end

@interface ReadSettingsView : UIView

@property (nonatomic, weak ) id<ReadSettingsViewDelegate>delegate;
@property (nonatomic,assign) BOOL noMore;

-(void)reloadSettingsInfo;

@end

