//
//  PurchaseToastView.h
//  Comic
//
//  Created by vision on 2019/12/4.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonClickBlock)(NSInteger tag);

@interface PurchaseToastView : UIView

+(void)showConsumeKoinWithFrame:(CGRect)frame content:(NSString *)content clickAction:(ButtonClickBlock)clickBlock;

@end

