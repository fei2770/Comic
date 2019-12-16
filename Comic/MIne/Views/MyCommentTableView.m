//
//  MyCommentTableView.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MyCommentTableView.h"
#import "MyCommentTableViewCell.h"
#import "MyCommentModel.h"
#import "CommentTool.h"
#import "BlankView.h"

@interface MyCommentTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) BlankView  *blankView;


@end

@implementation MyCommentTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.blankView];
        self.blankView.hidden = YES;
    }
    return self;
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myCommentsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MyCommentTableViewCell";
    MyCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[MyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyCommentModel *model = self.myCommentsArray[indexPath.row];
    cell.commentModel = model;
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteMyCommentAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCommentModel *model = self.myCommentsArray[indexPath.row];
    return [CommentTool getMyCommentCellHeightWithModel:model];
}

-(void)setMyCommentsArray:(NSMutableArray *)myCommentsArray{
    _myCommentsArray = myCommentsArray;
    self.blankView.hidden = myCommentsArray.count>0;
}

#pragma mark - Event response
-(void)deleteMyCommentAction:(UIButton *)sender{
    MyCommentModel *model = self.myCommentsArray[sender.tag];
    if ([self.viewDelegate respondsToSelector:@selector(myCommentTableViewDidDeleteMyComment:)]) {
        [self.viewDelegate myCommentTableViewDidDeleteMyComment:model];
    }
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,40, kScreenWidth, 120) img:@"default_page_information" msg:@"Sementara tidak ada informasi"];
    }
    return _blankView;
}

@end
