//
//  BookShelfCollectionView.m
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import "BookShelfCollectionView.h"
#import "BookCollectionViewCell.h"

#define kImageW (kScreenWidth-50)/2.0

@interface BookShelfCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>



@end

@implementation BookShelfCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.scrollEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:@"BookCollectionViewCell"];
        self.dataSource = self;
        self.delegate = self;
        
    }
    return self;
}

#pragma mark -- UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.booksArray.count+1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row==self.booksArray.count) {
        cell.myImgView.image = [UIImage imageNamed:@"bookshelf_find_more"];
        cell.nameLabel.hidden = cell.descLabel.hidden = cell.likeBtn.hidden = cell.commentBtn.hidden = cell.timeLabel.hidden = YES;
    }else{
        ShelfBookModel *book = self.booksArray[indexPath.row];
        [cell displayCellWithBookModel:book isEditing:NO];
        cell.nameLabel.hidden = cell.descLabel.hidden = cell.likeBtn.hidden = cell.commentBtn.hidden = cell.timeLabel.hidden = NO;
        
        cell.myImgView.userInteractionEnabled = YES;
        cell.myImgView.tag = indexPath.row;
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGetrureAction:)];
        [cell.myImgView addGestureRecognizer:gesture];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.booksArray.count) {
        if ([self.viewDeletage respondsToSelector:@selector(bookShelfCollectionViewGetMoreBooks)]) {
            [self.viewDeletage bookShelfCollectionViewGetMoreBooks];
        }
    }else{
        ShelfBookModel *book = self.booksArray[indexPath.row];
        if ([self.viewDeletage respondsToSelector:@selector(bookShelfCollectionViewDidSelectBook:)]) {
            [self.viewDeletage bookShelfCollectionViewDidSelectBook:book];
        }
    }
}

-(void)setBooksArray:(NSMutableArray *)booksArray{
    _booksArray = booksArray;
    [self reloadData];
}


#pragma mark 长按
-(void)longGetrureAction:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state==UIGestureRecognizerStateEnded) {
        if ([self.viewDeletage respondsToSelector:@selector(bookShelfCollectionViewLongPressGesutre)]) {
            [self.viewDeletage bookShelfCollectionViewLongPressGesutre];
        }
    }
}

@end
