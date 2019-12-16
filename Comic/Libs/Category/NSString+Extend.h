//
//  NSString+Extend.h
//  VIFI
//
//  Created by jiangqin on 15/5/14.
//  Copyright (c) 2015年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSString (Extend)

/**
 *  md5加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)MD5;

/*
 *十六进制转十进制
 *
 *  @return 转换后的字符串
 */
-(NSString *) numberHexString;

/**
 *  url encode
 *
 *  @return 转换后的字符串
 */
- (NSString *)stringEncode;

/**
 * url decode
 *
 *  @return 转换后的字符串
 */
- (NSString *)stringDecode;

/**
 *  动态确定文本的宽高
 *
 *  @param size 宽高限制，用于计算文本绘制时占据的矩形块。
 *  @param font 字体
 *
 *  @return 文本绘制所占据的矩形空间
 */
- (CGSize)boundingRectWithSize:(CGSize)size withTextFont:(UIFont *)font;

/**
 *  base64加密
 *
 *  @return 加密后的字符串
 */
- (NSString *)base64;

/**
 *  base64解密
 *
 *  @return 解密后的字符串
 */
- (NSString *)base64Decoded;

/**
 *  邮箱验证
 *
 *  @return 是否是邮箱
 */
- (BOOL)isEmail;

/**
 *  手机号码验证
 *
 *  @return 是否是手机号码
 */
- (BOOL)isPhoneNumber;

/**
 *  身份证号验证
 *
 *  @return 是否是身份证
 */
- (BOOL)isIdentifyCard;

/**
 *
 * 判断当前是不是在使用九宫格输入
 */
-(BOOL)isNineKeyBoardInput;

/**
 *
 * 判断是否包含emoji表情
 */
-(BOOL)hasContainEmojiFace;

/**
 *
 * 判断是否包含第三方键盘表情
 */
-(BOOL)hasContainThirdKeyboardEmoji;

@end
