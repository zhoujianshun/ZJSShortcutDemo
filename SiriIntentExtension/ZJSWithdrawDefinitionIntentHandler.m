//
//  ZJSWithdrawDefinitionIntentHandler.m
//  SiriIntentExtension
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "ZJSWithdrawDefinitionIntentHandler.h"

#import "ZJSPaymentDetails.h"

@implementation ZJSWithdrawDefinitionIntentHandler

-(void)confirmWithdrawDefinition:(WithdrawDefinitionIntent *)intent completion:(void (^)(WithdrawDefinitionIntentResponse * _Nonnull))completion{
    WithdrawDefinitionIntentResponse *response = [[WithdrawDefinitionIntentResponse alloc] initWithCode:WithdrawDefinitionIntentResponseCodeReady userActivity:nil];
    completion(response);
}

-(void)handleWithdrawDefinition:(WithdrawDefinitionIntent *)intent completion:(void (^)(WithdrawDefinitionIntentResponse * _Nonnull))completion{
    NSInteger amount = [intent.amount integerValue];
    NSInteger newBalance = [ZJSPaymentDetails withdraw:amount];
    
    WithdrawDefinitionIntentResponse *response;
    if (newBalance > 0) {
         response = [[WithdrawDefinitionIntentResponse alloc] initWithCode:WithdrawDefinitionIntentResponseCodeSuccessWithAmount userActivity:nil];
        response.availableBalance = @(newBalance);
        response.requestAmount = @(amount);
    }else{
         response = [[WithdrawDefinitionIntentResponse alloc] initWithCode:WithdrawDefinitionIntentResponseCodeFailDueToLessAmount userActivity:nil];
        response.availableBalance = @([ZJSPaymentDetails checkBalance]);
        response.requestAmount = @(amount);
    }
    
    completion(response);
}

@end
