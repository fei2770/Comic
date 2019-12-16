//
//  NSMutableURLRequest+PostFile.m
//  Teasing
//
//  Created by vision on 2019/6/10.
//  Copyright © 2019 vision. All rights reserved.
//

#import "NSMutableURLRequest+PostFile.h"

@implementation NSMutableURLRequest (PostFile)

static NSString *boundary=@"AlvinLeonPostRequest";

+(instancetype)requestWithURL:(NSURL *)url andFilenName:(NSString *)fileName andLocalFilePath:(NSString *)localFilePath{
    //post请求
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url cachePolicy:1 timeoutInterval:2.0f];
    request.HTTPMethod=@"POST";//设置请求方法是POST
    request.timeoutInterval=15.0;//设置请求超时
    
    //拼接请求体数据(1-6步)
    NSMutableData *requestMutableData=[NSMutableData data];
    /*--------------------------------------------------------------------------*/
    //1.\r\n--Boundary+72D4CD655314C423\r\n   // 分割符，以“--”开头，后面的字随便写，只要不写中文即可
    NSMutableString *myString=[NSMutableString stringWithFormat:@"\r\n--%@\r\n",boundary];
    
    //2. Content-Disposition: form-data; name="uploadFile"; filename="001.png"\r\n  // 这里注明服务器接收图片的参数（类似于接收用户名的userName）及服务器上保存图片的文件名
    [myString appendString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"%@\"\r\n",fileName]];
    
    //3. Content-Type:image/png \r\n  // 图片类型为png
    [myString appendString:[NSString stringWithFormat:@"Content-Type:application/octet-stream\r\n"]];
    
    //4. Content-Transfer-Encoding: binary\r\n\r\n  // 编码方式
    [myString appendString:@"Content-Transfer-Encoding: binary\r\n\r\n"];
    
    //转换成为二进制数据
    [requestMutableData appendData:[myString dataUsingEncoding:NSUTF8StringEncoding]];
    
    //5.文件数据部分
    NSURL *filePathUrl=[NSURL URLWithString:localFilePath];
    
    //转换成为二进制数据
    [requestMutableData appendData:[NSData dataWithContentsOfURL:filePathUrl]];
    
    //6. \r\n--Boundary+72D4CD655314C423--\r\n  // 分隔符后面以"--"结尾，表明结束
    [requestMutableData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    /*--------------------------------------------------------------------------*/
    //设置请求体
    request.HTTPBody=requestMutableData;
    
    //设置请求头
    NSString *headStr=[NSString stringWithFormat:@"Content-Type multipart/form-data; boundary=%@",boundary];
    [request setValue:headStr forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

@end
