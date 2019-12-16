//
//  MessageTableView.m
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import "MessageTableView.h"
#import "MessageTableViewCell.h"
#import "MessageModel.h"
#import "BlankView.h"

@interface MessageTableView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) BlankView  *blankView;

@end

@implementation MessageTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] init];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor colorWithHexString:@"#F6F6FA"];
        
        [self addSubview:self.blankView];
         self.blankView.hidden = YES;
    }
    return self;
}

#pragma mark UITableViewDataSource and UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messagesArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"MessageTableViewCell";
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[MessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MessageModel *model = self.messagesArray[indexPath.row];
    cell.message = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.messagesArray[indexPath.row];
    return [MessageTableViewCell getMessageCellHeightWithModel:model];
}

-(void)setMessagesArray:(NSMutableArray *)messagesArray{
    _messagesArray = messagesArray;
    self.blankView.hidden = messagesArray.count>0;
}

#pragma mark 空白页
-(BlankView *)blankView{
    if (!_blankView) {
        _blankView = [[BlankView alloc] initWithFrame:CGRectMake(0,40, kScreenWidth, 120) img:@"default_page_information" msg:@"Sementara tidak ada informasi"];
    }
    return _blankView;
}

@end
