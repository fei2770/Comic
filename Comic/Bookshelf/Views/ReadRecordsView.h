//
//  ReadRecordsView.h
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookRecordModel.h"
#import "CustomButton.h"

@interface ReadRecordsView : UIView

@property (nonatomic,strong) UIButton      *contineBtn;  //继续阅读
@property (nonatomic,strong) CustomButton  *recordBtn;   //阅读记录

@property (nonatomic,strong) BookRecordModel  *recordModel;

@end

