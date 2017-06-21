/*
 ============================================================================
 Name        : DeviceTypeListViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device type list view controller
 ============================================================================
 */

#import <MapKit/MapKit.h>

#import "DeviceTypeListViewController.h"
#import "LocalizedStringTool.h"
#import "DeviceManager.h"
#import "DeviceTypeItemCell.h"
#import "UIUtil.h"
#import "DeviceBrandListViewController.h"
#import "DeviceSubBrandCell.h"
#import "DeviceModuleListViewController.h"
#import "BIRBrandItem.h"
#import "TVDevice.h"
#import "ACDevice.h"
#import "FanDevice.h"
#import "SETTOPDevice.h"
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
#import "SKSTableView.h"


@interface DeviceTypeListViewController () <SKSTableViewDelegate>
{
    IBOutlet SKSTableView* _tableView;
    
    NSMutableArray* _deviceTypeArray;
    
    NSInteger _selectedIndex;
    NSArray* _selectedBrandArray;
}

@end

@implementation DeviceTypeListViewController

- (void)dealloc
{
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _deviceTypeArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.shouldExpandOnlyOneCell = YES;
    _tableView.SKSTableViewDelegate = self;
    
    [self requestGetDeviceTypeList];
    
    UILabel *lable1 = [self.view viewWithTag:101];
    lable1.text = L(@"SelectType");
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

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceTypeArray.count;
}

- (NSInteger)tableView:(SKSTableView*)tableView numberOfSubRowsAtIndexPath:(NSIndexPath*)indexPath
{
    return 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath*)indexPath
{
    return NO;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52.0f;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 114.0f;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footView = [[UIView alloc] init];
    return footView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"DeviceTypeItemCell";
    
    DeviceTypeItemCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"DeviceTypeItemCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in DeviceTypeItemCell");
    }
    
    BIRTypeItem* type = [_deviceTypeArray objectAtIndex:indexPath.row];
    [cell setupCellWithType:type];
    
    return cell;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForSubRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"DeviceSubBrandCell";
    
    DeviceSubBrandCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"DeviceSubBrandCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in DeviceSubBrandCell");
    }
    
    BIRTypeItem* type = [_deviceTypeArray objectAtIndex:indexPath.row];
    NSArray* array = [[DeviceManager sharedInstance] getTop10BrandList:type.typeId];
    
    //NSLog(@"%@",array);
    
    _selectedIndex = indexPath.row;
    _selectedBrandArray = array;
    
    cell.subCates = array;
    cell.cateVC = self;
    
    [cell setupCell];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)requestGetDeviceTypeList
{
    [UIUtil showProgressHUD:L(@"HintRequesting") inView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    ^{
        NSArray* array = [[DeviceManager sharedInstance] getDeviceTypeList];
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [UIUtil hideProgressHUD];
            
            [_deviceTypeArray addObjectsFromArray:array];
            [_tableView refreshData];
        });
    });
}

- (void)subCateBtnAction:(UIButton*)btn
{
    if (_selectedBrandArray.count == btn.tag)
    {
        DeviceBrandListViewController* viewController = [[DeviceBrandListViewController alloc] init];
        viewController.typeItem = [_deviceTypeArray objectAtIndex:_selectedIndex];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else
    {
        BIRTypeItem* typeItem = [_deviceTypeArray objectAtIndex:_selectedIndex];
        BIRBrandItem* brand = [_selectedBrandArray objectAtIndex:btn.tag];
        
        id<BIRRemote> remoter = nil;
        if (NSOrderedSame == [typeItem.typeId compare:@"1"])
        {
            remoter = [[DeviceManager sharedInstance] createBigRemoter:typeItem.typeId brandID:brand.brandId];
        }
        else
        {
            remoter = [[DeviceManager sharedInstance] createRemoter:typeItem.typeId brandID:brand.brandId module:nil];
        }
        
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
                        
                        if (NSOrderedSame == [typeItem.typeId compare:@"1"])
                        {
                            TVDevice* device = [[TVDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"2"])
                        {
                            ACDevice* device = [[ACDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"3"])
                        {
                            SETTOPDevice* device = [[SETTOPDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"5"])
                        {
                            DVDDevice* device = [[DVDDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"6"])
                        {
                            MP3Device* device = [[MP3Device alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"4"])
                        {
                            AMPDevice* device = [[AMPDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"8"])
                        {
                            FanDevice* device = [[FanDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"7"])
                        {
                            GameDevice* device = [[GameDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"9"])
                        {
                            PJDevice* device = [[PJDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"10"])
                        {
                            RobotDevice* device = [[RobotDevice alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
                            device.remoter = remoter;
                            device.keys = keys;
                            
                            baseDevice = device;
                            
                            [[DeviceManager sharedInstance] addDevice:device];
                        }
                        else if (NSOrderedSame == [typeItem.typeId compare:@"11"])
                        {
                            Device* device = [[Device alloc] init];
                            device.name = alertController.textFields[0].text;
                            device.typeID = typeItem.typeId;
                            device.typeName = typeItem.locationName;
                            device.brandID = brand.brandId;
                            device.brandName = brand.locationName;
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
            //[UIUtil showWarning:L(@"HintNoFoundRemoter") title:nil delegate:nil];
            
            DeviceModuleListViewController* viewController = [[DeviceModuleListViewController alloc] init];
            viewController.typeItem = typeItem;
            viewController.brandItem = brand;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

@end
