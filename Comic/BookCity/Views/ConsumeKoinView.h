//
//  ConsumeKoinView.h
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConsumeConfirmBlock)(NSInteger type);

@interface ConsumeKoinView : UIView

+(void)showConsumeKoinWithFrame:(CGRect)frame confirmAction:(ConsumeConfirmBlock)confrim;

@end


