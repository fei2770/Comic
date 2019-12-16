//
//  BuyRecordsTableViewCell.h
//  Comic
//
//  Created by vision on 2019/12/12.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyBookModel.h"


@interface BuyRecordsTableViewCell : UITableViewCell

-(void)reloadCellWithModel:(BuyBookModel *)model;


@end


