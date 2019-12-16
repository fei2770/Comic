//
//  FooterRecommandView.h
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FooterBookModel.h"

@protocol FooterRecommandViewDelegate <NSObject>

-(void)footerRecommandViewDidSelectedBook:(FooterBookModel *)bookModel;

@end

@interface FooterRecommandView : UIView

@property (nonatomic, weak ) id<FooterRecommandViewDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *booksArray;

-(instancetype)initWithFrame:(CGRect)frame isRecommanded:(BOOL)isRecommanded;

@end


