//
//  PurchaseManger.h
//  Comic
//
//  Created by vision on 2019/12/3.
//  Copyright © 2019 vision. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 block
 @param isSuccess 是否支付成功
 @param certificate 支付成功得到的凭证（用于在自己服务器验证）
 @param errorMsg 错误信息
 */
typedef void(^PurchaseResult)(BOOL isSuccess, NSString *certificate, NSString *errorMsg);

/**
 block
 @param isSuccess 是否支付成功
 @param productIds 支付成功得到的凭证（用于在自己服务器验证）
 */
typedef void(^RestorePurchaseResult)(BOOL isSuccess, NSMutableArray *productIds);

@interface PurchaseManger : NSObject

singleton_interface(PurchaseManger)

@property (nonatomic, copy) PurchaseResult purchaseResultBlock;
@property (nonatomic, copy) RestorePurchaseResult restorePurchaseResult;
@property (nonatomic, copy) NSString * orderSn;//callback 返回的订单号

/**
 内购支付
 @param productID 内购商品ID
 @param purchaseResult 结果
 */
- (void)purchaseWithProductID:(NSString *)productID payResult:(PurchaseResult)purchaseResult;


@end

