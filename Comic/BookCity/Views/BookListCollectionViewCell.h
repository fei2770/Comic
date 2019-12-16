//
//  BookListCollectionViewCell.h
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSelectionModel.h"

@interface BookListCollectionViewCell : UICollectionViewCell


-(void)displaySelectionCellWithModel:(BookSelectionModel *)selectionModel vipCost:(NSInteger)vipCost;

@end

