//
//  NSMutableURLRequest+PostFile.h
//  Teasing
//
//  Created by vision on 2019/6/10.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface NSMutableURLRequest (PostFile)

+(instancetype)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andLocalFilePath:(NSString *)localFilePath;

@end


