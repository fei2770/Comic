//
//  ReadingFooterView.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadFooterModel.h"
#import "BannerModel.h"


@protocol ReadingFooterViewDelegate <NSObject>

//点赞、加入书架、分享
-(void)readingFooterViewClickBtnActionWithTag:(NSInteger)tag;
//上一话 下一话
-(void)readingFooterViewPageTurnActionWithTag:(NSInteger)tag;
//点击banner
-(void)readingFooterViewDidClickBanner:(BannerModel *)banner;
//点击图书
-(void)readingFooterViewDidSelectedBook:(NSNumber *)bookId;

@end

@interface ReadingFooterView : UIView

@property (nonatomic,strong) ReadFooterModel *footerModel;
@property (nonatomic, weak ) id<ReadingFooterViewDelegate>delegate;

@end


