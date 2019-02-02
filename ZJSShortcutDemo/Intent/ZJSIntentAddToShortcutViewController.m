//
//  ZJSIntentAddToShortcutViewController.m
//  ZJSShortcutDemo
//
//  Created by 周建顺 on 2019/1/29.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "ZJSIntentAddToShortcutViewController.h"


#import <IntentsUI/IntentsUI.h>
#import <Intents/Intents.h>

#import "ZJSPaymentDetails.h"
#import "ZJSPaymentSiriManager.h"

#define kInteractionIdentify @"com.rippleinfo.zjs.coffeorder"

@interface ZJSIntentAddToShortcutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end

@implementation ZJSIntentAddToShortcutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self check];
    [self rightButtons];
    [self refreshAction:nil];
}

#pragma mark -

-(void)rightButtons{
    UIButton *deleteAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [deleteAllButton setTitle:@"Delete" forState:UIControlStateNormal];
    [deleteAllButton addTarget:self action:@selector(deleteAllAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteAllButton sizeToFit];
    UIBarButtonItem *deleteItem = [[UIBarButtonItem alloc] initWithCustomView:deleteAllButton];
    self.navigationItem.rightBarButtonItems = @[deleteItem];
}


#pragma mark - user response

-(void)deleteAllAction:(UIButton*)sender{
    [ZJSPaymentSiriManager deleteAllAllInteractionsWithCompletion:^(NSError * _Nullable error) {
        
    }];
}

- (IBAction)refreshAction:(id)sender {
    NSInteger amount = [ZJSPaymentDetails checkBalance];
    if (amount <= 0) {
        [ZJSPaymentDetails setBalance:10000];
        amount = [ZJSPaymentDetails checkBalance];
    }
    [self refreshBalance];
}

- (IBAction)requestAction:(id)sender {
      [self presentAlertForInput:YES];
}

- (IBAction)sendAction:(id)sender {

    [self presentAlertForInput:NO];
}


#pragma mark -

-(void)refreshBalance{
    NSInteger amount = [ZJSPaymentDetails checkBalance];
    self.amountLabel.text = [NSString stringWithFormat:@"%@", @(amount)];
}

-(void)presentAlertForInput:(BOOL)isRequest{
    
    __weak typeof(self) weakself = self;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isRequest?@"Request Money":@"Send money" message:@"Enter amount" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = @"amount";
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger amount = [alert.textFields[0].text integerValue];
        if (isRequest) {
            [ZJSPaymentDetails deposit:amount];
            [weakself refreshBalance];
            [ZJSPaymentSiriManager donateDepositeShortcut:amount completion:^(NSError * _Nullable error) {
                [weakself alertForDonation:isRequest];
            }];
        }else{
            [ZJSPaymentDetails withdraw:amount];
            [weakself refreshBalance];
            [ZJSPaymentSiriManager donateWithdrawShortcut:amount completion:^(NSError * _Nullable error) {
                [weakself alertForDonation:isRequest];
            }];
        }
        
    }];
    [alert addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

-(void)alertForDonation:(BOOL)isRequest{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:isRequest?@"Request Donate":@"Send Donate" message:@"Now you can add this process in the shortcut." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:okAction];
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}

#pragma mark -
- (IBAction)donateInteractionAction:(id)sender {
  
}

- (IBAction)deleteInteractionAction:(id)sender {
    [INInteraction deleteInteractionsWithIdentifiers:@[kInteractionIdentify] completion:^(NSError * _Nullable error) {
        
    }];
}

- (IBAction)addToSiriAction:(id)sender {
  
}

- (IBAction)removeFromSiriAction:(id)sender {

}
//
//- (void)donateInteraction {
//    if (@available(iOS 12.0, *)) {
//        QuickOrderCoffeeIntent *quickOrderIntent = [[QuickOrderCoffeeIntent alloc] init];
//        quickOrderIntent.name = @"CafeAmericano";
//        quickOrderIntent.kind = @"Americano";
//        INInteraction *interaction = [[INInteraction alloc] initWithIntent:quickOrderIntent response:nil];
//        interaction.identifier = kInteractionIdentify;
//        [interaction donateInteractionWithCompletion:^(NSError * _Nullable error) {
//
//        }];
//
//
//    }
//}
//
//- (void)suggestUserAddShortcutToSiri {
//
//    if (self.currentShortCut) {
//        [self openEditVoiceVC:self.currentShortCut];
//    } else {
//        [self openAddVoiceVC];
//    }
//}
//
//
/////MARK:打开Siri添加短语页面
//- (void)openAddVoiceVC {
//    if (@available(iOS 12.0, *)) {
//        QuickOrderCoffeeIntent *quickOrderIntent = [[QuickOrderCoffeeIntent alloc] init];
//        quickOrderIntent.name = @"CafeAA";
//        quickOrderIntent.kind = @"AA";
//        INShortcut *shortcut = [[INShortcut alloc] initWithIntent:quickOrderIntent];
//        quickOrderIntent.suggestedInvocationPhrase = @"CafeAAsuggestedInvocationPhrase";
//        INUIAddVoiceShortcutViewController *vc = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
//        vc.delegate = self;
//        [self presentViewController:vc animated:YES completion:nil];
//    }
//}
/////MARK:打开Siri编辑短语页面
//- (void)openEditVoiceVC:(INVoiceShortcut *)voiceShortcut  API_AVAILABLE(ios(12.0)){
//    if (@available(iOS 12.0, *)) {
//        //        INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:self.userActivity];
//        INUIEditVoiceShortcutViewController *editVC = [[INUIEditVoiceShortcutViewController alloc] initWithVoiceShortcut:voiceShortcut];
//        if (!editVC.delegate) {
//            editVC.delegate = self;
//        }
//        __weak typeof(self) weakself = self;
//        [self presentViewController:editVC animated:YES completion:^{
//            __strong typeof(self) self = weakself;
//
//        }];
//    }
//}
//
//-(void)check{
//     __weak typeof(self) weakself = self;
//    [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts, NSError * _Nullable error) {
//        BOOL isAdd = NO;
//        INVoiceShortcut *shortcut = nil;
//        for (INVoiceShortcut *voice in voiceShortcuts) {
//            NSLog(@"====>>获取到的VoiceShortcuts :%@",voice.shortcut.intent);
//            if ([voice.shortcut.intent isKindOfClass:[QuickOrderCoffeeIntent class]]) {
//                isAdd = YES;
//                shortcut = voice;
//                NSLog(@"===>>>快捷下单shortcut已经添加到Siri");
//            }
//        }
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (isAdd) {
//                [weakself.addToSiriButton setTitle:@"edit Siri" forState:UIControlStateNormal];
//                weakself.currentShortCut = shortcut;
//            }else{
//                [weakself.addToSiriButton setTitle:@"add to Siri" forState:UIControlStateNormal];
//            }
//        });
//
//    }];
//}

#pragma mark - INUIAddVoiceShortcutViewControllerDelegate
- (void)addVoiceShortcutViewControllerDidCancel:(INUIAddVoiceShortcutViewController *)controller
API_AVAILABLE(ios(12.0)){
    NSLog(@"%s",__func__);
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)addVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error  API_AVAILABLE(ios(12.0)){
    if (controller) {
        __weak typeof(self) weakself = self;
        [controller dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
#pragma mark - INUIEditVoiceShortcutViewControllerDelegate
/*!
 @abstract Called if the user updates the voice shortcut, with either the successfully-updated voice shortcut, or an error.
 @discussion Your implementation of this method should dismiss the view controller.
 */
- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didUpdateVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error  API_AVAILABLE(ios(12.0)){
    if (controller) {
        __weak typeof(self) weakself = self;
        [controller dismissViewControllerAnimated:YES completion:^{
          
        }];
    }
}


/*!
 @abstract Called if the user deletes the voice shortcut.
 @discussion Your implementation of this method should dismiss the view controller.
 */
- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didDeleteVoiceShortcutWithIdentifier:(NSUUID *)deletedVoiceShortcutIdentifier{
    if (controller) {
        __weak typeof(self) weakself = self;
        [controller dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

/*!
 @abstract Called if the user cancelled; no changes were made to the voice shortcut.
 @discussion Your implementation of this method should dismiss the view controller.
 */
- (void)editVoiceShortcutViewControllerDidCancel:(INUIEditVoiceShortcutViewController *)controller{
    if (controller) {
        __weak typeof(self) weakself = self;
        [controller dismissViewControllerAnimated:YES completion:^{
           
        }];
    }
}

@end
