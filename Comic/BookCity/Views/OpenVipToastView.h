//
//  OpenVipToastView.h
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmBlock)(void);

@interface OpenVipToastView : UIView

+(void)showOpenVipToastWithFrame:(CGRect)frame confirmAction:(ConfirmBlock)confrim;

@end


