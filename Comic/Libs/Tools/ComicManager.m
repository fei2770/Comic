//
//  ComicManager.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "ComicManager.h"
#import "SDImageCache.h"
#import "APPInfoManager.h"
#import "FooterBookModel.h"

@implementation ComicManager

singleton_implementation(ComicManager)

-(void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
    if (isLogin) {
        self.isMineReload = self.isBookShelfLoad = self.isReadDetailsLoad = self.isBookDetailsLoad = self.isCommentLoad = self.isCommentDetailsLoad = YES;
    }
}

-(NSArray *)barrageTypesArray{
    return @[@{@"type":@1,@"begin_icon":@"Imut_1",@"end_icon":@"Imut_2",@"begin_color":@"#FFAFA8",@"end_color":@"#FF99FB",@"vip":@YES},@{@"type":@2,@"begin_icon":@"anakrusa_1",@"end_icon":@"anakrusa_2",@"begin_color":@"#35EEAE",@"end_color":@"#00D5DD",@"vip":@YES},@{@"type":@3,@"begin_icon":@"anjing_1",@"end_icon":@"anjing_2",@"begin_color":@"#FF7C5B",@"end_color":@"#FFB25F",@"vip":@NO},@{@"type":@4,@"begin_icon":@"kaisar_1",@"end_icon":@"kaisar_2",@"begin_color":@"#EBC9A4",@"end_color":@"#BD9E78",@"vip":@YES},@{@"type":@5,@"begin_icon":@"kucing_1",@"end_icon":@"kucing_2",@"begin_color":@"#FFDB00",@"end_color":@"#FFAA00",@"vip":@NO}];
}

#pragma mark 是否登录
+(BOOL)hasSignIn{
    NSString *token = [NSUserDefaultsInfos getValueforKey:kUserToken];
    BOOL isLogin = [[NSUserDefaultsInfos getValueforKey:kIsLogin] boolValue];
    return isLogin&&!kIsEmptyString(token);
}


#pragma mark 加载推荐书籍数据
-(void)loadRecommandBooksData{
    NSDictionary *params;
    NSNumber *gender = [NSUserDefaultsInfos getValueforKey:kUserGenderPreference];
    NSArray *types = [NSUserDefaultsInfos getValueforKey:kUserChannelPreference];
    if ([gender integerValue]>0&&types.count>0) {
        NSString *typeStr = [[ComicManager sharedComicManager] getValueWithParams:types];
        params = @{@"channel":gender,@"book_type":typeStr};
    }else{
        NSArray *arr = @[@1];
        NSString *str = [[ComicManager sharedComicManager] getValueWithParams:arr];
        params = @{@"channel":@1,@"book_type":str};
    }
    [[HttpRequest sharedInstance] postWithURLString:kRecommandBooksAPI showLoading:NO parameters:params success:^(id responseObject) {
        NSArray *data = [responseObject objectForKey:@"data"];
        if (kIsArray(data)&&data.count>0) {
            NSMutableArray *tempArr = [[NSMutableArray alloc] init];
            for (NSDictionary *dict in data) {
                FooterBookModel *model = [[FooterBookModel alloc] init];
                [model setValues:dict];
                [tempArr addObject:model];
            }
            self.recommandBooksArray = tempArr;
        }
    } failure:^(NSString *errorStr) {
        MyLog(@"接口：%@， 请求失败---error:%@",kRecommandBooksAPI,errorStr);
    }];
}

#pragma mark 时间戳转化为时间
- (NSString *)timeWithTimeIntervalNumber:(NSNumber *)timeNum format:(NSString *)format{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeNum integerValue]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

#pragma mark 将某个时间转化成 时间戳
-(NSNumber *)timeSwitchTimestamp:(NSString *)formatTime format:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime];    //将字符串按formatter转成nsdate
    return [NSNumber numberWithDouble:[date timeIntervalSince1970]];
}

#pragma mark 获取缓存数据
- (CGFloat)getTotalCacheSize{
    NSUInteger imageCacheSize = [[SDImageCache sharedImageCache] totalDiskSize];
    //获取自定义缓存大小
    //用枚举器遍历 一个文件夹的内容
    //1.获取 文件夹枚举器
    NSString *myCachePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:myCachePath];
    __block NSUInteger count = 0;
    //2.遍历
    for (NSString *fileName in enumerator) {
        NSString *path = [myCachePath stringByAppendingPathComponent:fileName];
        NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
        count += fileDict.fileSize;//自定义所有缓存大小
    }
    // 得到是字节  转化为M
    CGFloat totalSize = ((CGFloat)imageCacheSize+count)/1024/1024;
    return totalSize;
}

#pragma mark --其他数据转json数据
-(NSString *)getValueWithParams:(id)params{
    NSData *data=[NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     //去除空格和回车：
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    MyLog(@"jsonStr:%@",jsonStr);
    return jsonStr;
}

#pragma mark 对图片base64加密
- (NSMutableArray *)imageDataProcessingWithImgArray:(NSMutableArray *)imgArray{
    NSMutableArray *photoArray = [NSMutableArray array];
    for (NSInteger i = 0; i < imgArray.count; i++) {
        NSData *imageData = [UIImage zipNSDataWithImage:imgArray[i]];
        //将图片数据转化为64为加密字符串
        NSString *encodeResult = [imageData base64EncodedStringWithOptions:0];
        [photoArray addObject:encodeResult];
    }
    return photoArray;
}

#pragma mark -- 限制emoji表情输入
-(BOOL)strIsContainEmojiWithStr:(NSString*)str{
    __block BOOL returnValue =NO;
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         const unichar hs = [substring characterAtIndex:0];
         if(0xd800<= hs && hs <=0xdbff){
             if(substring.length>1){
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs -0xd800) *0x400) + (ls -0xdc00) +0x10000;
                 if(0x1d000<= uc && uc <=0x1f77f){
                     returnValue =YES;
                 }
             }
         }else if(substring.length>1){
             const unichar ls = [substring characterAtIndex:1];
             if(ls ==0x20e3)
             {
                 returnValue =YES;
             }
         }else{
             // non surrogate
             if(0x2100<= hs && hs <=0x27ff&& hs !=0x263b)
             {
                 returnValue =YES;
             }
             else if(0x2B05<= hs && hs <=0x2b07)
             {
                 returnValue =YES;
             }
             else if(0x2934<= hs && hs <=0x2935)
             {
                 returnValue =YES;
             }
             else if(0x3297<= hs && hs <=0x3299)
             {
                 returnValue =YES;
             }
             else if(hs ==0xa9|| hs ==0xae|| hs ==0x303d|| hs ==0x3030|| hs ==0x2b55|| hs ==0x2b1c|| hs ==0x2b1b|| hs ==0x2b50|| hs ==0x231a)
             {
                 returnValue =YES;
             }
         }
     }];
    return returnValue;
}
#pragma mark -- 限制第三方键盘（常用的是搜狗键盘）的表情
- (BOOL)hasEmoji:(NSString*)string{
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

#pragma mark -- 判断当前是不是在使用九宫格输入
-(BOOL)isNineKeyBoard:(NSString *)string{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++)
    {
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}

@end
