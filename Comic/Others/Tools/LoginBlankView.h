//
//  LoginBlankView.h
//  Comic
//
//  Created by vision on 2019/11/26.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoginBlock)(void);

@interface LoginBlankView : UIView

@property (nonatomic,copy) LoginBlock loginBlock;



@end


