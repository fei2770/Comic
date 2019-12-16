//
//  GoogleLoginManager.h
//  Teasing
//
//  Created by vision on 2019/6/5.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>


typedef NS_ENUM(NSUInteger,GoogleAccountState) {
    GoogleAccountStateOnline = 0,
    GoogleAccountStateHasPreviousSignIn =1,
    GoogleAccountStateOffline =2
};

@interface GoogleLoginManager : NSObject

singleton_interface(GoogleLoginManager)

@property (nonatomic, strong) GIDGoogleUser *currentUser;

//check state
- (void)checkGoogleAccountStateWithCompletion:(void (^)(GoogleAccountState state))handler;
//autoLogin
- (void)autoLoginWithCompletion:(void (^)(GIDGoogleUser *user,NSError *error))handler;
//googleLogin
- (void)startGoogleLoginWithCompletion:(void (^)(GIDGoogleUser *user,NSError *error))handler;
//signOut
-(void)signOut;

@end

