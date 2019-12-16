//
//  DetailHeaderView.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookModel.h"

@protocol DetailHeaderViewDelegate <NSObject>

//加入书架
-(void)detailHeaderViewDidAddToBookShelf;

@end

@interface DetailHeaderView : UIView

@property (nonatomic,strong) BookModel *bookModel;
@property (nonatomic, weak ) id<DetailHeaderViewDelegate>delegate;

@end


