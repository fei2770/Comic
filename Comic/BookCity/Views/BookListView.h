//
//  BookListView.h
//  Comic
//
//  Created by vision on 2019/11/20.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookSelectionModel.h"

@protocol BookListViewDelegate <NSObject>

-(void)bookListViewDidChooseSelection:(BookSelectionModel *)selectionModel;

@end

@interface BookListView : UIView

@property (nonatomic,assign) NSInteger  vipCost;
@property (nonatomic,strong) NSMutableArray  *listArray;
@property (nonatomic,strong) NSNumber        *currentcatalogueId;
@property (nonatomic, weak ) id<BookListViewDelegate>viewDelegate;
@property (nonatomic, copy ) NSString        *progressString;

@end


