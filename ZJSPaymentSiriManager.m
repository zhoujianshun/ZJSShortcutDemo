//
//  ASPaymentSiriManager.m
//  ZJSShortcutDemo
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "ZJSPaymentSiriManager.h"

#import "DepositeDefinitionIntent.h"
#import "WithdrawDefinitionIntent.h"

@implementation ZJSPaymentSiriManager


+(void)donateDepositeShortcut:(NSInteger)amount completion:(void(^_Nullable)(NSError * _Nullable error))completion{
    DepositeDefinitionIntent *intent = [[DepositeDefinitionIntent alloc] init];
    intent.amount = @(amount);
    
    INInteraction *interaction = [[INInteraction alloc] initWithIntent:intent response:nil];
    [interaction donateInteractionWithCompletion:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

+(void)donateWithdrawShortcut:(NSInteger)amount completion:(void(^_Nullable)(NSError * _Nullable error))completion{
    WithdrawDefinitionIntent *intent = [[WithdrawDefinitionIntent alloc] init];
    intent.amount = @(amount);
    
    INInteraction *interaction = [[INInteraction alloc] initWithIntent:intent response:nil];
    [interaction donateInteractionWithCompletion:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

+(void)deleteAllAllInteractionsWithCompletion:(void(^_Nullable)(NSError * _Nullable error))completion{
    [INInteraction deleteAllInteractionsWithCompletion:^(NSError * _Nullable error) {
        if (completion) {
            completion(error);
        }
    }];
}

@end
