//
//  BookTagsView.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookTagsView.h"

@implementation BookTagsView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

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
        UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(tempItemW, 0, itemW, 20)];
        item.backgroundColor = [UIColor colorWithHexString:@"#E2E2FF"];
        item.textColor = [UIColor colorWithHexString:@"#946EFF"];
        item.textAlignment = NSTextAlignmentCenter;
        item.font = [UIFont regularFontWithSize:13];
        item.text = value;
        [item setBorderWithCornerRadius:10 type:UIViewCornerTypeAll];
        [self addSubview:item];
        
        tempItemW += itemW+10;
    }
}

@end
