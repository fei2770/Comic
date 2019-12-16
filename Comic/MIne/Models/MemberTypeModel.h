//
//  MemberTypeModel.h
//  Comic
//
//  Created by vision on 2019/11/18.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MemberTypeModel : NSObject


@property (nonatomic ,strong) NSNumber  *vipinfo_id;
@property (nonatomic , copy ) NSString  *name;
@property (nonatomic ,strong) NSNumber  *price;
@property (nonatomic ,strong) NSNumber  *original_price;
@property (nonatomic ,strong) NSNumber  *bean;
@property (nonatomic ,strong) NSNumber  *type;

@end


