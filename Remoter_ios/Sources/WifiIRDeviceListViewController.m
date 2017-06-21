/*
 ============================================================================
 Name        : WifiIRDeviceListViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device list view controller
 ============================================================================
 */

#import <QuartzCore/QuartzCore.h>

#import "WifiIRDeviceListViewController.h"
#import "LocalizedStringTool.h"
#import "WifiIRDeviceCell.h"
#import "UIUtil.h"
#import "BomeansIRKit.h"
#import "BomeansWifiToIRDiscovery.h"
#import "BIRIpAndMac.h"
#import "DeviceManager.h"


@interface WifiIRDeviceListViewController () <BIRWifiToIRDiscoveryDelegate>
{
    IBOutlet UITableView* _tableView;
    
    BomeansWifiToIRDiscovery* _discovery;
}

@end

@implementation WifiIRDeviceListViewController

- (void)dealloc
{
    [_discovery cancelNext];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _discovery = [[BomeansWifiToIRDiscovery alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_discovery discoryTryTime:3 andDelegate:self];
    
    UILabel *lable1 = [self.view viewWithTag:101];
    lable1.text = L(@"Remoter");

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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _discovery.allWifiToIr.allValues.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    WifiIRDeviceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"WifiIRDeviceCell"];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"WifiIRDeviceCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in WifiIRDeviceCell");
    }
    
    BIRIpAndMac* ipAndMac = [_discovery.allWifiToIr.allValues objectAtIndex:indexPath.row];
    cell.titleLabel.text = [ipAndMac getIp];
    cell.infoLabel.text = [ipAndMac getMac];
    
    //使用NSUserDefaults方式儲存 wifiToIR device coreID
    /*NSString *deviceIP =ipAndMac.ip;
    NSString *deviceCoreID =ipAndMac.extraInfo;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:deviceCoreID forKey:@"deviceCoreID"];
    [userDefaults setObject:deviceIP forKey:@"deviceIP"];
    */
    
	return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BIRIpAndMac* ipAndMac = [_discovery.allWifiToIr.allValues objectAtIndex:indexPath.row];
    [[DeviceManager sharedInstance] setWifiToIrIP:[ipAndMac getIp]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)wifiToIR:(id)obj discoryWifiToIr:(BIRIpAndMac*)ipAndMac
{
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [_tableView reloadData];
    });
}

-(void)wifiToIR:(id)obj process:(int)step
{
    
}

-(void)wifiToIR:(id)obj endDiscory:(BOOL)result
{
    dispatch_async(dispatch_get_main_queue(),
    ^{
        [_tableView reloadData];
    });
}

@end
