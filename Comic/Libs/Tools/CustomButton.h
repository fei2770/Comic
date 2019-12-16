//
//  CustomButton.h
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomButton : UIButton

@property (nonatomic, copy ) NSString  *imgName;
@property (nonatomic, copy ) NSString  *titleString;
@property (nonatomic,strong) UIColor   *textColor;
@property (nonatomic,strong) UIFont    *titleFont;

-(instancetype)initWithFrame:(CGRect)frame imgSize:(CGSize)imgSize;

@end


