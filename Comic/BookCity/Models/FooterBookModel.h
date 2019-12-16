//
//  FooterBookModel.h
//  Comic
//
//  Created by vision on 2019/11/23.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FooterBookModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic , copy ) NSString  *square_cover;   //封面
@property (nonatomic , copy ) NSString  *book_name;    //书名
@property (nonatomic , copy ) NSArray   *label;    //标签

@end


