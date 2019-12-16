//
//  BarrageTypeView.h
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageTypeView : UIView

@property (nonatomic,strong) NSDictionary   *typeDict;
@property (nonatomic,assign) NSInteger      pay_type;
@property (nonatomic, copy ) NSString       *contentText;
@property (nonatomic,assign) BOOL           canMove;

@end


