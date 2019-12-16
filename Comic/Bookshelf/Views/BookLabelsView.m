//
//  BookLabelsView.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookLabelsView.h"

@implementation BookLabelsView

#pragma mark 标签数组
-(void)setLabelsArray:(NSArray *)labelsArray{
    _labelsArray = labelsArray;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat tempItemW = 0.0;
    for (NSInteger i = 0; i < labelsArray.count; i ++) {
        NSString *value = [labelsArray objectAtIndex:i];
        CGFloat itemW = [value boundingRectWithSize:CGSizeMake(kScreenWidth, 20) withTextFont:[UIFont regularFontWithSize:13]].width+20;
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(tempItemW, 0, itemW, 20)];
        lab.textColor = [UIColor whiteColor];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont regularFontWithSize:13];
        lab.text = value;
        lab.layer.cornerRadius = 10;
        lab.layer.borderColor = [UIColor whiteColor].CGColor;
        lab.layer.borderWidth = 1.0;
        [self addSubview:lab];
        
        tempItemW += itemW+10;
    }
}

@end
