//
//  ZJSAddUserActivityViewController.m
//  ZJSShortcutDemo
//
//  Created by 周建顺 on 2019/1/28.
//  Copyright © 2019 周建顺. All rights reserved.
//

#import "ZJSAddUserActivityViewController.h"

#import <CoreSpotlight/CoreSpotlight.h>
#import <Intents/NSUserActivity+IntentsAdditions.h>

#import <IntentsUI/IntentsUI.h>
#import <Intents/Intents.h>

@interface ZJSAddUserActivityViewController ()<INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate>

@property (nonatomic, strong) INUIAddVoiceShortcutViewController *addShortcutVC;
@property (nonatomic, strong) INUIEditVoiceShortcutViewController *editShortcutVC;
@property (weak, nonatomic) IBOutlet UIButton *addToSiriButton;

@property (nonatomic, strong) INVoiceShortcut *currentShortcut;

@end

@implementation ZJSAddUserActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self tryGetShortcut];
}
- (IBAction)addAction:(id)sender {
    [self addCreateOrderActivity];
}

- (IBAction)addToSiriAction:(id)sender {
    
    [self suggestUserAddShortcutToSiri];
}

#pragma mark - 添加到搜索框

///MARK:donate shortcuts
- (void)addCreateOrderActivity {
    //根据plist文件的值，创建 UserActivity
    NSUserActivity *checkInActivity = [[NSUserActivity alloc] initWithActivityType:@"com.rippleinfo.orderquilkly"];
    //设置 YES，通过系统的搜索，可以搜索到该 UserActivity
    checkInActivity.eligibleForSearch = YES;
    //允许系统预测用户行为，并在合适的时候给出提醒。（搜索界面，屏锁界面等。）
    if (@available(iOS 12.0, *)) {
        checkInActivity.eligibleForPrediction = YES;
    }
    checkInActivity.title = @"咖啡快捷下单";
    checkInActivity.userInfo = @{@"key1":@"value1"};
    checkInActivity.keywords = [NSSet setWithObjects:@"咖啡",@"下单", nil];
    //引导用户新建语音引导（具体效果见下图）
    if (@available(iOS 12.0, *)) {
        
        checkInActivity.suggestedInvocationPhrase = @"咖啡下单";
    }
    CSSearchableItemAttributeSet * attributes = [[CSSearchableItemAttributeSet alloc] init];
    UIImage *icon = [UIImage imageNamed:@"1"];
    attributes.thumbnailData = UIImagePNGRepresentation(icon);
    attributes.contentDescription = @"每天一杯咖啡，Lucy in coffee";
    checkInActivity.contentAttributeSet = attributes;
    self.userActivity = checkInActivity;
}


#pragma mark -  添加到siri

-(void)tryGetShortcut{
    if (@available(iOS 12.0, *)) {
        __weak typeof(self) weakself = self;
        [[INVoiceShortcutCenter sharedCenter] getAllVoiceShortcutsWithCompletion:^(NSArray<INVoiceShortcut *> * _Nullable voiceShortcuts, NSError * _Nullable error) {
            BOOL isAdd = NO;
            INVoiceShortcut *shortcut = nil;
            for (INVoiceShortcut *voice in voiceShortcuts) {
                NSLog(@"====>>获取到的VoiceShortcuts :%@",voice.shortcut.userActivity.activityType);
                if ([voice.shortcut.userActivity.activityType isEqualToString:@"com.rippleinfo.orderquilkly"]) {
                    isAdd = YES;
                    shortcut = voice;
                    NSLog(@"===>>>快捷下单shortcut已经添加到Siri");
                }
            }
            if (isAdd) {
                weakself.currentShortcut = shortcut;
                [weakself.addToSiriButton setTitle:@"编辑siri" forState:UIControlStateNormal];
            }else{
                weakself.currentShortcut = nil;
                [weakself.addToSiriButton setTitle:@"添加到siri" forState:UIControlStateNormal];
            }
            
        }];
    }
}

///MARK:建议用户添加shortcuta到Siri短语
- (void)suggestUserAddShortcutToSiri {
    
    
    if (self.currentShortcut) {
        [self openEditVoiceVC:self.currentShortcut];
    } else {
        if (!self.userActivity) {
            [self addCreateOrderActivity];
        }
        [self openAddVoiceVC];
    }
}


///MARK:打开Siri添加短语页面
- (void)openAddVoiceVC {
    if (@available(iOS 12.0, *)) {
        INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:self.userActivity];
        INUIAddVoiceShortcutViewController *addVc = [[INUIAddVoiceShortcutViewController alloc] initWithShortcut:shortcut];
        if (!addVc.delegate) {
            addVc.delegate = self;
        }
        __weak typeof(self) weakself = self;
        [self presentViewController:addVc animated:YES completion:^{
            __strong typeof(self) self = weakself;
            self.addShortcutVC = addVc;
        }];
    }
}
///MARK:打开Siri编辑短语页面
- (void)openEditVoiceVC:(INVoiceShortcut *)voiceShortcut  API_AVAILABLE(ios(12.0)){
    if (@available(iOS 12.0, *)) {
        //        INShortcut *shortcut = [[INShortcut alloc] initWithUserActivity:self.userActivity];
        INUIEditVoiceShortcutViewController *editVC = [[INUIEditVoiceShortcutViewController alloc] initWithVoiceShortcut:voiceShortcut];
        if (!editVC.delegate) {
            editVC.delegate = self;
        }
        __weak typeof(self) weakself = self;
        [self presentViewController:editVC animated:YES completion:^{
            __strong typeof(self) self = weakself;
            self.editShortcutVC = editVC;
        }];
    }
}

#pragma mark - INUIAddVoiceShortcutViewControllerDelegate
- (void)addVoiceShortcutViewControllerDidCancel:(INUIAddVoiceShortcutViewController *)controller
API_AVAILABLE(ios(12.0)){
    NSLog(@"%s",__func__);
}
- (void)addVoiceShortcutViewController:(INUIAddVoiceShortcutViewController *)controller didFinishWithVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error  API_AVAILABLE(ios(12.0)){
    if (self.addShortcutVC) {
        __weak typeof(self) weakself = self;
        [self.addShortcutVC dismissViewControllerAnimated:YES completion:^{
            [weakself tryGetShortcut];
        }];
    }
}
#pragma mark - INUIEditVoiceShortcutViewControllerDelegate
/*!
 @abstract Called if the user updates the voice shortcut, with either the successfully-updated voice shortcut, or an error.
 @discussion Your implementation of this method should dismiss the view controller.
 */
- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didUpdateVoiceShortcut:(nullable INVoiceShortcut *)voiceShortcut error:(nullable NSError *)error  API_AVAILABLE(ios(12.0)){
    if (self.editShortcutVC) {
        __weak typeof(self) weakself = self;
        [self.editShortcutVC dismissViewControllerAnimated:YES completion:^{
            [weakself tryGetShortcut];
        }];
    }
}


/*!
 @abstract Called if the user deletes the voice shortcut.
 @discussion Your implementation of this method should dismiss the view controller.
 */
- (void)editVoiceShortcutViewController:(INUIEditVoiceShortcutViewController *)controller didDeleteVoiceShortcutWithIdentifier:(NSUUID *)deletedVoiceShortcutIdentifier{
    if (self.editShortcutVC) {
        __weak typeof(self) weakself = self;
        [self.editShortcutVC dismissViewControllerAnimated:YES completion:^{
            [weakself tryGetShortcut];
        }];
    }
}

/*!
 @abstract Called if the user cancelled; no changes were made to the voice shortcut.
 @discussion Your implementation of this method should dismiss the view controller.
 */
- (void)editVoiceShortcutViewControllerDidCancel:(INUIEditVoiceShortcutViewController *)controller{
    if (self.editShortcutVC) {
        __weak typeof(self) weakself = self;
        [self.editShortcutVC dismissViewControllerAnimated:YES completion:^{
            [weakself tryGetShortcut];
        }];
    }
}
@end

