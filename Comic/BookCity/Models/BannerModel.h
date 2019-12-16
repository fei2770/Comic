//
//  BannerModel.h
//  Comic
//
//  Created by vision on 2019/11/13.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BannerModel : NSObject

@property (nonatomic ,  copy ) NSString  *banner_url;
@property (nonatomic ,  copy ) NSString  *banner_pic;
@property (nonatomic ,strong ) NSNumber  *banner_cate;
@property (nonatomic ,  copy ) NSString  *banner_name;
@property (nonatomic ,  copy ) NSString  *custom;

@end

