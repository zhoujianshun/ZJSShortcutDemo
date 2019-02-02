//
//  ZJSPaymentDetails.h
//  ZJSShortcutDemo
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJSPaymentDetails : NSObject


+(void)setBalance:(NSInteger)amount;

+(NSInteger)checkBalance;

+(NSInteger)withdraw:(NSInteger)amount;

+(NSInteger)deposit:(NSInteger)amount;

@end

NS_ASSUME_NONNULL_END
