//
//  ReadCateCollectionViewCell.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadCateModel.h"


@interface ReadCateCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,strong) ReadCateModel *cateModel;


@end


