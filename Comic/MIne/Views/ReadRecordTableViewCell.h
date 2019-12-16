//
//  ReadRecordTableViewCell.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRecordModel.h"

@interface ReadRecordTableViewCell : UITableViewCell


-(void)reloadCellWithObject:(BookRecordModel *)recordModel;

@end


