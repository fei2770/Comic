//
//  GoogleLoginManager.m
//  Teasing
//
//  Created by vision on 2019/6/5.
//  Copyright © 2019 vision. All rights reserved.
//

#import "GoogleLoginManager.h"

@interface GoogleLoginManager ()<GIDSignInDelegate>

@property (nonatomic, assign) BOOL loginFromKeyChain;

@property (nonatomic, copy) void(^authHandler)(GIDGoogleUser *user,NSError *error);

@property (nonatomic, copy) void(^autoAuthHandler)(GIDGoogleUser *user,NSError *error);

@end

@implementation GoogleLoginManager

singleton_implementation(GoogleLoginManager)

-(instancetype)init{
    self = [super init];
    if (self) {
        [GIDSignIn sharedInstance].delegate = self;
    }
    return self;
}

#pragma mark -- Public Methods
#pragma mark currentUser
-(GIDGoogleUser *)currentUser{
    return [GIDSignIn sharedInstance].currentUser;
}

#pragma mark check state
-(void)checkGoogleAccountStateWithCompletion:(void (^)(GoogleAccountState))handler{
    if ([self currentUser]) {
        handler(GoogleAccountStateOnline);
    }else if ([GIDSignIn sharedInstance].hasPreviousSignIn){
        handler(GoogleAccountStateHasPreviousSignIn);
    }else{
        handler(GoogleAccountStateOffline);
    }
}

#pragma mark autoLogin
-(void)autoLoginWithCompletion:(void (^)(GIDGoogleUser *, NSError *))handler{
    self.autoAuthHandler = handler;
    self.loginFromKeyChain = YES;
    [[GIDSignIn sharedInstance] restorePreviousSignIn];
}

#pragma mark Google Login
-(void)startGoogleLoginWithCompletion:(void (^)(GIDGoogleUser *, NSError *))handler{
    self.authHandler = handler;
    self.loginFromKeyChain = NO;
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark signOut
-(void)signOut{
    [[GIDSignIn sharedInstance] signOut];
    [[GIDSignIn sharedInstance] disconnect];
}

#pragma mark -- GIDSignInDelegate
#pragma mark login callback
-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error==nil) {
        
        NSString *userId = user.userID;                  // For client-side use only!
        NSString *idToken = user.authentication.idToken; // Safe to send to the server
        NSString *fullName = user.profile.name;
        NSString *email = user.profile.email;
        
        MyLog(@"didSignInForUser---,id:%@,\n token:%@, \n fullname:%@,\n email:%@",userId,idToken,fullName,email);
    }
    
    if (self.loginFromKeyChain) {
        if (self.autoAuthHandler) {
            self.autoAuthHandler(user, error);
        }
    }else{
        if (self.authHandler) {
            self.authHandler(user, error);
        }
    }
}

#pragma mark signOut
-(void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if (error) {
        MyLog(@"didDisconnectWithUser--error:%@",error.localizedDescription);
    }else{
        MyLog(@"didDisconnectWithUser");
    }
}


@end
