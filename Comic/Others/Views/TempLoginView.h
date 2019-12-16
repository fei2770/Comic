//
//  TempLoginView.h
//  Comic
//
//  Created by vision on 2019/12/5.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TempLoginView;
@protocol TempLoginViewDelegate <NSObject>

//account login
-(void)tempLoginViewDidAccountLogin:(TempLoginView *)tempLoginview account:(NSString*)account password:(NSString *)password;
//google login or facebook login
-(void)tempLoginViewDidThirdLogin:(TempLoginView *)tempLoginview tag:(NSInteger)tag;

@end


@interface TempLoginView : UIView

@property (nonatomic, weak ) id<TempLoginViewDelegate>delegate;


@end


