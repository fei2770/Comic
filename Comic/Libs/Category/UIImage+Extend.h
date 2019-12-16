//
//  UIImage+Extend.h
//  SRZCommonTool
//
//  Created by vision on 16/7/21.
//  Copyright © 2016年 SRZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extend)

/**
 *  自由拉伸图片
 *
 *  @param imgName 图片名称
 *
 */
+ (UIImage *)resizedImage:(NSString *)imgName;

/**
 *  自由拉伸图片
 *
 *  @param imgName 图片名称
 *  @param xPos    左边开始位置比例 值范围0-1
 *  @param yPos    上边开始位置比例 值范围0-1
 *
 *  @return  image
 */
+ (UIImage *)resizedImage:(NSString *)imgName xPos:(CGFloat)xPos yPos:(CGFloat)yPos;

/**
 *  根据给定的大小设置图片
 *
 *  @param imgName   图片名称
 *  @param itemSize  图片大小
 *
 *  @return  image
 */
+(UIImage *)drawImageWithName:(NSString *)imgName size:(CGSize)itemSize;


/**
 *  根据颜色和大小获取Image
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return image
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/*
 *压缩图片大小
 *1）宽高均大于1280，取较大值等于1280，较大值等比例压缩
 *2）宽或高一个大于1280，取较大的等于1280，较小的等比压缩
 * 3）宽高均小于1280，压缩比例不变
 */
+(UIImage *)zipScaleWithImage:(UIImage *)sourceImage;

/*
 *压缩图片质量
 *1）图片大于1M的，将压缩系数调整到0.7
 *2）图片在0.5M<image<1M,将压缩系数调整到0.8
 *3）图片小雨0.5M，压缩系数可以写0.9或者1
 */
+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage;



/**
 *  自由改变Image的大小
 *  @param size 目的大小
 *
 *  @return 修改后的Image
 */
- (UIImage *)cropImageWithSize:(CGSize)size;

/**
 *  根据指定压缩宽度,生成等比压缩后的图片
 *
 *  @param scaleWidth 压缩宽度
 *
 *  @return 等比压缩后的图片
 */
- (UIImage *)compressWithWidth:(CGFloat)scaleWidth;

/**
 *   图片生成小缩略图保证图片不模糊
 *
 *  @param  sourceImage 原图
 *  @param  size  缩略图大小
 *  @return 压缩后的图片
 */
-(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;


/**
 * 图片绘制圆角
 *
 *  @param  radius  圆角大小
 *  @return 绘制后的图片
 *
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

/**
 *   普通视图截图
 *
 *   @param view 当前要截取的视图
 *   @return 压缩后的图片
 *
 */
+(UIImage *)snapshotForView:(UIView *)view;

/**
 *   滚动视图截图
 *
 *   @param scrollView 当前要截取的滚动视图
 *   @return 压缩后的图片
 *
 */
+(UIImage *)snapshotForScrollView:(UIScrollView *)scrollView;

/**
 *
 *   视图转换成图片
 *   @param  view  要转换的视图
 *   @param  size  要转换的大小
 *   @return 转换后的图片
 */

+ (UIImage *)makeImageWithView:(UIView *)view withSize:(CGSize)size;

/**
 *   图片模糊
 *
 *   @param  image 要模糊的图片
 *   @param  blur  模糊程度
 *   @return 模糊后的图片
 *
 */
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

/**
 *获取视频第一帧
 *@return 模糊后的图片
 */
+ (UIImage*)getVideoPreViewImage:(NSURL *)videoUrl;
 

@end
