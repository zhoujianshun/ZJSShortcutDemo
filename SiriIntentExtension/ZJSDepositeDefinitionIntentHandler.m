//
//  ZJSDepositeDefinitionIntentHandler.m
//  SiriIntentExtension
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "ZJSDepositeDefinitionIntentHandler.h"

#import "ZJSPaymentDetails.h"

@implementation ZJSDepositeDefinitionIntentHandler

-(void)confirmDepositeDefinition:(DepositeDefinitionIntent *)intent completion:(void (^)(DepositeDefinitionIntentResponse * _Nonnull))completion{
    DepositeDefinitionIntentResponse *response = [[DepositeDefinitionIntentResponse alloc] initWithCode:DepositeDefinitionIntentResponseCodeReady userActivity:nil];
    completion(response);
}

-(void)handleDepositeDefinition:(DepositeDefinitionIntent *)intent completion:(void (^)(DepositeDefinitionIntentResponse * _Nonnull))completion{
    
    NSInteger amount = [intent.amount integerValue];
    NSInteger newBalance = [ZJSPaymentDetails deposit:amount];
    DepositeDefinitionIntentResponse *response = [[DepositeDefinitionIntentResponse alloc] initWithCode:DepositeDefinitionIntentResponseCodeSentSuccessfully userActivity:nil];
    response.availableBalance = @(newBalance);
    
    completion(response);
}

@end
