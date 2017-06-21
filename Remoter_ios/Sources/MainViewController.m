/*
 ============================================================================
 Name        : MainViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The main view controller
 ============================================================================
 */

#import "MainViewController.h"
#import "HomeViewController.h"
#import "LocalizedStringTool.h"
#import "DeviceManager.h"
#import "AppDelegate.h"
#import "SETTOPDevice.h"
#import "SETTOPRemoterViewController.h"
#import "FanDevice.h"
#import "FanRemoterViewController.h"
#import "DVDDevice.h"
#import "DVDRemoterViewController.h"
#import "MP3Device.h"
#import "MP3RemoterViewController.h"
#import "AMPDevice.h"
#import "AMPRemoterViewController.h"
#import "TVRemoterViewController.h"
#import "ACRemoterViewController.h"
#import "REMenu.h"
#import "DeviceTypeListViewController.h"
#import "WifiSettingViewController.h"
#import "LEDViewController.h"
#import "PowerSwitchViewController.h"

#import "TVDevice.h"
#import "DefaultRemoteViewController.h"
#import "GameDevice.h"
#import "GameRemoteViewController.h"
#import "PJDevice.h"
#import "PJRemoteViewController.h"
#import "RobotDevice.h"
#import "RobotRemoteViewController.h"

@interface MainViewController () <UIAlertViewDelegate>
{
    IBOutlet UIButton* _homeButton;
    IBOutlet UIView* _tabView;
    IBOutlet UIView* _canvas;
    IBOutlet UIView* _remoter01View;
    IBOutlet UIView* _remoter02View;
    IBOutlet UIView* _remoter03View;
    IBOutlet UIView* _remoter04View;
    IBOutlet UIView* _remoter05View;
    IBOutlet UILabel* _remoter01Label;
    IBOutlet UILabel* _remoter02Label;
    IBOutlet UILabel* _remoter03Label;
    IBOutlet UILabel* _remoter04Label;
    IBOutlet UILabel* _remoter05Label;
    IBOutlet UIImageView* _remoter01ImageView;
    IBOutlet UIImageView* _remoter02ImageView;
    IBOutlet UIImageView* _remoter03ImageView;
    IBOutlet UIImageView* _remoter04ImageView;
    IBOutlet UIImageView* _remoter05ImageView;
    
    HomeViewController* _homeViewController;
    
    UIView* _currView;
    
    UIViewController* _subViewController;
    
    REMenu* _menu;
    
    Device* _currentDevice;
}

@end

@implementation MainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceListChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ShowDeviceNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeleteDeviceNotification" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _homeViewController = [[HomeViewController alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceListChangedNotification:) name:DeviceListChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceChangedNotification:) name:@"DeviceChangedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleShowDeviceNotification:) name:@"ShowDeviceNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeleteDeviceNotification:) name:@"DeleteDeviceNotification" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _homeViewController.view.frame = CGRectMake(_canvas.frame.origin.x, 0, _canvas.frame.size.width, _canvas.frame.size.height);
    
    UILongPressGestureRecognizer* longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoter01LongPressed:)];
    [_remoter01View addGestureRecognizer:longGesture];
    UILongPressGestureRecognizer* longGesture2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoter02LongPressed:)];
    [_remoter02View addGestureRecognizer:longGesture2];
    UILongPressGestureRecognizer* longGesture3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoter03LongPressed:)];
    [_remoter03View addGestureRecognizer:longGesture3];
    UILongPressGestureRecognizer* longGesture4 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoter04LongPressed:)];
    [_remoter04View addGestureRecognizer:longGesture4];
    UILongPressGestureRecognizer* longGesture5 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleRemoter05LongPressed:)];
    [_remoter05View addGestureRecognizer:longGesture5];
    
    [self reloadRemoterView];
    
    if ([DeviceManager sharedInstance].deviceArray.count > 0)
    {
        Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:0];
        [self showRemoterView:device];
    }
    
    //剛開啟app時預設使用近端
    //NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    //[defaultValue setObject:@"local" forKey:@"wifiToIR"];
    //[defaultValue synchronize];
    
    [[DeviceManager sharedInstance] setLocalWifiToIr];
    UILabel *lable1 = [self.view viewWithTag:101];
    UIButton *button1 = (UIButton*) [self.view viewWithTag:201];
    lable1.text = L(@"Remoter");
    [button1 setTitle:L(@"TapToAddRemoter") forState:UIControlStateNormal];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (UIInterfaceOrientationPortrait == interfaceOrientation);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)switchToPage:(NSInteger)pageIndex
{
    switch (pageIndex)
    {
        case 0:
        {
            [_currView removeFromSuperview];
            _homeViewController.view.frame = CGRectMake(_canvas.frame.origin.x, 0, _canvas.frame.size.width, _canvas.frame.size.height);
            [_canvas addSubview:_homeViewController.view];
            _currView = _homeViewController.view;
            
            break;
        }
        default:
            break;
    }
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
        
        //判斷使用遠端還近端
        NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
        NSString *wifiRoIr =[defaultValue stringForKey:@"wifiToIR"];
        if([wifiRoIr isEqual:@"cloud"]){
            
            REMenuItem* item5 = [[REMenuItem alloc] initWithTitle:L(@"SetLocalWifiToIr") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                                 {
                                     [[DeviceManager sharedInstance] setLocalWifiToIr];
                                 }];
            [itemArray addObject:item5];
        }
        else
        {
            REMenuItem* item5 = [[REMenuItem alloc] initWithTitle:L(@"SetCloudWifiToIr") subtitle:nil image:[UIImage imageNamed:@"顶部-ico-菜单-系统设置.png"] highlightedImage:nil unreadNumber:0 action:^(REMenuItem* item)
                                 {
                                     [[DeviceManager sharedInstance] setCloudWifiToIr];
                                 }];
            [itemArray addObject:item5];
        }
        
        _menu.items = itemArray;
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 216.0f) inView:appDelegate.window];
    }
}

- (void)handleDeviceListChangedNotification:(NSNotification*)notification
{
    [self reloadRemoterView];
}

- (void)reloadRemoterView
{
    _remoter01View.hidden = YES;
    _remoter02View.hidden = YES;
    _remoter03View.hidden = YES;
    _remoter04View.hidden = YES;
    _remoter05View.hidden = YES;
    
    int index = 0;
    for (int i = 0; i < 5; i++)
    {
        int count = [DeviceManager sharedInstance].deviceArray.count;
        if (count-1 < i)
        {
            break;
        }
        
        Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:i];
        if (!device.isSelected)
        {
            continue;
        }
        
        switch (index)
        {
            case 0:
                _remoter01View.hidden = NO;
                _remoter01Label.text = device.name;
                _remoter01ImageView.image = [device iconImage];
                break;
                
            case 1:
                _remoter02View.hidden = NO;
                _remoter02Label.text = device.name;
                _remoter02ImageView.image = [device iconImage];
                break;
                
            case 2:
                _remoter03View.hidden = NO;
                _remoter03Label.text = device.name;
                _remoter03ImageView.image = [device iconImage];
                break;
                
            case 3:
                _remoter04View.hidden = NO;
                _remoter04Label.text = device.name;
                _remoter04ImageView.image = [device iconImage];
                break;
                
            case 4:
                _remoter05View.hidden = NO;
                _remoter05Label.text = device.name;
                _remoter05ImageView.image = [device iconImage];
                break;
                
            default:
                break;
        }
        
        index++;
    }
}

- (IBAction)addRemoterButtonClicked:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    DeviceTypeListViewController* viewController = [[DeviceTypeListViewController alloc] init];
    [appDelegate.navController pushViewController:viewController animated:YES];
}

- (IBAction)remoter01ButtonClicked:(id)sender
{
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:0];
    [self showRemoterView:device];
}

- (IBAction)remoter02ButtonClicked:(id)sender
{
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:1];
    [self showRemoterView:device];
}

- (IBAction)remoter03ButtonClicked:(id)sender
{
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:2];
    [self showRemoterView:device];
}

- (IBAction)remoter04ButtonClicked:(id)sender
{
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:3];
    [self showRemoterView:device];
}

- (IBAction)remoter05ButtonClicked:(id)sender
{
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:4];
    [self showRemoterView:device];
}

- (void)showRemoterView:(Device*)device
{
    if (nil == device.remoter)
    {
        if (NSOrderedSame == [device.typeID compare:@"1"])
        {
            if (device.modelID.length > 0)
            {
                device.remoter = [[DeviceManager sharedInstance] createRemoter:device.typeID brandID:device.brandID module:device.modelID];
            }
            else
            {
                device.remoter = [[DeviceManager sharedInstance] createBigRemoter:device.typeID brandID:device.brandID];
            }
        }
        else
        {
            device.remoter = [[DeviceManager sharedInstance] createRemoter:device.typeID brandID:device.brandID module:device.modelID];
        }
        
        device.keys = [device.remoter getAllKeys];
    }
    
    [_subViewController.view removeFromSuperview];
    
    //CATransition* animation = [CATransition animation];
    //animation.delegate = self;
    //animation.duration = 0.33f;
    //animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //animation.type = kCATransitionMoveIn;
    //animation.subtype = kCATransitionFromRight;
    
    //[_canvas.layer addAnimation:animation forKey:@"animation"];
    
    if ([device isKindOfClass:[ACDevice class]])
    {
        ACRemoterViewController* viewController = [[ACRemoterViewController alloc] init];
        viewController.device = (ACDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[SETTOPDevice class]])
    {
        SETTOPRemoterViewController* viewController = [[SETTOPRemoterViewController alloc] init];
        viewController.device = (SETTOPDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[DVDDevice class]])
    {
        DVDRemoterViewController* viewController = [[DVDRemoterViewController alloc] init];
        viewController.device = (DVDDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[MP3Device class]])
    {
        MP3RemoterViewController* viewController = [[MP3RemoterViewController alloc] init];
        viewController.device = (MP3Device*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[AMPDevice class]])
    {
        AMPRemoterViewController* viewController = [[AMPRemoterViewController alloc] init];
        viewController.device = (AMPDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[FanDevice class]])
    {
        FanRemoterViewController* viewController = [[FanRemoterViewController alloc] init];
        viewController.device = (FanDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[TVDevice class]])
    {
        TVRemoterViewController* viewController = [[TVRemoterViewController alloc] init];
        viewController.device = (TVDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[GameDevice class]])
    {
        GameRemoteViewController* viewController = [[GameRemoteViewController alloc] init];
        viewController.device = (GameDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[PJDevice class]])
    {
        PJRemoteViewController* viewController = [[PJRemoteViewController alloc] init];
        viewController.device = (PJDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else if ([device isKindOfClass:[RobotDevice class]])
    {
        RobotRemoteViewController* viewController = [[RobotRemoteViewController alloc] init];
        viewController.device = (RobotDevice*)device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    else
    {
        DefaultRemoteViewController* viewController = [[DefaultRemoteViewController alloc] init];
        viewController.device = device;
        //[appDelegate.navController pushViewController:viewController animated:YES];
        
        viewController.view.frame = _canvas.frame;
        [_canvas addSubview:viewController.view];
        
        _subViewController = viewController;
    }
    
    _currentDevice = device;
    
    [[DeviceManager sharedInstance].deviceArray removeObject:device];
    [[DeviceManager sharedInstance].deviceArray insertObject:device atIndex:0];
    [[DeviceManager sharedInstance] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceListChangedNotification object:nil];
}

- (void)handleDeviceChangedNotification:(NSNotification*)notification
{
    [self reloadRemoterView];
}

- (void)handleShowDeviceNotification:(NSNotification*)notification
{
    [self showRemoterView:notification.object];
}

- (void)handleDeleteDeviceNotification:(NSNotification*)notification
{
    if (notification.object == _currentDevice)
    {
        if ([DeviceManager sharedInstance].deviceArray.count > 0)
        {
            Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:0];
            [self showRemoterView:device];
        }
        else
        {
            [_subViewController.view removeFromSuperview];
            _subViewController = nil;
        }
    }
}

- (void)handleRemoter01LongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([DeviceManager sharedInstance].deviceArray.count > 5) {
            for (int i = 5; i < [DeviceManager sharedInstance].deviceArray.count; ++i) {
                Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:i];
                [alertController addAction:[UIAlertAction actionWithTitle:device.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showRemoterView:device];
                }]];
            }
        }
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"DeleteRemoter") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:0];
            [[DeviceManager sharedInstance] deleteDevice:device];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDeviceNotification" object:device];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
        {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)handleRemoter02LongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([DeviceManager sharedInstance].deviceArray.count > 5) {
            for (int i = 5; i < [DeviceManager sharedInstance].deviceArray.count; ++i) {
                Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:i];
                [alertController addAction:[UIAlertAction actionWithTitle:device.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showRemoterView:device];
                }]];
            }
        }
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"DeleteRemoter") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:1];
            [[DeviceManager sharedInstance] deleteDevice:device];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDeviceNotification" object:device];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
        {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)handleRemoter03LongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([DeviceManager sharedInstance].deviceArray.count > 5) {
            for (int i = 5; i < [DeviceManager sharedInstance].deviceArray.count; ++i) {
                Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:i];
                [alertController addAction:[UIAlertAction actionWithTitle:device.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showRemoterView:device];
                }]];
            }
        }
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"DeleteRemoter") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:2];
            [[DeviceManager sharedInstance] deleteDevice:device];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDeviceNotification" object:device];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
        {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)handleRemoter04LongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([DeviceManager sharedInstance].deviceArray.count > 5) {
            for (int i = 5; i < [DeviceManager sharedInstance].deviceArray.count; ++i) {
                Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:i];
                [alertController addAction:[UIAlertAction actionWithTitle:device.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showRemoterView:device];
                }]];
            }
        }
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"DeleteRemoter") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:3];
            [[DeviceManager sharedInstance] deleteDevice:device];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDeviceNotification" object:device];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
        {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)handleRemoter05LongPressed:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([DeviceManager sharedInstance].deviceArray.count > 5) {
            for (int i = 5; i < [DeviceManager sharedInstance].deviceArray.count; ++i) {
                Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:i];
                [alertController addAction:[UIAlertAction actionWithTitle:device.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self showRemoterView:device];
                }]];
            }
        }
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"DeleteRemoter") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:4];
            [[DeviceManager sharedInstance] deleteDevice:device];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteDeviceNotification" object:device];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
        {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}




@end
