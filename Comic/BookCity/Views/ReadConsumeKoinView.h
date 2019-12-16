//
//  ReadConsumeKoinView.h
//  Comic
//
//  Created by vision on 2019/11/28.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConsumeConfirmBlock)(void);
typedef void(^CancelBlock)(void);

@interface ReadConsumeKoinView : UIView


+(void)showConsumeKoinWithFrame:(CGRect)frame costKoin:(NSInteger)costKoin vipCoin:(NSInteger)vipCoin isPaying:(BOOL)isPaying confirmAction:(ConsumeConfirmBlock)confrim cancelAction:(CancelBlock)cancelBlock;

@end

