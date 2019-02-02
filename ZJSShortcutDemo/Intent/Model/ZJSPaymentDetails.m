//
//  ZJSPaymentDetails.m
//  ZJSShortcutDemo
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "ZJSPaymentDetails.h"

#define kZJSAmountKey @"kZJSAmountKey"
#define kZJSAPPGroupKey @"group.com.rippleinfo.runscene"

@interface ZJSPaymentDetails ()


@end

@implementation ZJSPaymentDetails


+(void)setBalance:(NSInteger)amount{
    NSUserDefaults *userDefault = [self getUserDefaults];
    [userDefault setValue:@(amount) forKey:kZJSAmountKey];
    [userDefault synchronize];
}

+(NSInteger)checkBalance{
    NSUserDefaults *userDefault = [self getUserDefaults];
    [userDefault synchronize];
    return [[userDefault valueForKey:kZJSAmountKey] integerValue];
}

+(NSInteger)withdraw:(NSInteger)amount{
    NSInteger balance = [self checkBalance];
    NSInteger newBalance = balance - amount;
    if (newBalance < 0) {
        return -1;
    }else{
        [self setBalance:newBalance];
        return newBalance;
    }
    
}

+(NSInteger)deposit:(NSInteger)amount{
    NSInteger balance = [self checkBalance];
    NSInteger newBalance = balance + amount;
    [self setBalance:newBalance];
    return newBalance;
}


+(NSUserDefaults*)getUserDefaults{
    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:kZJSAPPGroupKey];
    return userDefault;
}

@end
