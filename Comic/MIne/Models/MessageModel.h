//
//  MessageModel.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MessageModel : NSObject

@property (nonatomic,strong) NSNumber  *msg_id;
@property (nonatomic,strong) NSNumber  *send_time;
@property (nonatomic, copy ) NSString  *title;
@property (nonatomic, copy ) NSString  *content;

@end


