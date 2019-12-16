//
//  HttpRequest.m
//  HomeworkForTeacher
//
//  Created by vision on 2019/9/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import "HttpRequest.h"
#import "UploadParam.h"
#import "UIDevice+Extend.h"
#import "SVProgressHUD.h"
#import "AFNetworking.h"
#import "APPInfoManager.h"
#import "GoogleLoginManager.h"

@implementation HttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 位置网络
                    MyLog(@"位置网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    MyLog(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // WIFI
                    MyLog(@"当前在WIFI网络下");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // 手机自带网络
                    MyLog(@"当前使用的是2G/3G/4G网络");
                }
            }
        }];
    });
    return _instance;
}

#pragma mark -- POST请求 --
- (void)postWithURLString:(NSString *)URLString showLoading:(BOOL)showLoading parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    if (showLoading) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD show];
        });
    }
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,URLString];
    MyLog(@"url:%@,params:%@",urlStr,parameters);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"html:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        MyLog(@"url:%@, json:%@",urlStr,json);
        if ([[json objectForKey:@"error"] isKindOfClass:[NSNumber class]]) {
            NSInteger status=[[json objectForKey:@"error"] integerValue];
            NSString *message=[json objectForKey:@"msg"];
            if (status==0) {
                success(json);
            }else{
                if ([message isEqualToString:@"用户不存在"]) {
                    [HttpRequest signOut];
                }else{
                    message=kIsEmptyString(message)?@"Akses sedang tidak tersedia, mohon coba kembali":message;
                    MyLog(@"postWithURLString:%@,error:%@",urlStr,message);
                    failure(message);
                }
            }
        }else{
            NSString *message = @"Akses sedang tidak tersedia, mohon coba kembali";
            failure(message);
        }
        if (showLoading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"postWithURLString:%@,error:%@",urlStr,error.localizedDescription);
        
        if (showLoading) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        failure(error.localizedDescription);
    }];
}

-(void)tempPostWithURLString:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    MyLog(@"url:%@,params:%@",URLString,parameters);
   AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
   manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       MyLog(@"html:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
       id json=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
       MyLog(@"url:%@, json:%@",URLString,json);
       if ([[json objectForKey:@"error"] isKindOfClass:[NSNumber class]]) {
           NSInteger status=[[json objectForKey:@"error"] integerValue];
           NSString *message=[json objectForKey:@"msg"];
           if (status==0) {
               success(json);
           }else{
               if ([message isEqualToString:@"用户不存在"]) {
                   [HttpRequest signOut];
               }else{
                   message=kIsEmptyString(message)?@"Akses sedang tidak tersedia, mohon coba kembali":message;
                   MyLog(@"postWithURLString:%@,error:%@",URLString,message);
                   failure(message);
               }
           }
       }else{
           NSString *message = @"Akses sedang tidak tersedia, mohon coba kembali";
           failure(message);
       }
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       MyLog(@"postWithURLString:%@,error:%@",URLString,error.localizedDescription);
       failure(error.localizedDescription);
   }];
}

#pragma mark 上传文件
- (void)uploadWithURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(NSArray<UploadParam *> *)uploadParams success:(void (^)(id))success failure:(void (^)(NSString *))failure{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    NSString *urlStr = [NSString stringWithFormat:kHostTempURL,URLString];
    MyLog(@"uploadWithURLString----url:%@,params:%@",urlStr,parameters);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UploadParam *uploadParam in uploadParams) {
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        MyLog(@"html:%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        id json=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        MyLog(@"url:%@, json:%@",urlStr,json);
        if ([[json objectForKey:@"error"] isKindOfClass:[NSNumber class]]) {
            NSInteger status=[[json objectForKey:@"error"] integerValue];
            NSString *message=[json objectForKey:@"msg"];
            if (status==0) {
                success(json);
            }else{
                message=kIsEmptyString(message)?@"Akses sedang tidak tersedia, mohon coba kembali":message;
                MyLog(@"请求失败--error:%@",message);
                failure(message);
            }
        }else{
            NSString *message = @"Akses sedang tidak tersedia, mohon coba kembali";
            failure(message);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MyLog(@"请求失败--error:%@",error.localizedDescription);
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        failure(error.localizedDescription);
    }];
}

#pragma mark - 下载数据
- (void)downLoadWithURLString:(NSString *)URLString parameters:(id)parameters progerss:(void (^)(void))progress success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress();
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return targetPath;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (failure) {
            failure(error);
        }
    }];
    [downLoadTask resume];
}

+(void)signOut{
    NSString *deviceId = [[APPInfoManager sharedAPPInfoManager] deviceIdentifier];
    NSDictionary *params = @{@"deviceId":deviceId,@"platform":@"ios"};
    [[HttpRequest sharedInstance] postWithURLString:kTouristSignInAPI showLoading:YES parameters:params success:^(id responseObject) {
        NSDictionary *data = [responseObject objectForKey:@"data"];
        NSDictionary *userInfo = [data valueForKey:@"userinfo"];
        NSString *token = [userInfo valueForKey:@"token"];
        [NSUserDefaultsInfos putKey:kUserToken andValue:token];
        [NSUserDefaultsInfos putKey:kIsLogin andValue:[NSNumber numberWithBool:NO]];
        
        [[GoogleLoginManager sharedGoogleLoginManager] signOut];
        [ComicManager sharedComicManager].isLogin = YES;
    } failure:^(NSString *errorStr) {
        MyLog(@"接口：%@----请求失败，error：%@",kTouristSignInAPI,errorStr);
    }];
}

@end
