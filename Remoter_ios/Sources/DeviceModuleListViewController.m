/*
 ============================================================================
 Name        : DeviceModuleListViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device module list view controller
 ============================================================================
 */

#import <MapKit/MapKit.h>

#import "DeviceModuleListViewController.h"
#import "LocalizedStringTool.h"
#import "DeviceManager.h"
#import "DeviceModuleItemCell.h"
#import "UIUtil.h"
#import "TVDevice.h"
#import "ACDevice.h"
#import "SETTOPDevice.h"
#import "FanDevice.h"
#import "DVDDevice.h"
#import "MP3Device.h"
#import "AMPDevice.h"
#import "GameDevice.h"
#import "PJDevice.h"
#import "RobotDevice.h"
#import "TVRemoterViewController.h"
#import "ACRemoterViewController.h"
#import "WifiSettingViewController.h"
#import "SETTOPRemoterViewController.h"
#import "FanRemoterViewController.h"
#import "DVDRemoterViewController.h"
#import "MP3RemoterViewController.h"
#import "AMPRemoterViewController.h"
#import "GameRemoteViewController.h"
#import "PJRemoteViewController.h"
#import "RobotRemoteViewController.h"

@interface DeviceModuleListViewController ()
{
    IBOutlet UITableView* __weak _tableView;
    
    NSMutableArray* _deviceModuleArray;
}

@end

@implementation DeviceModuleListViewController

@synthesize typeItem;
@synthesize brandItem;

- (void)dealloc
{
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _deviceModuleArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestGetDeviceModelList];
    
    UILabel *lable1 = [self.view viewWithTag:101];
    lable1.text = L(@"SelectRemote");
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

#pragma mark - table delegate and data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceModuleArray.count;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footView = [[UIView alloc] init];
    return footView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"DeviceModuleItemCell";
    
    DeviceModuleItemCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"DeviceModuleItemCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in DeviceModuleItemCell");
    }
    
    BIRModelItem* model = [_deviceModuleArray objectAtIndex:indexPath.row];
    [cell setupCellWithModule:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BIRModelItem* model = [_deviceModuleArray objectAtIndex:indexPath.row];
    id<BIRRemote> remoter = [[DeviceManager sharedInstance] createRemoter:self.typeItem.typeId brandID:self.brandItem.brandId module:model.model];
    NSArray* keys = [remoter getAllKeys];
        
    if (nil != remoter && nil != keys)
    {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:L(@"HintEnterRemoterName") message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField*textField)
        {
            textField.placeholder = L(@"HintEnterRemoterName");
        }];
        
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
        {
            if (alertController.textFields[0].text.length <= 0)
            {
                UIAlertController* alertController = [UIAlertController alertControllerWithTitle:L(@"EmptyDeviceName") message:nil preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:L(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                {
                }]];
                                            
                [self presentViewController:alertController animated:YES completion:nil];
            }
            else
            {
                BOOL isFound = NO;
                for (Device* baseDevice in [DeviceManager sharedInstance].deviceArray)
                {
                    if ([baseDevice.name isEqualToString:alertController.textFields[0].text])
                    {
                        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:L(@"DeviceNameExist") message:nil preferredStyle:UIAlertControllerStyleAlert];
                        [alertController addAction:[UIAlertAction actionWithTitle:L(@"OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction* action)
                        {
                        }]];
                        
                        [self presentViewController:alertController animated:YES completion:nil];
                        
                        isFound = YES;
                    }
                }
                
                if (!isFound)
                {
                    Device* baseDevice = nil;
                    
                    if (NSOrderedSame == [self.typeItem.typeId compare:@"1"])
                    {
                        TVDevice* device = [[TVDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"2"])
                    {
                        ACDevice* device = [[ACDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"3"])
                    {
                        SETTOPDevice* device = [[SETTOPDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"5"])
                    {
                        DVDDevice* device = [[DVDDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"6"])
                    {
                        MP3Device* device = [[MP3Device alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"4"])
                    {
                        AMPDevice* device = [[AMPDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"8"])
                    {
                        FanDevice* device = [[FanDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"7"] )
                    {
                        GameDevice* device = [[GameDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"9"] )
                    {
                        PJDevice* device = [[PJDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"10"] )
                    {
                        RobotDevice* device = [[RobotDevice alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"11"] )
                    {
                        Device* device = [[Device alloc] init];
                        device.name = alertController.textFields[0].text;;
                        device.modelID = model.model;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = self.brandItem.brandId;
                        device.brandName = self.brandItem.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    
                    if ([DeviceManager sharedInstance].deviceArray.count > 12)
                    {
                        [[DeviceManager sharedInstance].deviceArray removeLastObject];
                        [[DeviceManager sharedInstance] save];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:DeviceListChangedNotification object:nil];
                    }
                    
                    NSMutableArray* array = [NSMutableArray arrayWithObject:[self.navigationController.viewControllers objectAtIndex:0]];
                    
                    [self.navigationController popToRootViewControllerAnimated:NO];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowDeviceNotification" object:baseDevice];
                    
                    /*
                    if ([baseDevice isKindOfClass:[ACDevice class]])
                    {
                        ACRemoterViewController* viewController = [[ACRemoterViewController alloc] init];
                        viewController.device = (ACDevice*)baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    else if ([baseDevice isKindOfClass:[SETTOPDevice class]])
                    {
                        SETTOPRemoterViewController* viewController = [[SETTOPRemoterViewController alloc] init];
                        viewController.device = (SETTOPDevice*)baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    else if ([baseDevice isKindOfClass:[DVDDevice class]])
                    {
                        DVDRemoterViewController* viewController = [[DVDRemoterViewController alloc] init];
                        viewController.device = (DVDDevice*)baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    else if ([baseDevice isKindOfClass:[MP3Device class]])
                    {
                        MP3RemoterViewController* viewController = [[MP3RemoterViewController alloc] init];
                        viewController.device = (MP3Device*)baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    else if ([baseDevice isKindOfClass:[AMPDevice class]])
                    {
                        AMPRemoterViewController* viewController = [[AMPRemoterViewController alloc] init];
                        viewController.device = (AMPDevice*)baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    else if ([baseDevice isKindOfClass:[FanDevice class]])
                    {
                        FanRemoterViewController* viewController = [[FanRemoterViewController alloc] init];
                        viewController.device = (FanDevice*)baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    else
                    {
                        TVRemoterViewController* viewController = [[TVRemoterViewController alloc] init];
                        viewController.device = baseDevice;
                        
                        [array addObject:viewController];
                        [self.navigationController setViewControllers:array animated:YES];
                    }
                    */
                }
            }
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:L(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction* action)
        {
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [UIUtil showWarning:L(@"HintNoFoundRemoter") title:nil delegate:nil];
    }
}

- (void)requestGetDeviceModelList
{
    [UIUtil showProgressHUD:L(@"HintRequesting") inView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    ^{
        NSArray* array = [[DeviceManager sharedInstance] getDeviceModelList:self.typeItem.typeId brandID:self.brandItem.brandId];
       
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [UIUtil hideProgressHUD];
            
            [_deviceModuleArray addObjectsFromArray:array];
            [_tableView reloadData];
        });
    });
}

@end
