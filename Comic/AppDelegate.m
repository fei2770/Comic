//
//  AppDelegate.m
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import "AppDelegate.h"
#import "MyTabBarController.h"
#import "APPInfoManager.h"
#import "PurchaseManger.h"
#import <IQKeyboardManager.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <UMCommon/UMCommon.h>
#import <UMCommonLog/UMCommonLogHeaders.h>
#import <UMShare/UMShare.h>
#import <UMAnalytics/MobClick.h>
#import "BaseWebViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setAppSystemConfigWithOptions:launchOptions];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    MyTabBarController *tabbarController = [[MyTabBarController alloc] init];
    self.window.rootViewController = tabbarController;
    
    //深度链接
    //pulaukomik://com.shushan.manhua/read?book_id=1&catalogue_id=10
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        MyLog(@"fetchDeferredAppLink---url:%@",url.absoluteString);
        if (error) {
            MyLog(@"Received error while fetching deferred app link %@", error);
        }
    }];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application{
    MyLog(@"applicationWillResignActive");
    
    
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    MyLog(@"applicationDidEnterBackground");
}

-(void)applicationWillEnterForeground:(UIApplication *)application{
    MyLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    MyLog(@"applicationDidBecomeActive");
    [FBSDKAppEvents activateApp];
    //监听自动订阅
    [PurchaseManger sharedPurchaseManger];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    MyLog(@"applicationWillTerminate");
}


-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        if (handled) {
            return handled;
        }else{
            return [[GIDSignIn sharedInstance] handleURL:url];
        }
    }else{
        return result;
    }
}

#pragma mark -- Private Methods
#pragma mark app config
-(void)setAppSystemConfigWithOptions:(NSDictionary *)launchOptions{
    //IQKeyboardManager
    IQKeyboardManager *keyboardManager= [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES; //键盘弹出时，点击背景，键盘收回
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;
    keyboardManager.enableAutoToolbar = NO; //隐藏键盘上面的toolBar
    
    //谷歌
    [GIDSignIn sharedInstance].clientID = kGoogleClientID;
    
    //友盟
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:kUMAppKey channel:@"App Store"];
    [MobClick setScenarioType:E_UM_NORMAL];
    
    //Facebook
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [FBSDKSettings setAppID:kFaceBookAppKey];
    /* Facebook appKey UrlString */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Facebook appKey:kFaceBookAppKey  appSecret:nil redirectURL:nil];
}


@end
