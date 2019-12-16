//
//  BarrageModel.h
//  Comic
//
//  Created by vision on 2019/11/25.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BarrageModel : NSObject

@property (nonatomic,strong) NSNumber  *barrage_id;
@property (nonatomic,strong) NSNumber  *xcoord;
@property (nonatomic,strong) NSNumber  *ycoord;
@property (nonatomic, copy ) NSString  *barrage_content;
@property (nonatomic,strong) NSNumber  *style_id;


@end


