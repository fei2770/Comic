//
//  ChooseGenderView.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureGenderBlock)(NSInteger gender);


@interface ChooseGenderView : UIView

@property (nonatomic, copy) SureGenderBlock sureBlock;

@end


