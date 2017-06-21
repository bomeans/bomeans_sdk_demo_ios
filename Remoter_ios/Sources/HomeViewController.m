/*
 ============================================================================
 Name        : HomeViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The home view controller
 ============================================================================
 */

#import <MapKit/MapKit.h>

#import "HomeViewController.h"
#import "LocalizedStringTool.h"
#import "DeviceManager.h"
#import "DeviceItemCell.h"
#import "REMenu.h"
#import "AppDelegate.h"
#import "DeviceTypeListViewController.h"
#import "TVRemoterViewController.h"
#import "ACRemoterViewController.h"
#import "WifiSettingViewController.h"
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
#import "PowerSwitchViewController.h"
#import "LEDViewController.h"
#import "UIUtil.h"


@interface HomeViewController ()
{
    IBOutlet UITableView* _tableView;
    IBOutlet UIView* _titleView;
    IBOutlet UIView* _contentView;
    
    REMenu* _menu;
}

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DeviceListChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceChangedNotification" object:nil];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceListChangedNotification:) name:DeviceListChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceChangedNotification:) name:@"DeviceChangedNotification" object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *lable1 = [self.view viewWithTag:101];
    UIButton *button1 = (UIButton*) [self.view viewWithTag:201];
    lable1.text = L(@"Remoter");
    [button1 setTitle:L(@"TapToAddRemoter") forState:UIControlStateNormal];
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

- (IBAction)addRemoterButtonClicked:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    DeviceTypeListViewController* viewController = [[DeviceTypeListViewController alloc] init];
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
        
        _menu.items = itemArray;
        
        AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 176.0f) inView:appDelegate.window];
    }
}

#pragma mark - table delegate and data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [DeviceManager sharedInstance].deviceArray.count;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footView = [[UIView alloc] init];
    return footView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"DeviceItemCell";
    
    DeviceItemCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"DeviceItemCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in DeviceItemCell");
    }
    
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:indexPath.row];
    [cell setupCellWithDevice:device];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    /*
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:indexPath.row];
    
    if (nil == device.remoter)
    {
        device.remoter = [[DeviceManager sharedInstance] createRemoter:device.typeID brandID:device.brandID module:device.modelID];
        device.keys = [device.remoter getAllKeys];
    }
    
    if ([device isKindOfClass:[ACDevice class]])
    {
        ACRemoterViewController* viewController = [[ACRemoterViewController alloc] init];
        viewController.device = (ACDevice*)device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    else if ([device isKindOfClass:[SETTOPDevice class]])
    {
        SETTOPRemoterViewController* viewController = [[SETTOPRemoterViewController alloc] init];
        viewController.device = (SETTOPDevice*)device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    else if ([device isKindOfClass:[DVDDevice class]])
    {
        DVDRemoterViewController* viewController = [[DVDRemoterViewController alloc] init];
        viewController.device = (DVDDevice*)device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    else if ([device isKindOfClass:[MP3Device class]])
    {
        MP3RemoterViewController* viewController = [[MP3RemoterViewController alloc] init];
        viewController.device = (MP3Device*)device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    else if ([device isKindOfClass:[AMPDevice class]])
    {
        AMPRemoterViewController* viewController = [[AMPRemoterViewController alloc] init];
        viewController.device = (AMPDevice*)device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    else if ([device isKindOfClass:[FanDevice class]])
    {
        FanRemoterViewController* viewController = [[FanRemoterViewController alloc] init];
        viewController.device = (FanDevice*)device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    else
    {
        TVRemoterViewController* viewController = [[TVRemoterViewController alloc] init];
        viewController.device = device;
        [appDelegate.navController pushViewController:viewController animated:YES];
    }
    */
}

- (UITableViewCellEditingStyle)tableView:(UITableView*)tableView editingStyleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    Device* device = [[DeviceManager sharedInstance].deviceArray objectAtIndex:indexPath.row];
    [[DeviceManager sharedInstance] deleteDevice:device];
}

- (void)handleDeviceListChangedNotification:(NSNotification*)notification
{
    [_tableView reloadData];
}

- (void)handleDeviceChangedNotification:(NSNotification*)notification
{
    [_tableView reloadData];
}

@end
