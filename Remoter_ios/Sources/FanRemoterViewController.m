/*
 ============================================================================
 Name        : FanRemoterViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 风扇
 ============================================================================
 */

#import "FanRemoterViewController.h"
#import "LocalizedStringTool.h"
#import "FanOtherButtonsView.h"
#import "FanRemoterMatchViewController.h"
#import "UIUtil.h"
#import "DeviceManager.h"
#import "AppDelegate.h"
#import "REMenu.h"
#import "DeviceTypeListViewController.h"
#import "WifiSettingViewController.h"
#import "LEDViewController.h"
#import "PowerSwitchViewController.h"
#import "WifiIRDeviceListViewController.h"


@interface FanRemoterViewController()
{
    IBOutlet UIScrollView* __weak _contentView;
    IBOutlet UIButton* __weak _powerButton;
    IBOutlet UIButton* __weak _timerButton;
    IBOutlet UIButton* __weak _swingButton;
    IBOutlet UIButton* __weak _windClassButton;
    IBOutlet UIButton* __weak _airVolumnButton;
    IBOutlet UIButton* __weak _matchButton;
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UIButton* __weak _irStateButton;
    
    NSMutableArray* _keyArray;
    
    FanOtherButtonsView* _otherButtonsView;
    
    REMenu* _menu;
}

@end

@implementation FanRemoterViewController

@synthesize device;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WifiIRStateChangedNotification" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        _otherButtonsView = [[[NSBundle mainBundle] loadNibNamed:@"FanOtherButtonsView" owner:nil options:nil] objectAtIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceChangedNotification:) name:@"DeviceChangedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWifiIRStateChangedNotification:) name:@"WifiIRStateChangedNotification" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@(%@)", self.device.brandName, self.device.typeName];
    
    [_irStateButton setTitle:([[DeviceManager sharedInstance] wifiIRState]) ? L(@"DeviceConnected") : L(@"DeviceNotConnected") forState:UIControlStateNormal];
    
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, 428.f);
    
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_FAN_POWER", @"key", _powerButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_FAN_TIMER", @"key", _timerButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_FAN_SWING", @"key", _swingButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_FAN_WINDCLASS", @"key", _windClassButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_FAN_AIRVOLUME", @"key", _airVolumnButton, @"value", nil]];
    
    for (NSDictionary* dict in _keyArray)
    {
        BOOL isFound = NO;
        
        NSString* strKey = [dict objectForKey:@"key"];
        for (NSString* strKey2 in self.device.keys)
        {
            if (NSOrderedSame == [strKey caseInsensitiveCompare:strKey2])
            {
                isFound = YES;
                break;
            }
        }
        
        if (isFound)
        {
            [[dict objectForKey:@"value"] setHidden:NO];
            [[dict objectForKey:@"value"] setEnabled:YES];
            [[dict objectForKey:@"value"] setAlpha:1.0f];
        }
        else
        {
            //[[dict objectForKey:@"value"] setHidden:YES];
            [[dict objectForKey:@"value"] setEnabled:NO];
            [[dict objectForKey:@"value"] setAlpha:0.6f];
        }
    }
    
    if ([self.device.remoter getModuleName].length > 0)
    {
        _matchButton.hidden = YES;
    }
    else
    {
        _matchButton.hidden = NO;
    }
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
    [array addObjectsFromArray:_keyArray];
    _otherButtonsView.mainKeyArray = array;
    _otherButtonsView.device = self.device;
    [_otherButtonsView reloadData];
    
    UIButton* button1 = [_contentView viewWithTag:201];
    UIButton* button3 = [_contentView viewWithTag:203];
    UIButton* button6 = [_contentView viewWithTag:206];
    [button1 setBackgroundImage:[UIImage imageNamed:L(@"ImageFanSpeed")] forState:UIControlStateNormal];
    [button3 setBackgroundImage:[UIImage imageNamed:L(@"ImageSwing")] forState:UIControlStateNormal];
    [button6 setBackgroundImage:[UIImage imageNamed:L(@"ImageWindClass")] forState:UIControlStateNormal];

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

- (IBAction)backButtonClicked:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    
    //CATransition* animation = [CATransition animation];
    //animation.delegate = self;
    //animation.duration = 0.33f;
    //animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //animation.type = kCATransitionReveal;
    //animation.subtype = kCATransitionFromLeft;
    
    //[self.view.superview.layer addAnimation:animation forKey:@"animation"];
    
    [self.view removeFromSuperview];
}

- (IBAction)wifiIRButtonClicked:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    WifiIRDeviceListViewController* viewController = [[WifiIRDeviceListViewController alloc] init];
    [appDelegate.navController pushViewController:viewController animated:YES];
}

- (IBAction)menuButtonClicked:(id)sender
{
    if (nil == _menu)
    {
        _menu = [[REMenu alloc] initWithItems:nil];
        _menu.bounce = NO;
        _menu.useBlurEffect              = YES;
        _menu.backgroundColor            = [UIColor blackColor];
        _menu.separatorColor             = [UIColor blackColor];
        _menu.separatorHeight            = 1.0f;
        _menu.highlightedSeparatorColor  = [UIColor darkGrayColor];
        _menu.highlightedBackgroundColor = [UIColor darkGrayColor];
        _menu.borderWidth                = 1.0f;
        _menu.borderColor                = [UIColor blackColor];
        _menu.itemHeight                 = 40.0f;
        _menu.font                       = [UIFont boldSystemFontOfSize:15.0f];
        _menu.textShadowColor            = [UIColor clearColor];
        _menu.highlightedTextShadowColor = [UIColor clearColor];
        _menu.textAlignment              = NSTextAlignmentCenter;
        _menu.textColor                  = [UIColor whiteColor];
        _menu.highlightedTextColor       = [UIColor whiteColor];
        _menu.textOffset                 = CGSizeMake(6, 0);
        
        if (!REUIKitIsFlatMode())
        {
            _menu.shadowRadius = 4;
            _menu.shadowColor = [UIColor grayColor];
            _menu.shadowOffset = CGSizeMake(0, 1);
            _menu.shadowOpacity = 1;
        }
    }
    
    if (_menu.isOpen)
    {
        [_menu close];
    }
    else
    {
        NSMutableArray* itemArray = [NSMutableArray arrayWithCapacity:1];
        REMenuItem* item = [[REMenuItem alloc] initWithTitle:L(@"AddRemoter") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-增加遥控.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                            {
                                //if ([DeviceManager sharedInstance].deviceArray.count < 10)
                                {
                                    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                    
                                    DeviceTypeListViewController* viewController = [[DeviceTypeListViewController alloc] init];
                                    [appDelegate.navController pushViewController:viewController animated:YES];
                                }
                                //else
                                //{
                                //    [UIUtil showWarning:@"最多只能创建10个遥控器" title:nil delegate:nil];
                                //}
                            }];
        [itemArray addObject:item];
        
        REMenuItem* item2 = [[REMenuItem alloc] initWithTitle:L(@"WifiSetting") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-增加遥控.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                             {
                                 AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                 
                                 WifiSettingViewController* viewController = [[WifiSettingViewController alloc] init];
                                 [appDelegate.navController pushViewController:viewController animated:YES];
                             }];
        [itemArray addObject:item2];
        
        REMenuItem* item3 = [[REMenuItem alloc] initWithTitle:L(@"LEDSetting") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                             {
                                 AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                 
                                 LEDViewController* viewController = [[LEDViewController alloc] init];
                                 [appDelegate.navController pushViewController:viewController animated:YES];
                             }];
        [itemArray addObject:item3];
        
        REMenuItem* item4 = [[REMenuItem alloc] initWithTitle:L(@"PowerSwitch") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                             {
                                 AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                                 
                                 PowerSwitchViewController* viewController = [[PowerSwitchViewController alloc] init];
                                 [appDelegate.navController pushViewController:viewController animated:YES];
                             }];
        [itemArray addObject:item4];
        
        if (!([self.device.remoter getModuleName].length > 0))
        {
            REMenuItem* item5 = [[REMenuItem alloc] initWithTitle:L(@"MatchRemoter") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                                 {
                                     [self matchButtonClicked:nil];
                                 }];
            [itemArray addObject:item5];
        }
        
        //判斷使用遠端還近端
        NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
        NSString *wifiRoIr =[defaultValue stringForKey:@"wifiToIR"];
        if([wifiRoIr isEqual:@"cloud"]){
            
            REMenuItem* item6 = [[REMenuItem alloc] initWithTitle:L(@"SetLocalWifiToIr") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                                 {
                                     [[DeviceManager sharedInstance] setLocalWifiToIr];
                                 }];
            [itemArray addObject:item6];
        }
        else
        {
            REMenuItem* item6 = [[REMenuItem alloc] initWithTitle:L(@"SetCloudWifiToIr") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                                 {
                                     [[DeviceManager sharedInstance] setCloudWifiToIr];
                                 }];
            [itemArray addObject:item6];
        }
        
        _menu.items = itemArray;
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        if (!([self.device.remoter getModuleName].length > 0))
        {
            [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 256.0f) inView:appDelegate.window];
        }
        else
        {
            [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 216.0f) inView:appDelegate.window];
        }
    }
}

- (IBAction)keyButtonClicked:(id)sender
{
    for (NSDictionary* dict in _keyArray)
    {
        if (sender == [dict objectForKey:@"value"])
        {
            [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:nil];
            break;
        }
    }
}

- (IBAction)othersButtonClicked:(id)sender
{
    _otherButtonsView.frame = self.view.bounds;
    
    [_contentView addSubview:_otherButtonsView];
}

- (IBAction)matchButtonClicked:(id)sender
{
    [UIUtil showProgressHUD:L(@"HintRequesting") inView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    ^{
        NSArray* array = [[DeviceManager sharedInstance] getDeviceModelList:self.device.typeID brandID:self.device.brandID];
       
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [UIUtil hideProgressHUD];
                          
            if (array.count > 0)
            {
                FanRemoterMatchViewController* viewController = [[FanRemoterMatchViewController alloc] init];
                viewController.device = self.device;
                viewController.modelArray = array;
                
                AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
                [appDelegate.navController pushViewController:viewController animated:YES];
            }
            else
            {
                [UIUtil showWarning:L(@"HintNoFoundRemoter") title:nil delegate:nil];
            }
        });
   });
}

- (void)handleDeviceChangedNotification:(NSNotification*)notification
{
    for (NSDictionary* dict in _keyArray)
    {
        BOOL isFound = NO;
        
        NSString* strKey = [dict objectForKey:@"key"];
        for (NSString* strKey2 in self.device.keys)
        {
            if (NSOrderedSame == [strKey caseInsensitiveCompare:strKey2])
            {
                isFound = YES;
                break;
            }
        }
        
        if (isFound)
        {
            [[dict objectForKey:@"value"] setHidden:NO];
            [[dict objectForKey:@"value"] setEnabled:YES];
            [[dict objectForKey:@"value"] setAlpha:1.0f];
        }
        else
        {
            //[[dict objectForKey:@"value"] setHidden:YES];
            [[dict objectForKey:@"value"] setEnabled:NO];
            [[dict objectForKey:@"value"] setAlpha:0.6f];
        }
    }
    
    if ([self.device.remoter getModuleName].length > 0)
    {
        _matchButton.hidden = YES;
    }
    else
    {
        _matchButton.hidden = NO;
    }
    
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:1];
    [array addObjectsFromArray:_keyArray];
    _otherButtonsView.mainKeyArray = array;
    _otherButtonsView.device = self.device;
    [_otherButtonsView reloadData];
}

- (void)handleWifiIRStateChangedNotification:(NSNotification*)notification
{
    [_irStateButton setTitle:([[DeviceManager sharedInstance] wifiIRState]) ? L(@"DeviceConnected") : L(@"DeviceNotConnected") forState:UIControlStateNormal];
}

@end
