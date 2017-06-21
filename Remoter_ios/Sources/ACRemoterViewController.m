/*
 ============================================================================
 Name        : ACRemoterViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 空调遥控器
 ============================================================================
 */

#import "ACRemoterViewController.h"
#import "LocalizedStringTool.h"
#import "ACOtherButtonsView.h"
#import "BIRKeyOption.h"
#import "ACRemoterMatchViewController.h"
#import "UIUtil.h"
#import "DeviceManager.h"
#import "AppDelegate.h"
#import "REMenu.h"
#import "DeviceTypeListViewController.h"
#import "WifiSettingViewController.h"
#import "LEDViewController.h"
#import "PowerSwitchViewController.h"
#import "WifiIRDeviceListViewController.h"
#import "BomeansIRKit.h"
#import "myHW.h"

@interface ACRemoterViewController()
{
    IBOutlet UIScrollView* __weak _contentView;
    IBOutlet UIButton* __weak _powerButton;
    IBOutlet UIButton* __weak _modeButton;
    IBOutlet UIButton* __weak _temperatureUpButton;
    IBOutlet UIButton* __weak _temperatureDownButton;
    IBOutlet UIButton* __weak _swingUpDownButton;
    IBOutlet UIButton* __weak _swingLeftRightButton;
    IBOutlet UIButton* __weak _timerButton;
    IBOutlet UIButton* __weak _fanSpeedButton;
    IBOutlet UIImageView* __weak _modeImageView;
    IBOutlet UILabel* __weak _fanspeedLabel;
    IBOutlet UILabel* __weak _temperatureLabel;
    IBOutlet UIImageView* __weak _swingUpDownImageView;
    IBOutlet UIImageView* __weak _swingLeftRightImageView;
    IBOutlet UIView* __weak _lcdView;
    IBOutlet UIButton* __weak _matchButton;
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UIImageView* __weak _turboImageView;
    IBOutlet UIImageView* __weak _airSwapImageView;
    IBOutlet UIImageView* __weak _lightImageView;
    IBOutlet UIImageView* __weak _warmUpImageView;
    IBOutlet UIImageView* __weak _sleepImageView;
    IBOutlet UIImageView* __weak _airCleanImageView;
    IBOutlet UIButton* __weak _irStateButton;
    
    NSMutableArray* _keyArray;
    
    NSMutableArray* _powerArray;
    NSMutableArray* _modeArray;
    NSMutableArray* _temperatureArray;
    NSMutableArray* _fanspeedArray;
    NSMutableArray* _swingUpDownArray;
    NSMutableArray* _swingLeftRightArray;
    NSMutableArray* _turboArray;
    NSMutableArray* _airSwapArray;
    NSMutableArray* _lightArray;
    NSMutableArray* _warmUpArray;
    NSMutableArray* _sleepArray;
    NSMutableArray* _airCleanArray;
    
    ACOtherButtonsView* _otherButtonsView;
    
    REMenu* _menu;
    
    BomeansIRKit* _bomeansIrKit;
    
    //DeviceManager *_deviceManager;
}

@end

@implementation ACRemoterViewController

@synthesize device;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceRefreshNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WifiIRStateChangedNotification" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        _otherButtonsView = [[[NSBundle mainBundle] loadNibNamed:@"ACOtherButtonsView" owner:nil options:nil] objectAtIndex:0];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceChangedNotification:) name:@"DeviceChangedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceRefreshNotification:) name:@"DeviceRefreshNotification" object:nil];
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
    
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_POWER", @"key", _powerButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_MODE", @"key", _modeButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_TEMP", @"key", _temperatureUpButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_TEMP", @"key", _temperatureDownButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_AIRSWING_UD", @"key", _swingUpDownButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_AIRSWING_LR", @"key", _swingLeftRightButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_TIMER", @"key", _timerButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_ACKEY_FANSPEED", @"key", _fanSpeedButton, @"value", nil]];
    
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
    
    [self reloadData];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)reloadData
{
    _powerArray = [self.device.remoter getKeyOption:@"IR_ACKEY_POWER"].options;
    _modeArray = [self.device.remoter getKeyOption:@"IR_ACKEY_MODE"].options;
    _temperatureArray = [self.device.remoter getKeyOption:@"IR_ACKEY_TEMP"].options;
    _fanspeedArray = [self.device.remoter getKeyOption:@"IR_ACKEY_FANSPEED"].options;
    _swingUpDownArray = [self.device.remoter getKeyOption:@"IR_ACKEY_AIRSWING_UD"].options;
    _swingLeftRightArray = [self.device.remoter getKeyOption:@"IR_ACKEY_AIRSWING_LR"].options;
    _turboArray = [self.device.remoter getKeyOption:@"IR_ACKEY_TURBO"].options;
    _airSwapArray = [self.device.remoter getKeyOption:@"IR_ACKEY_AIRSWAP"].options;
    _lightArray = [self.device.remoter getKeyOption:@"IR_ACKEY_LIGHT"].options;
    _warmUpArray = [self.device.remoter getKeyOption:@"IR_ACKEY_WARMUP"].options;
    _sleepArray = [self.device.remoter getKeyOption:@"IR_ACKEY_SLEEP"].options;
    _airCleanArray = [self.device.remoter getKeyOption:@"IR_ACKEY_AIRCLEAN"].options;
    
    self.device.power = [_powerArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_POWER"].currentOption];
    self.device.mode = [_modeArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_MODE"].currentOption];
    self.device.temperature = [_temperatureArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_TEMP"].currentOption];
    self.device.fanspeed = [_fanspeedArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_FANSPEED"].currentOption];
    self.device.swingUpDown = nil == _swingUpDownArray ? @"IR_ACOPT_AIRSWING_UD_OFF" : [_swingUpDownArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_AIRSWING_UD"].currentOption];
    self.device.swingLeftRight = nil == _swingLeftRightArray ? @"IR_ACOPT_AIRSWING_LR_OFF" : [_swingLeftRightArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_AIRSWING_LR"].currentOption];
    self.device.turbo = nil == _turboArray ? @"IR_ACOPT_TURBO_OFF" : [_turboArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_TURBO"].currentOption];
    self.device.airSwap = nil == _airSwapArray ? @"IR_ACOPT_AIRSWAP_OFF" : [_airSwapArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_AIRSWAP"].currentOption];
    self.device.light = nil == _lightArray ? @"IR_ACOPT_LIGHT_OFF" : [_lightArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_LIGHT"].currentOption];
    self.device.warmUp = nil == _warmUpArray ? @"IR_ACOPT_WARMUP_OFF" : [_warmUpArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_WARMUP"].currentOption];
    self.device.sleep = nil == _sleepArray ? @"IR_ACOPT_SLEEP_OFF" : [_sleepArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_SLEEP"].currentOption];
    self.device.airClean = nil == _airCleanArray ? @"IR_ACOPT_AIRCLEAN_OFF" : [_airCleanArray objectAtIndex:[self.device.remoter getKeyOption:@"IR_ACKEY_AIRCLEAN"].currentOption];
    
    if (NSOrderedSame == [@"IR_ACOPT_POWER_OFF" compare:self.device.power])
    {
        _lcdView.hidden = YES;
        
        [_powerButton setBackgroundImage:[UIImage imageNamed:@"摇控器初始化界面-电源-关.png"] forState:UIControlStateNormal];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_POWER_ON" compare:self.device.power])
    {
        _lcdView.hidden = NO;
        
        [_powerButton setBackgroundImage:[UIImage imageNamed:@"摇控器初始化界面-电源-开.png"] forState:UIControlStateNormal];
    }
    
    if (NSOrderedSame == [@"IR_ACOPT_MODE_AUTO" compare:self.device.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"摇控器初始化界面-空调-屏显内容-自动.png"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_COOL" compare:self.device.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"摇控器初始化界面-空调-屏显内容-冷.png"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_DRY" compare:self.device.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"摇控器初始化界面-空调-屏显内容-抽湿.png"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_FAN" compare:self.device.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"摇控器初始化界面-空调-屏显内容-送风.png"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_MODE_WARM" compare:self.device.mode])
    {
        _modeImageView.image = [UIImage imageNamed:@"摇控器初始化界面-空调-屏显内容-热.png"];
    }
    
    if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_A" compare:self.device.fanspeed])
    {
        //_fanspeedLabel.text = [NSString stringWithFormat:L(@"FanSpeedA"), @"自动"];
        _fanspeedLabel.text = L(@"FanSpeedA");
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_L" compare:self.device.fanspeed])
    {
        _fanspeedLabel.text = [NSString stringWithFormat:L(@"FanSpeed"), @"低"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_M" compare:self.device.fanspeed])
    {
        _fanspeedLabel.text = [NSString stringWithFormat:L(@"FanSpeed"), @"中"];
    }
    else if (NSOrderedSame == [@"IR_ACOPT_FANSPEED_H" compare:self.device.fanspeed])
    {
        _fanspeedLabel.text = [NSString stringWithFormat:L(@"FanSpeed"), @"高"];
    }
    
    NSRange range = [self.device.temperature rangeOfString:@"IR_ACSTATE_TEMP_"];
    if (NSNotFound != range.location)
    {
        _temperatureLabel.text = [self.device.temperature substringFromIndex:range.location+range.length];
    }
    else
    {
        NSRange range = [self.device.temperature rangeOfString:@"IR_ACOPT_TEMP_"];
        if (NSNotFound != range.location)
        {
            _temperatureLabel.text = [self.device.temperature substringFromIndex:range.location+range.length];
        }
    }
    
    if (self.device.swingUpDown.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRSWING_UD_OFF" compare:self.device.swingUpDown])
    {
        _swingUpDownImageView.hidden = NO;
    }
    else
    {
        _swingUpDownImageView.hidden = YES;
    }
    
    if (self.device.swingLeftRight.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRSWING_LR_OFF" compare:self.device.swingLeftRight])
    {
        _swingLeftRightImageView.hidden = NO;
    }
    else
    {
        _swingLeftRightImageView.hidden = YES;
    }
    
    if (self.device.turbo.length > 0 && NSOrderedSame != [@"IR_ACOPT_TURBO_OFF" compare:self.device.turbo])
    {
        _turboImageView.hidden = NO;
    }
    else
    {
        _turboImageView.hidden = YES;
    }
    
    if (self.device.airSwap.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRSWAP_OFF" compare:self.device.airSwap])
    {
        _airSwapImageView.hidden = NO;
    }
    else
    {
        _airSwapImageView.hidden = YES;
    }
    
    if (self.device.light.length > 0 && NSOrderedSame != [@"IR_ACOPT_LIGHT_OFF" compare:self.device.light])
    {
        _lightImageView.hidden = NO;
    }
    else
    {
        _lightImageView.hidden = YES;
    }
    
    if (self.device.warmUp.length > 0 && NSOrderedSame != [@"IR_ACOPT_WARMUP_OFF" compare:self.device.warmUp])
    {
        _warmUpImageView.hidden = NO;
    }
    else
    {
        _warmUpImageView.hidden = YES;
    }
    
    if (self.device.sleep.length > 0 && NSOrderedSame != [@"IR_ACOPT_SLEEP_OFF" compare:self.device.sleep])
    {
        _sleepImageView.hidden = NO;
    }
    else
    {
        _sleepImageView.hidden = YES;
    }
    
    if (self.device.airClean.length > 0 && NSOrderedSame != [@"IR_ACOPT_AIRCLEAN_OFF" compare:self.device.airClean])
    {
        _airCleanImageView.hidden = NO;
    }
    else
    {
        _airCleanImageView.hidden = YES;
    }
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
            [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 260.0f) inView:appDelegate.window];
        }
        else
        {
            [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 216.0f) inView:appDelegate.window];
        }
    }
}

- (IBAction)keyButtonClicked:(id)sender
{
    if (sender != _powerButton && NSOrderedSame != [@"IR_ACOPT_POWER_ON" compare:self.device.power])
    {
        return;
    }
    
    for (NSDictionary* dict in _keyArray)
    {
        if (sender == [dict objectForKey:@"value"])
        {
            if (sender == _temperatureUpButton)
            {
                NSString* temperature = [self getTemperatureUp];
                [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:temperature];
            }
            else if (sender == _temperatureDownButton)
            {
                NSString* temperature = [self getTemperatureDown];
                [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:temperature];
            }
            else
            {
                [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:nil];
            }
            
            break;
        }
    }
    
    [self reloadData];
}

- (NSString*)getNextMode
{
    NSString* mode = nil;
    
    for (int i = 0; i < _modeArray.count; i++)
    {
        if (NSOrderedSame == [self.device.mode compare:[_modeArray objectAtIndex:i]])
        {
            if (i < _modeArray.count-1)
            {
                mode = [_modeArray objectAtIndex:i+1];
            }
            else
            {
                mode = [_modeArray objectAtIndex:0];
            }
            
            break;
        }
    }
    
    return mode;
}

- (NSString*)getTemperatureUp
{
    NSString* temperature = nil;
    
    for (int i = 0; i < _temperatureArray.count; i++)
    {
        if (NSOrderedSame == [self.device.temperature compare:[_temperatureArray objectAtIndex:i]])
        {
            if (i < _temperatureArray.count-1)
            {
                temperature = [_temperatureArray objectAtIndex:i+1];
            }
            else
            {
                temperature = self.device.temperature;
            }
            
            break;
        }
    }
    
    return temperature;
}

- (NSString*)getTemperatureDown
{
    NSString* temperature = nil;
    
    for (int i = 0; i < _temperatureArray.count; i++)
    {
        if (NSOrderedSame == [self.device.temperature compare:[_temperatureArray objectAtIndex:i]])
        {
            if (i > 0)
            {
                temperature = [_temperatureArray objectAtIndex:i-1];
            }
            else
            {
                temperature = self.device.temperature;
            }
            
            break;
        }
    }
    
    return temperature;
}

- (NSString*)getNextFanspeed
{
    NSString* fanspeed = nil;
    
    for (int i = 0; i < _fanspeedArray.count; i++)
    {
        if (NSOrderedSame == [self.device.fanspeed compare:[_fanspeedArray objectAtIndex:i]])
        {
            if (i < _fanspeedArray.count-1)
            {
                fanspeed = [_fanspeedArray objectAtIndex:i+1];
            }
            else
            {
                fanspeed = [_fanspeedArray objectAtIndex:0];
            }
            
            break;
        }
    }
    
    return fanspeed;
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
                ACRemoterMatchViewController* viewController = [[ACRemoterMatchViewController alloc] init];
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

- (void)handleDeviceRefreshNotification:(NSNotification*)notification
{
    [self reloadData];
}

- (void)handleWifiIRStateChangedNotification:(NSNotification*)notification
{
    [_irStateButton setTitle:([[DeviceManager sharedInstance] wifiIRState]) ? L(@"DeviceConnected") : L(@"DeviceNotConnected") forState:UIControlStateNormal];
}

@end
