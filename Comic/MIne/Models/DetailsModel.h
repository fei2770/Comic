//
//  DetailsModel.h
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DetailsModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic , copy ) NSString  *name;
@property (nonatomic , copy ) NSString  *book_name;
@property (nonatomic ,strong) NSNumber  *catalogue_id;
@property (nonatomic , copy ) NSString  *catalogue_name;
@property (nonatomic ,strong) NSNumber  *create_time;
@property (nonatomic ,strong) NSNumber  *count;
@property (nonatomic ,strong) NSNumber  *status; //0消费 1充值 2充值赠送 3签到领取 4任务获取 5会员领取 6会员赠送 7发送弹幕 8兑换弹幕样式


@end


