//
//  ASPaymentSiriManager.h
//  ZJSShortcutDemo
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZJSPaymentSiriManager : NSObject

+(void)donateDepositeShortcut:(NSInteger)amount completion:(void(^_Nullable)(NSError * _Nullable error))completion;
+(void)donateWithdrawShortcut:(NSInteger)amount completion:(void(^_Nullable)(NSError * _Nullable error))completion;
+(void)deleteAllAllInteractionsWithCompletion:(void(^_Nullable)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
