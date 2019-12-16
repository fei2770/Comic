//
//  ReadingTableViewCell.m
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ReadingTableViewCell.h"
#import <UIImage+GIF.h>
#import <SVProgressHUD.h>

@interface ReadingTableViewCell ()

@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UIImageView *gifImageView;

@end

@implementation ReadingTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.gifImageView];
        self.gifImageView.hidden = YES;
    }
    return self;
}

-(UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imgView.backgroundColor = [UIColor colorWithHexString:@"2B2B2B"];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imgView;
}

-(UIImageView *)gifImageView{
    if (!_gifImageView) {
        _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,187, 221)];
        _gifImageView.animationImages = [self getGifImages];
        _gifImageView.animationDuration = 1.3;
    }
    return _gifImageView;
}

-(void)setCatalogueModel:(CatalogueModel *)catalogueModel{
    _catalogueModel = catalogueModel;

    CGFloat imgW = [catalogueModel.width floatValue];
    CGFloat imgH = [catalogueModel.height floatValue];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:catalogueModel.url] placeholderImage:[UIImage imageNamed:@""] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        //显示进度，receivedSize已下载数据大小 expectedSize总数据大小
        float currentProgress = (float)receivedSize/(float)expectedSize;
        MyLog(@"currentProgress:%.f, receivedSize:%ld,expectedSize:%ld",currentProgress,(long)receivedSize,(long)expectedSize);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gifImageView.hidden = NO;
            self.gifImageView.frame = CGRectMake((kScreenWidth-187)/2.0, (kScreenHeight-221)/2.0,187, 221);
            [self.gifImageView startAnimating];
        });
    } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        MyLog(@"加载完成");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.gifImageView stopAnimating];
            self.gifImageView.hidden = YES;
        });
    }];
    self.imgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*(imgH/imgW));
}


-(NSMutableArray *)getGifImages{
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"read_loading" withExtension:@"gif"];
    //将GIF图片转换成对应的图片源
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);
    //获取其中图片源个数，即由多少帧图片组成
    size_t imageCount = CGImageSourceGetCount(gifSource);
    //定义数组存储拆分出来的图片
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (size_t i = 0; i < imageCount; i++) {
        //从GIF图片中取出源图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];
        [images addObject:imageName];
        CGImageRelease(imageRef);
    }
    return images;
}

@end
