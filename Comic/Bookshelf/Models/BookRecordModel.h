//
//  BookRecordModel.h
//  Comic
//
//  Created by vision on 2019/11/15.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BookRecordModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic ,strong) NSNumber  *catalogue_id;
@property (nonatomic , copy ) NSString  *catalogue_name;
@property (nonatomic , copy ) NSString  *book_name;
@property (nonatomic , copy ) NSString  *detail_cover;
@property (nonatomic , copy ) NSString  *oblong_cover;
@property (nonatomic ,strong) NSNumber  *create_time;
@property (nonatomic ,strong) NSNumber  *words;     //总话数
@property (nonatomic ,strong) NSNumber  *residue_words; //剩余话数


@end


