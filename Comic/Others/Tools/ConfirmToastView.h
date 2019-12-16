//
//  ConfirmToastView.h
//  Teasing
//
//  Created by vision on 2019/5/30.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^SureBlock)(void);
typedef void(^CancelBlock)(void);

@interface ConfirmToastView : UIView

+(void)showConfirmToastWithFrame:(CGRect)frame message:(NSString *)message sureBlock:(SureBlock)sureBlock cancelBlock:(CancelBlock)cancelBlock;


@end

