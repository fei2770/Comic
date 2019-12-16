//
//  MemberTypeButton.h
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberTypeModel.h"

@interface MemberTypeButton : UIButton

@property (nonatomic ,strong) MemberTypeModel *typeModel;
@property (nonatomic ,assign) BOOL      is_selected;

@end


