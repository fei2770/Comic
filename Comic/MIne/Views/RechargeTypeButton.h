//
//  RechargeTypeBtn.h
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KoinTypeModel.h"


@interface RechargeTypeButton : UIButton

@property (nonatomic,strong) KoinTypeModel *typeModel;
@property (nonatomic ,assign) BOOL      is_selected;


@end


