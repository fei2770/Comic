//
//  BookCollectionViewCell.h
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfBookModel.h"


@interface BookCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *myImgView;
@property (nonatomic,strong) UILabel     *nameLabel;
@property (nonatomic,strong) UILabel     *descLabel;
@property (nonatomic,strong) UILabel     *timeLabel;
@property (nonatomic,strong) UIButton    *likeBtn;
@property (nonatomic,strong) UIButton    *commentBtn;


-(void)displayCellWithBookModel:(ShelfBookModel *)bookModel isEditing:(BOOL)isEditing;

@end


