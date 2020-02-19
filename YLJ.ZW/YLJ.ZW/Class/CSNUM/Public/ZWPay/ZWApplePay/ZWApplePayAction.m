//
//  ZWApplePayAction.m
//  YLJ.ZW
//
//  Created by 王小姐 on 2019/10/23.
//  Copyright © 2019 CHY. All rights reserved.
//

#import "ZWApplePayAction.h"
#import <StoreKit/StoreKit.h>
#import <MBProgressHUD.h>
#import "ZWSaveTransactionReceipt.h"

@interface ZWApplePayAction()<SKPaymentTransactionObserver,SKProductsRequestDelegate>

@property(nonatomic, strong)NSString *productId;//记录商品id
@property(nonatomic, strong)NSString *applePriceId;//记录上传到后台的价格列表id

@property (nonatomic, strong)NSArray *products;// 所有商品
@property (nonatomic, strong)SKProductsRequest *request;

@property (strong, nonatomic) SKPayment *payment;
@property (strong, nonatomic) SKMutablePayment *g_payment;

@property (strong, nonatomic) UIView *showView;

@end

static ZWApplePayAction *action = nil;

@implementation ZWApplePayAction

+ (instancetype)shareIAPAction {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        action = [self new];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:action];
    });
    return action;
}
// 请求可卖的商品
- (void)requestProducts:(NSDictionary *)productId withViewController:(UIViewController *)viewController
{
    self.productId = productId[@"productId"];
    self.applePriceId = productId[@"applePriceId"];
    
    NSDictionary *myDic = [[ZWSaveTransactionReceipt shareReceipt]takeUserReceipt];
    if (!myDic) {
        self.showView = viewController.view;
        [MBProgressHUD showHUDAddedTo:self.showView animated:YES];
        if (![SKPaymentQueue canMakePayments]) {
            NSLog(@"您的手机没有打开程序内付费购买");
            return;
        }
        [self validationTransactionIsFinished];
        NSArray * productIds= @[self.productId];
        NSSet *set = [NSSet setWithArray:productIds];// 3.获取productid的set(集合中)
        _request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];// 4.向苹果发送请求,请求可卖商品
        _request.delegate = self;
        [_request start];
    }else {
        __weak typeof (self) weakSelf = self;
        [[ZWAlertAction sharedAction]showTwoAlertTitle:@"提示" message:@"您有未处理的订单，处理结束时候才能继续购买，是否立即处理？" cancelTitle:@"否" confirmTitle:@"是" actionOne:^(UIAlertAction * _Nonnull actionOne) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            [strongSelf resolveOutstandingOrdersWithDic:myDic withViewController:viewController];
        } actionCancel:^(UIAlertAction * _Nonnull actionCancel) {
            
        } showInView:viewController];
    }
}
- (void)resolveOutstandingOrdersWithDic:(NSDictionary *)myDic withViewController:(UIViewController *)viewController {
    
    NSString *encodeStr = myDic[@"receipt"];
    NSDictionary *parameters;
    if (encodeStr) {
         NSLog(@"-------%@",self.applePriceId);
        parameters = @{@"receiptData":encodeStr,@"applePriceId":self.applePriceId};
    }else {
        return;
    }
    __weak typeof (self) weakSelf = self;
    [[ZWDataAction sharedAction]postReqeustWithURL:zwAppleVerifyThePayment parametes:parameters successBlock:^(NSDictionary * _Nonnull data) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        if (zw_issuccess) {
            [[ZWSaveTransactionReceipt shareReceipt]removeLocation];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshExhCion" object:nil];
            [strongSelf validationTransactionIsFinished];
            [self showOneAlertWithMessage:@"订单处理成功，您可以继续购买了" withViewController:viewController];
        }else {
            [self showOneAlertWithMessage:@"处理订单失败，请稍检查网络或稍后再试" withViewController:viewController];
        }
    } failureBlock:^(NSError * _Nonnull error) {

    } showInView:viewController.view];
    
}
- (void)validationTransactionIsFinished {
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    //检测是否有未完成的交易
    if (transactions.count > 0) {
        for (SKPaymentTransaction* transaction in transactions) {
            if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
//        SKPaymentTransaction* transaction = [transactions firstObject];
    }
}
/**
 *  当请求到可卖商品的结果会执行该方法
 *
 *  @param response response中存储了可卖商品的结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSMutableDictionary *priceDic = @{}.mutableCopy;
    for (SKProduct *product in response.products) {
        // 用来保存价格
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        // 货币单位
        NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];//自动换算美元
        [priceDic setObject:formattedPrice forKey:product.productIdentifier];
        // 带有货币单位的价格
        NSLog(@"价格:%@", product.price);
        NSLog(@"标题:%@", product.localizedTitle);
        NSLog(@"描述:%@", product.localizedDescription);
        NSLog(@"productid:%@", product.productIdentifier);
        NSLog(@"priceDic:%@",[[ZWToolActon shareAction]transformDic:priceDic]);
    }
    self.products = response.products;
    SKProduct *storeProduct = nil;
    for (SKProduct *pro in self.products) {
        if ([pro.productIdentifier isEqualToString:self.productId]) {
            storeProduct = pro;
        }
    }
    //创建一个支付对象，并放到队列中
    self.g_payment = [SKMutablePayment paymentWithProduct:storeProduct];
    //设置购买的数量
    self.g_payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:self.g_payment];
    
}
#pragma mark - 购买商品
- (void)buyProduct:(SKProduct *)product
{
    // 1.创建票据
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    NSLog(@"productIdentifier----%@", payment.productIdentifier);
    // 2.将票据加入到交易队列中
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}
#pragma mark - 实现观察者回调的方法
/**
 *  当交易队列中的交易状态发生改变的时候会执行该方法
 *
 *  @param transactions 数组中存放了所有的交易
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions){
        
        if (transaction.transactionState == SKPaymentTransactionStatePurchasing) {
            NSLog(@"用户正在购买");
        }else if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            NSLog(@"购买成功");
            [self buySuccessWithPaymentQueue:queue Transaction:transaction];
            [MBProgressHUD hideHUDForView:self.showView animated:YES];
        }else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"购买失败");
            [MBProgressHUD hideHUDForView:self.showView animated:YES];
            [queue finishTransaction:transaction];
        }else if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSLog(@"恢复购买");
            //TODO:向服务器请求补货，服务器补货完成后，客户端再完成交易单子
            //消耗品不能恢复购买
//            [queue finishTransaction:transaction];
        } else {
            NSLog(@"最终状态未确定");
        }
    }
}

- (void)buySuccessWithPaymentQueue:(SKPaymentQueue *)queue Transaction:(SKPaymentTransaction *)transaction {
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    if (encodeStr) {
        [[ZWSaveTransactionReceipt shareReceipt]saveUserReceipt:@{@"receipt":encodeStr}];
    }
    [self uploadDocuments:encodeStr withPaymentQueue:queue Transaction:transaction];
    
    
//    // 发送网络POST请求，对购买凭据进行验证
//    //测试验证地址:https://sandbox.itunes.apple.com/verifyReceipt
//    //正式验证地址:https://buy.itunes.apple.com/verifyReceipt
//    NSURL *url = [NSURL URLWithString:APPLE_PAY_YZ];
//    NSMutableURLRequest *urlRequest =
//    [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
//    urlRequest.HTTPMethod = @"POST";

//    NSString *payload = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", encodeStr];
//    NSLog(@"-------------%@",payload);
//
//    NSData *payloadData = [payload dataUsingEncoding:NSUTF8StringEncoding];
//    urlRequest.HTTPBody = payloadData;
//    NSURLSession *session = [NSURLSession sharedSession];
//     __weak typeof (self) weakSelf = self;
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//         __strong typeof (weakSelf) strongSelf = weakSelf;
//         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//         if (data == nil) {
//             NSLog(@"验证失败");
//         }else {
//             NSLog(@"验证成功！购买的商品是：%@",dict);
//             [strongSelf uploadDocuments:encodeStr withPaymentQueue:queue Transaction:transaction];
//         }
//     }];
//     [dataTask resume];
}

- (void)uploadDocuments:(NSString *)encodeStr withPaymentQueue:(SKPaymentQueue *)queue Transaction:(SKPaymentTransaction*)transaction{
    NSDictionary *parameters;
    if (encodeStr) {
        parameters = @{@"receiptData": encodeStr,@"applePriceId":self.applePriceId};
    }else {
        return;
    }
    [[ZWDataAction sharedAction]postReqeustWithURL:zwAppleVerifyThePayment parametes:parameters successBlock:^(NSDictionary * _Nonnull data) {
        if (zw_issuccess) {
            [[ZWSaveTransactionReceipt shareReceipt]removeLocation];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshExhCion" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"requestUserInfo" object:nil];
            [queue finishTransaction:transaction];
        }
    } failureBlock:^(NSError * _Nonnull error) {
        
    }showInView:self.showView];
}
// 商品列表 也可以使用从苹果请求的数据, 具体细节自己视情况处理
// goods1 是商品的ID
- (NSString *)goodsWithProductIdentifier:(NSString *)productIdentifier {
    NSDictionary *goodsDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"priceDic"];
    return goodsDic[productIdentifier];
}
// 恢复购买
- (void)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    // 恢复失败
    NSLog(@"恢复失败");
}
// 取消请求商品信息
- (void)dealloc {
    [_request cancel];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)showOneAlertWithMessage:(NSString *)message withViewController:(UIViewController *)viewController {
    
    [[ZWAlertAction sharedAction]showOneAlertTitle:@"提示" message:message confirmTitle:@"我知道了" actionOne:^(UIAlertAction * _Nonnull actionOne) {
        
    } showInView:viewController];

}

@end
