/*
 ============================================================================
 Name        : WifiSettingViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The wifi setting view controller
 ============================================================================
 */

#import <SystemConfiguration/CaptiveNetwork.h>

#import "WifiSettingViewController.h"
#import "LocalizedStringTool.h"
#import "AppData.h"
#import "UIUtil.h"
#import "IQKeyboardManager.h"
#import "Reachability.h"
#import "FlatUIKit.h"
#import "DeviceManager.h"


@interface WifiSettingViewController() <UITextFieldDelegate, UINavigationControllerDelegate>
{
    IBOutlet UITextField* _wifiNameTextField;
    IBOutlet UITextField* _passwordTextField;
    IBOutlet UIButton* _cancelButton;
    IBOutlet UIButton* _doneButton;
    
    Reachability* _reachability;
}

@end

@implementation WifiSettingViewController

- (void)dealloc
{
    [_reachability stopNotifier];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[IQKeyboardManager sharedManager] setEnable:YES];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _wifiNameTextField.placeholder = L(@"YourWIFIName");
    _passwordTextField.placeholder   = L(@"YourWIFIPassword");
    
    [_cancelButton setTitle:L(@"Cancel") forState:UIControlStateNormal];
    [_doneButton setTitle:L(@"Save") forState:UIControlStateNormal];
    
    _wifiNameTextField.text = [self getWifiName];
    
    _reachability = [Reachability reachabilityForLocalWiFi];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    [_reachability startNotifier];
    
    UILabel *lable1 = [self.view viewWithTag:101];
    UILabel *lable2 = [self.view viewWithTag:102];
    lable1.text = L(@"WifiSetting");
    lable2.text = L(@"WifiSettingNote");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backgroundButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButtonClicked:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if ([_wifiNameTextField.text isEqualToString:@""])
    {
        [UIUtil showWarning:nil title:L(@"EmptyDeviceName") delegate:nil];
        return;
    }
    
    if ([_passwordTextField.text isEqualToString:@""])
    {
        [UIUtil showWarning:nil title:L(@"EmptyDevicePassword") delegate:nil];
        return;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[AppData wifiList]];
    [dict setObject:_passwordTextField.text forKey:_wifiNameTextField.text];
    [AppData setWifiList:dict];
    
    [UIUtil showProgressHUD:L(@"NetConfiging") inView:self.view];
    
    [[DeviceManager sharedInstance] setupWifi:_wifiNameTextField.text password:_passwordTextField.text
    completion:^()
    {
        [UIUtil hideProgressHUD];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    fail:^()
    {
        [UIUtil hideProgressHUD];
        
        [UIUtil showWarning:L(@"FailToNetConfig") title:nil delegate:nil];
    }];
}

#pragma mark － UITextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    BOOL ret = YES;
    
    if (textField == _wifiNameTextField)
    {
        [textField endEditing:YES];
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        [textField endEditing:YES];
    }
    
    return ret;
}

- (void)reachabilityChanged:(NSNotification*)note
{
    _wifiNameTextField.text = [self getWifiName];
}

- (NSString*)getWifiName
{
    NSString* wifiName = nil;
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces)
    {
        return nil;
    }
    
    NSArray* interfaces = (__bridge NSArray*)wifiInterfaces;
    
    for (NSString* interfaceName in interfaces)
    {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef)
        {
            NSDictionary* networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
            break;
        }
    }
    
    CFRelease(wifiInterfaces);
    
    return wifiName;
}

@end
