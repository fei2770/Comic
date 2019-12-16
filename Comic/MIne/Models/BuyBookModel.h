//
//  BuyBookModel.h
//  Comic
//
//  Created by vision on 2019/11/29.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface BuyBookModel : NSObject

@property (nonatomic ,strong) NSNumber  *book_id;
@property (nonatomic , copy ) NSString  *oblong_cover;
@property (nonatomic , copy ) NSString  *book_name;
@property (nonatomic ,strong) NSNumber  *catalogue_id;
@property (nonatomic ,strong) NSNumber  *buy_words;
@property (nonatomic ,strong) NSNumber  *words;

@end


