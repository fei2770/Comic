//
//  UserModel.h
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserModel : NSObject

@property (nonatomic , copy ) NSString  *name;
@property (nonatomic , copy ) NSString  *head_portrait; //头像
@property (nonatomic , copy ) NSString  *token;
@property (nonatomic ,strong) NSNumber  *bean;
@property (nonatomic ,strong) NSNumber  *sex;   //性别
@property (nonatomic ,strong) NSNumber  *vip;     //是否vip
@property (nonatomic ,strong) NSNumber  *vip_end_time;
@property (nonatomic ,strong) NSNumber  *sign_count;      //签到人数
@property (nonatomic ,strong) NSNumber  *vip_get_count;   //vip人数
@property (nonatomic ,strong) NSNumber  *birthday;   //生日

@end


