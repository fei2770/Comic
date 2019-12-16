//
//  CommentCollectionView.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentCollectionView.h"
#import "CommentCollectionViewCell.h"

@interface CommentCollectionViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation CommentCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor  = [UIColor colorWithHexString:@"#F3F4F7"];
        [self registerClass:[CommentCollectionViewCell class] forCellWithReuseIdentifier:@"CommentCollectionViewCell"];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
 
#pragma mark UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photosArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CommentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CommentCollectionViewCell" forIndexPath:indexPath];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.photosArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deletePhotoAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


-(void)setPhotosArray:(NSMutableArray *)photosArray{
    _photosArray = photosArray;
    [self reloadData];
}

#pragma mark -- Event response
-(void)deletePhotoAction:(UIButton *)sender{
    MyLog(@"deletePhotoAction:%ld",sender.tag);
    if ([self.viewDelegate respondsToSelector:@selector(commentCollectionView:didDeletePhoto:)]) {
        [self.viewDelegate commentCollectionView:self didDeletePhoto:sender.tag];
    }
}

@end
