//
//  ReadCateCollectionView.m
//  Comic
//
//  Created by vision on 2019/11/22.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadCateCollectionView.h"
#import "ReadCateCollectionViewCell.h"
#import "ReadCateModel.h"

@interface ReadCateCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    BOOL  isChoosing;
}

@end

@implementation ReadCateCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self registerClass:[ReadCateCollectionViewCell class] forCellWithReuseIdentifier:@"ReadCateCollectionViewCell"];
        self.dataSource = self;
        self.delegate = self;
        
    }
    return self;
}

#pragma mark -- UICollectionViewDataSource and UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.channelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadCateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ReadCateCollectionViewCell" forIndexPath:indexPath];
    ReadCateModel *model = self.channelArray[indexPath.row];
    cell.cateModel = model;
    cell.textColor = self.textColor;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadCateModel *model = self.channelArray[indexPath.row];
    if ([model.is_selected boolValue]) {
        if (self.selectedChannelIdsArray.count==1) {
             [kKeyWindow makeToast:@"Pilihlah paling sedikit satu genre" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        model.is_selected = [NSNumber numberWithBool:NO];
    }else{
        if (self.selectedChannelIdsArray.count==3) {
            [kKeyWindow makeToast:@"Paling banyak hanya bisa 3 genre" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        model.is_selected = [NSNumber numberWithBool:YES];
    }
    [self reloadData];
    
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (ReadCateModel *model in self.channelArray) {
        if ([model.is_selected boolValue]) {
            [tempArr addObject:model.type_id];
        }
    }
    self.selectedChannelIdsArray = tempArr;
    if ([self.viewDelegate respondsToSelector:@selector(readCateCollectionViewDidChooseChannels:)]) {
        [self.viewDelegate readCateCollectionViewDidChooseChannels:self.selectedChannelIdsArray];
    }
}

#pragma mark -- Setters
-(void)setChannelArray:(NSMutableArray *)channelArray{
    _channelArray = channelArray;
    [self reloadData];
}

-(void)setSelectedChannelIdsArray:(NSMutableArray *)selectedChannelIdsArray{
    _selectedChannelIdsArray = selectedChannelIdsArray;
}

-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
}



@end
