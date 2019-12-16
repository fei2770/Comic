//
//  MessageMenuView.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageMenuViewDelegate <NSObject>

-(void)messageMenuViewDidClickItemWithIndex:(NSInteger)index;

@end


@interface MessageMenuView : UIView

@property (nonatomic, weak ) id<MessageMenuViewDelegate>delegate;

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end

