//
//  ReadCateModel.h
//  Comic
//
//  Created by vision on 2019/11/19.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ReadCateModel : NSObject

@property (nonatomic,strong) NSNumber *type_id;
@property (nonatomic, copy ) NSString *type_cover;
@property (nonatomic, copy ) NSString *type_name;
@property (nonatomic,strong) NSNumber *is_selected;

@end

