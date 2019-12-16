//
//  TaskModel.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TaskModel : NSObject

@property (nonatomic,strong) NSNumber *quest_id;
@property (nonatomic, copy ) NSString *quest_name;
@property (nonatomic, copy ) NSString *icon;
@property (nonatomic, copy ) NSString *tips;
@property (nonatomic,strong) NSNumber *bean;
@property (nonatomic,strong) NSNumber *num;
@property (nonatomic,strong) NSNumber *status; //未完成 已完成待领取 已完成

@end


