//
//  BlankView.m
//  HWForTeacher
//
//  Created by vision on 2019/9/29.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BlankView.h"

@implementation BlankView

-(instancetype)initWithFrame:(CGRect)frame img:(NSString *)imgName msg:(NSString *)msg{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView=[[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-58)/2,40, 58, 48)];
        imgView.image=[UIImage imageNamed:imgName];
        [self addSubview:imgView];
        
        UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake((kScreenWidth-160)/2.0, imgView.bottom+15, 160, 50)];
        lab.textAlignment=NSTextAlignmentCenter;
        lab.text=msg;
        lab.numberOfLines = 0;
        lab.font=[UIFont regularFontWithSize:16.0f];
        lab.textColor=[UIColor colorWithHexString:@"#8981B3"];
        [self addSubview:lab];
    }
    return self;
}

@end
