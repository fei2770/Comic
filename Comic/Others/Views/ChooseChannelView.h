//
//  ChooseChannelView.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SureChannelsBlock)(NSArray *channls);

@interface ChooseChannelView : UIView

@property (nonatomic, copy) SureChannelsBlock sureBlock;

@end

