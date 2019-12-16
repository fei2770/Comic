//
//  CommentCollectionViewCell.m
//  Comic
//
//  Created by vision on 2019/11/21.
//  Copyright © 2019 vision. All rights reserved.
//

#import "CommentCollectionViewCell.h"

@implementation CommentCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 44, 44)];
        [self.contentView addSubview:self.contentImageView];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width-12,10, 20, 20)];
        [self.deleteBtn setImage:[UIImage imageNamed:@"comment_delete_photo"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleteBtn];
    }
    return self;
}

@end
