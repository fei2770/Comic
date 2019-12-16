//
//  BookShelfCollectionView.h
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShelfBookModel.h"

@protocol BookShelfCollectionViewDelegate <NSObject>

//选择书
-(void)bookShelfCollectionViewDidSelectBook:(ShelfBookModel *)book;
//获取更多书
-(void)bookShelfCollectionViewGetMoreBooks;
//长按
-(void)bookShelfCollectionViewLongPressGesutre;

@end


@interface BookShelfCollectionView : UICollectionView

@property (nonatomic,strong) NSMutableArray *booksArray;
@property (nonatomic, weak ) id<BookShelfCollectionViewDelegate>viewDeletage;

@end

