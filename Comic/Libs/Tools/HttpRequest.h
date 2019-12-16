//
//  HttpRequest.h
//  HomeworkForTeacher
//
//  Created by vision on 2019/9/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UploadParam;


@interface HttpRequest : NSObject

+ (instancetype)sharedInstance;

/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param showLoading 是否显示加载
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *)URLString showLoading:(BOOL)showLoading  parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorStr))failure;


- (void)tempPostWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorStr))failure;

/**
 *  上传文件
 *
 *  @param URLString   上传文件的网址字符串
 *  @param parameters  上传文件的参数
 *  @param uploadParams 上传文件的信息
 *  @param success     上传成功的回调
 *  @param failure    请求失败的回调
 */
- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(NSArray <UploadParam *> *)uploadParams success:(void (^)(id responseObject))success failure:(void (^)(NSString *errorStr))failure;


/**
 *  下载数据
 *
 *  @param URLString   下载数据的网址
 *  @param parameters  下载数据的参数
 *  @param success     下载成功的回调
 *  @param failure     下载失败的回调
 */
- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)(void))progress success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


+(void)signOut;

@end
