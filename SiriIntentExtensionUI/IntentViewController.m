//
//  IntentViewController.m
//  SiriIntentExtensionUI
//
//  Created by 周建顺 on 2019/2/2.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "IntentViewController.h"

#import "DepositeDefinitionIntent.h"
#import "WithdrawDefinitionIntent.h"

#import "ZJSDepositeViewController.h"
#import "ZJSWithdrawViewController.h"

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

@interface IntentViewController ()
@property (nonatomic, strong) ZJSDepositeViewController *depositeVC;
@property (nonatomic, strong) ZJSWithdrawViewController *withdrawVC;

@end

@implementation IntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - INUIHostedViewControlling

// Prepare your view controller for the interaction to handle.
- (void)configureViewForParameters:(NSSet <INParameter *> *)parameters ofInteraction:(INInteraction *)interaction interactiveBehavior:(INUIInteractiveBehavior)interactiveBehavior context:(INUIHostedViewContext)context completion:(void (^)(BOOL success, NSSet <INParameter *> *configuredParameters, CGSize desiredSize))completion {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    if ([interaction.intent isKindOfClass:[DepositeDefinitionIntent class]]) {
        DepositeDefinitionIntentResponse *response = (DepositeDefinitionIntentResponse*)interaction.intentResponse;
        DepositeDefinitionIntent *intent = (DepositeDefinitionIntent *)interaction.intent;
        
        NSString *message = @"DepositeDefinitionIntent";
        if (response.code == DepositeDefinitionIntentResponseCodeSentSuccessfully) {
            message = [NSString stringWithFormat:@"Request(+) %@ success", intent.amount];
        }else if(response.code == DepositeDefinitionIntentResponseCodeReady){
            message = [NSString stringWithFormat:@"Request(+) %@ ready", intent.amount];
        }
        
        
        [self.view addSubview:self.depositeVC.view];
        self.depositeVC.view.backgroundColor = [UIColor grayColor];
        [self.depositeVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        //设置宽高
        [[self.depositeVC.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor] setActive:YES];
        [[self.depositeVC.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor] setActive:YES];
        [[self.depositeVC.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
        [[self.depositeVC.view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
        
        [self.depositeVC didMoveToParentViewController:self];
        self.depositeVC.label.text = message;
        
    }else if([interaction.intent isKindOfClass:[WithdrawDefinitionIntent class]]){
        
        WithdrawDefinitionIntentResponse *response = (WithdrawDefinitionIntentResponse*)interaction.intentResponse;
        WithdrawDefinitionIntent *intent = (WithdrawDefinitionIntent *)interaction.intent;
        
        NSString *message = @"WithdrawDefinitionIntent";
        if (response.code == WithdrawDefinitionIntentResponseCodeSuccessWithAmount) {
            message = [NSString stringWithFormat:@"Send(-) %@ success", intent.amount];
        }else if(response.code == WithdrawDefinitionIntentResponseCodeReady){
            message = [NSString stringWithFormat:@"Send(-) %@ ready", intent.amount];
        }else if(response.code == WithdrawDefinitionIntentResponseCodeFailDueToLessAmount){
            message = [NSString stringWithFormat:@"Send(-) %@ fail due to less amount", intent.amount];
        }
        
       
        [self.view addSubview:self.withdrawVC.view];
        self.withdrawVC.view.backgroundColor = [UIColor grayColor];
        [self.withdrawVC.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        //设置宽高
        [[self.withdrawVC.view.widthAnchor constraintEqualToAnchor:self.view.widthAnchor] setActive:YES];
        [[self.withdrawVC.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor] setActive:YES];
        [[self.withdrawVC.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:YES];
        [[self.withdrawVC.view.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:YES];
        
        [self.withdrawVC didMoveToParentViewController:self];
         self.withdrawVC.label.text = message;
    }
    
    if (completion) {
        completion(YES, parameters, [self desiredSize]);
    }
}

- (CGSize)desiredSize {
    CGSize size = [self extensionContext].hostedViewMaximumAllowedSize;
    return CGSizeMake(size.width, 150);
}

#pragma mark -
-(ZJSDepositeViewController *)depositeVC{
    if (!_depositeVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainInterface" bundle:nil];
        _depositeVC = [sb instantiateViewControllerWithIdentifier:@"ZJSDepositeViewController"];
    }
    return _depositeVC;
}


-(ZJSWithdrawViewController *)withdrawVC{
    if (!_withdrawVC) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainInterface" bundle:nil];
        _withdrawVC = [sb instantiateViewControllerWithIdentifier:@"ZJSWithdrawViewController"];
    }
    return _withdrawVC;
}

@end
