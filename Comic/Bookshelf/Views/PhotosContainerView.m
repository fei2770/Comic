//
//  PhotosContainerView.m
//  Comic
//
//  Created by vision on 2019/12/6.
//  Copyright © 2019 vision. All rights reserved.
//

#import "PhotosContainerView.h"
#import "SDPhotoBrowser.h"

#define kImgHeight (kScreenWidth-84-2*10)/3.0

@interface PhotosContainerView ()<SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *imageViewsArray;

@end

@implementation PhotosContainerView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

#pragma mark 初始化
- (void)setup{
    NSMutableArray *tempArr = [NSMutableArray new];
    for (int i = 0; i < 9; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        
        [tempArr addObject:imageView];
    }
    
    self.imageViewsArray = [tempArr copy];
}


-(void)setPicUrlsArray:(NSMutableArray *)picUrlsArray{
    _picUrlsArray = picUrlsArray;
    
    for (NSInteger i = picUrlsArray.count; i < self.imageViewsArray.count; i++) {
        UIImageView *imageView = [self.imageViewsArray objectAtIndex:i];
        imageView.hidden = YES;
    }
    
    if (picUrlsArray.count==0) {
        return;
    }
    
    if (picUrlsArray.count==1) {
        UIImageView *imageView = self.imageViewsArray[0];
        [imageView sd_setImageWithURL:[NSURL URLWithString:picUrlsArray[0]] placeholderImage:[UIImage imageNamed:@"default_graph_2"]];
        imageView.frame = CGRectMake(0, 0, 120, 85);
    }else{
        for (NSInteger i=0; i<picUrlsArray.count; i++) {
            UIImageView *imageView = self.imageViewsArray[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:picUrlsArray[i]] placeholderImage:[UIImage imageNamed:@"default_graph_1"]];
            imageView.frame = CGRectMake((i%3)*(kImgHeight+10), (i/3)*(kImgHeight+10), kImgHeight, kImgHeight);
        }
    }
}


#pragma mark - SDPhotoBrowserDelegate
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    NSString *picUrl = self.picUrlsArray[index];
    return [NSURL URLWithString:picUrl];
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    UIImageView *imageView = self.subviews[index];
    return imageView.image;
}

#pragma mark -- Event response
#pragma mark 查看大图
- (void)tapImageView:(UITapGestureRecognizer *)tap{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.picUrlsArray.count;
    browser.delegate = self;
    browser.canScroll = YES;
    [browser show];
}



@end
