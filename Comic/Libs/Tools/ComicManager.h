//
//  ComicManager.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ComicManager : NSObject

singleton_interface(ComicManager)

@property (nonatomic,assign) BOOL    isLogin;
@property (nonatomic,assign) BOOL    isMineReload;
@property (nonatomic,assign) BOOL    isMessagesReload;
@property (nonatomic,assign) BOOL    isBookShelfLoad;
@property (nonatomic,assign) BOOL    isReadDetailsLoad;
@property (nonatomic,assign) BOOL    isBookDetailsLoad;
@property (nonatomic,assign) BOOL    isBookSelectionsLoad;
@property (nonatomic,assign) BOOL    isCommentLoad;
@property (nonatomic,assign) BOOL    isCommentDetailsLoad;

@property (nonatomic, copy ) NSArray *comicTypesArray;

@property (nonatomic, copy ) NSArray *barrageTypesArray;

@property (nonatomic,strong) NSMutableArray *recommandBooksArray;

/**
*@bref 是否登录
*/
+(BOOL)hasSignIn;

/**
*@bref 加载推荐书籍数据
*/
-(void)loadRecommandBooksData;

/**
 *@bref 时间戳转化为时间
 */
- (NSString *)timeWithTimeIntervalNumber:(NSNumber *)timeNum format:(NSString *)format;

/**
 *@bref 将某个时间转化成 时间戳
 */
-(NSNumber *)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format;

/**
* 获取缓存数据
*/
- (CGFloat)getTotalCacheSize;

/**
 *@bref 其他数据转json数据
 */
-(NSString *)getValueWithParams:(id)params;

/*
 *@bref 对图片base64加密
 */
- (NSMutableArray *)imageDataProcessingWithImgArray:(NSMutableArray *)imgArray;


/***
 * @bref  限制emoji表情输入
 */
-(BOOL)strIsContainEmojiWithStr:(NSString*)str;
/***
 * @bref  限制第三方键盘（常用的是搜狗键盘）的表情
 */
- (BOOL)hasEmoji:(NSString*)string;

-(BOOL)isNineKeyBoard:(NSString *)string;

/*
//分享好友
-(void)shareToOtherUsersFromController:(UIViewController *)controller;
 */

@end

