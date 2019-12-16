//
//  SelectionTableView.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "SelectionTableView.h"
#import "SelectionTableViewCell.h"

@interface SelectionTableView ()<UITableViewDelegate,UITableViewDataSource>{
    BOOL  isSelected;
}

@end

@implementation SelectionTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.tableFooterView = [[UIView alloc] init];
        self.showsVerticalScrollIndicator = NO;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        isSelected = NO;
    }
    return self;
}

#pragma mark -- UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.selectionsArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    aView.backgroundColor = [UIColor whiteColor];
    
    UIButton *sortBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-122, 5, 100, 30)];
    [sortBtn setTitle:@"Urutan positif" forState:UIControlStateNormal];
    [sortBtn setTitle:@"Urutan terbalik" forState:UIControlStateSelected];
    [sortBtn setTitleColor:[UIColor colorWithHexString:@"#808080"] forState:UIControlStateNormal];
    sortBtn.titleLabel.font = [UIFont regularFontWithSize:14];
    [sortBtn setImage:[UIImage imageNamed:@"list_positive_sequence"] forState:UIControlStateNormal];
    [sortBtn setImage:[UIImage imageNamed:@"list_inverted_order"] forState:UIControlStateSelected];
    sortBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -54, 0, 0);
    sortBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
    [sortBtn addTarget:self action:@selector(sortSelectionsAction:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:sortBtn];
    
    return aView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdenditifier = @"SelectionTableViewCell";
    SelectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenditifier];
    if (cell==nil) {
        cell = [[SelectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdenditifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BookSelectionModel *model = self.selectionsArray[indexPath.row];
    [cell displayCellWithModel:model vipCost:self.vipCost];
    
    cell.likeBtn.tag = indexPath.row;
    [cell.likeBtn addTarget:self action:@selector(likeBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BookSelectionModel *model = self.selectionsArray[indexPath.row];
    if ([self.viewDelegate respondsToSelector:@selector(selectionTableViewDidSelectedCellWithModel:)]) {
        [self.viewDelegate selectionTableViewDidSelectedCellWithModel:model];
    }
}

-(void)setSelectionsArray:(NSMutableArray *)selectionsArray{
    _selectionsArray = selectionsArray;
    [self reloadData];
}

-(void)setVipCost:(NSInteger)vipCost{
    _vipCost = vipCost;
}

-(void)sortSelectionsAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    isSelected = !isSelected;
    NSString *type = nil;
    if (isSelected) {
        type = @"desc";
    }else{
        type = @"asc";
    }
    if ([self.viewDelegate respondsToSelector:@selector(selectionTableViewSortByOrder:)]) {
        [self.viewDelegate selectionTableViewSortByOrder:type];
    }
}


#pragma mark 点赞
-(void)likeBtnClickAction:(UIButton *)sender{
    BookSelectionModel *model = self.selectionsArray[sender.tag];
    model.is_like = [NSNumber numberWithBool:YES];
    NSInteger likeCount = [model.like integerValue];
    likeCount ++;
    model.like = [NSNumber numberWithInteger:likeCount];
    [self reloadData];
    
    if ([self.viewDelegate respondsToSelector:@selector(selectionTableViewDidClickLikeWithSelectionId:)]) {
        [self.viewDelegate selectionTableViewDidClickLikeWithSelectionId:model.catalogue_id];
    }
    
}


@end
