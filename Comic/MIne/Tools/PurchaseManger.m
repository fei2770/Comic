//
//  PurchaseManger.m
//  Comic
//
//  Created by vision on 2019/12/3.
//  Copyright © 2019 vision. All rights reserved.


#import "PurchaseManger.h"
#import <StoreKit/StoreKit.h>
#import "SVProgressHUD.h"

@interface PurchaseManger ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

//产品ID
@property (nonnull,copy)NSString * productId;

@end

@implementation PurchaseManger

singleton_implementation(PurchaseManger)

-(instancetype)init{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        MyLog(@"监听订阅");
    }
    return self;
}

-(void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

#pragma mark -- SKPaymentTransactionObserver
#pragma mark 监听内购结果
-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    MyLog(@"监听内购结果----------updatedTransactions:%@",transactions);
    for (SKPaymentTransaction * transaction in transactions) {
//        transaction.transactionIdentifier
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:{
                MyLog(@"交易完成");
                //订阅特殊处理
                NSString *trasactionId;
                if (transaction.originalTransaction) {//如果是自动续费的订单originalTransaction会有内容
                    MyLog(@"自动续费的订单,originalTransaction = %@",transaction.originalTransaction.transactionIdentifier);
                    trasactionId = transaction.originalTransaction.transactionIdentifier;
                }else{ //普通购买，以及 第一次购买 自动订阅
                    MyLog(@"普通购买，以及 第一次购买 自动订阅,transactionIdentifier:%@",transaction.transactionIdentifier);
                    trasactionId = transaction.transactionIdentifier;
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self verifyPurchaseWithPaymentTransactionWithTransactionId:trasactionId];
            }
                break;
            case SKPaymentTransactionStateFailed:{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                NSString * errorStr = nil;
                if(transaction.error.code != SKErrorPaymentCancelled) {
                    errorStr = [NSString stringWithFormat:@"%ld",(long)transaction.error.code];
                } else {
                    errorStr = [NSString stringWithFormat:@"%ld",(long)transaction.error.code];
                }
                MyLog(@"交易失败,error:%@,%@",errorStr,transaction.error.localizedDescription);
                if (self.purchaseResultBlock) {
                    self.purchaseResultBlock(NO, @"", transaction.error.localizedDescription);
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored:{//已经购买过该商品
                MyLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self verifyPurchaseWithPaymentTransactionWithTransactionId:transaction.transactionIdentifier];
            }
                break;
            case SKPaymentTransactionStatePurchasing:{
                MyLog(@"正在购买中...");
            }
                break;
            case SKPaymentTransactionStateDeferred:{
                MyLog(@"交易还在队列里面，但最终状态还没有决定");
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark SKProductsRequestDelegate
#pragma mark 收到产品反馈
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    MyLog(@"--------------收到产品反馈消息---------------------product:%@",response.products);
    NSArray *myProduct = response.products;
    if (myProduct.count == 0) {
        if (self.purchaseResultBlock) {
            self.purchaseResultBlock(NO, @"", NSLocalizedString(@"purchase_unable_product_tips", nil));
        }
        return;
    }
    MyLog(@"invalidProductIdentifiers-----productID:%@", response.invalidProductIdentifiers);
    SKProduct * product = nil;
    for(SKProduct * pro in myProduct){
        MyLog(@"SKProduct 描述信息%@", [pro description]);
        MyLog(@"产品标题 %@" , pro.localizedTitle);
        MyLog(@"产品描述信息: %@" , pro.localizedDescription);
        MyLog(@"价格: %@" , pro.price);
        MyLog(@"Product id: %@" , pro.productIdentifier);
        
        if ([pro.productIdentifier isEqualToString:self.productId]) {
            product = pro;
            break;
        }
    }
    
    if (product) {
        SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
        //使用苹果提供的属性,将平台订单号复制给这个属性作为透传参数
        payment.applicationUsername = self.orderSn;
        
        MyLog(@"发送购买请求");
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        
    }else{
        self.purchaseResultBlock(NO, @"", NSLocalizedString(@"purchase_unable_product_tips", nil));
    }
}


#pragma mark 内购请求失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    MyLog(@"内购请求失败--error:%ld,%@",error.code,error.localizedDescription);
    if (self.purchaseResultBlock) {
        self.purchaseResultBlock(NO, @"", [error localizedDescription]);
    }
}

#pragma mark -- Public methods
#pragma mark 发起内购支付
-(void)purchaseWithProductID:(NSString *)productID payResult:(PurchaseResult)purchaseResult{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    
    // 移除队列中未完成的支付
    [self removeAllUncompleteTransactionBeforeNewPurchase];
    
    self.purchaseResultBlock = purchaseResult;
    self.productId = productID;
    if (kIsEmptyString(self.productId)) {
        self.purchaseResultBlock(NO,@"",@"Id produk kosong");
        return;
    }
    if ([SKPaymentQueue canMakePayments]) {
        NSArray * productArray = [[NSArray alloc]initWithObjects:productID,nil];
        NSSet * IDSet = [NSSet setWithArray:productArray];
        SKProductsRequest * request = [[SKProductsRequest alloc] initWithProductIdentifiers:IDSet];
        request.delegate = self;
        [request start];
    }else{
        self.purchaseResultBlock(NO, @"", @"Perangkat saat ini tidak mendukung pembayaran internal");
    }
}
 
#pragma mark -- Private Methods
#pragma mark 移除未完成的交易
- (void)removeAllUncompleteTransactionBeforeNewPurchase {
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        for (NSInteger count = transactions.count; count > 0; count--) {
            SKPaymentTransaction* transaction = [transactions objectAtIndex:count-1];
            if (transaction.transactionState == SKPaymentTransactionStatePurchased||transaction.transactionState == SKPaymentTransactionStateRestored) {
                [[SKPaymentQueue defaultQueue]finishTransaction:transaction];
            }
        }
    } else {
        MyLog(@"没有未完成的交易");
    }
}

#pragma mark 验证内购结果
-(void)verifyPurchaseWithPaymentTransactionWithTransactionId:(NSString *)transactionId{
    if (!kIsEmptyString(self.orderSn)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD show];
        });
        
        NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
        NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];//转化为base64字符串

        NSDictionary *params = @{@"apple_receipt":receiptString,@"ord_no":self.orderSn,@"original_transaction_id":transactionId};
        [[HttpRequest sharedInstance] postWithURLString:kPayReportAPI showLoading:YES parameters:params success:^(id responseObject) {
            if (self.purchaseResultBlock) {
                self.purchaseResultBlock(YES, receiptString, @"");
            }
        } failure:^(NSString *errorStr) {
            if (self.purchaseResultBlock) {
                self.purchaseResultBlock(NO, @"", errorStr);
            }
        }];
    }
}


@end
