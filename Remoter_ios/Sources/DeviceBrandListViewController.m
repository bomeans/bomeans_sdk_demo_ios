/*
 ============================================================================
 Name        : DeviceBrandListViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device brand list view controller
 ============================================================================
 */

#import <MapKit/MapKit.h>

#import "DeviceBrandListViewController.h"
#import "LocalizedStringTool.h"
#import "DeviceManager.h"
#import "DeviceBrandItemCell.h"
#import "UIUtil.h"
#import "DeviceModuleListViewController.h"
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

@interface DeviceBrandListViewController () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView* __weak _tableView;
    IBOutlet UISearchBar* __weak _searchBar;
    
    UISearchDisplayController* _searchDisplayController;
    
    NSMutableArray* _deviceBrandArray;
    NSMutableArray* _sortedDeviceBrandArray;
    NSMutableArray* _searchDeviceBrandArray;
}

@end

@implementation DeviceBrandListViewController

@synthesize typeItem;

- (void)dealloc
{
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _deviceBrandArray = [[NSMutableArray alloc] init];
        _sortedDeviceBrandArray = [[NSMutableArray alloc] init];
        _searchDeviceBrandArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView.sectionIndexColor = [UIColor darkGrayColor];
    [_tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    _searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchDisplayController.searchResultsDataSource = self;
    _searchDisplayController.searchResultsDelegate = self;
    _searchDisplayController.delegate = self;
    
    [self requestGetDeviceBrandList];
    
    
    UILabel *lable1 = [self.view viewWithTag:101];
    lable1.text = L(@"SelectBrand");
    
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

- (void)SortBrandList
{
    [_sortedDeviceBrandArray removeAllObjects];
    
    UILocalizedIndexedCollation* theCollation = [UILocalizedIndexedCollation currentCollation];
    
    NSMutableArray* tempSectionArray = [NSMutableArray arrayWithCapacity:1];
    
    NSInteger sectionCount = [theCollation sectionTitles].count+1;
    for (int i = 0; i < sectionCount; i++)
    {
        NSMutableArray* tempItemArray = [NSMutableArray arrayWithCapacity:1];
        [tempSectionArray addObject:tempItemArray];
    }
    
    for (BIRBrandItem* brand in _deviceBrandArray)
    {
        NSInteger sect = [theCollation sectionForObject:brand collationStringSelector:@selector(locationName)];
        [[tempSectionArray objectAtIndex:sect] addObject:brand];
    }
    
    for (NSMutableArray* sectionArray in tempSectionArray)
    {
        NSArray* sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(locationName)];
        [_sortedDeviceBrandArray addObject:sortedSection];
    }
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - table delegate and data source

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* array = nil;
    
    if (tableView == _tableView)
    {
        array = [NSMutableArray arrayWithCapacity:1];
        [array addObjectsFromArray:[NSArray arrayWithArray:[[UILocalizedIndexedCollation currentCollation] sectionIndexTitles]]];
    }
    
    return array;
}

- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index
{
    NSInteger section = 0;
    
    if (tableView == _tableView)
    {
        section = [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    }
    
    return section;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    NSInteger number = 1;
    
    if (tableView == _tableView)
    {
        number = _sortedDeviceBrandArray.count;
    }
    
    return number;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = nil;
    
    if (tableView == _tableView)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
        view.backgroundColor = [UIColor colorWithRed:0xed/255.0f green:0xef/255.0f blue:0xf0/255.0f alpha:1.0f];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 22)];
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textColor = [UIColor colorWithRed:0x00/255.0f green:0x9a/255.0f blue:0xf2/255.0f alpha:1.0f];

        label.text = [[_sortedDeviceBrandArray objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
        
        [view addSubview:label];
    }
    
    return view;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = 0;
    
    if (tableView == _tableView)
    {
        height = [[_sortedDeviceBrandArray objectAtIndex:section] count] ? tableView.sectionHeaderHeight : 0;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    
    if (tableView == _tableView)
    {
        number = [[_sortedDeviceBrandArray objectAtIndex:section] count];
    }
    else
    {
        number = _searchDeviceBrandArray.count;
    }
    
    return number;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* footView = [[UIView alloc] init];
    return footView;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* identifier = @"DeviceBrandItemCell";
    
    DeviceBrandItemCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"DeviceBrandItemCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in DeviceBrandItemCell");
    }
    
    if (tableView == _tableView)
    {
        BIRBrandItem* brand = [[_sortedDeviceBrandArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [cell setupCellWithBrand:brand];
    }
    else
    {
        BIRBrandItem* brand = [_searchDeviceBrandArray objectAtIndex:indexPath.row];
        [cell setupCellWithBrand:brand];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BIRBrandItem* brand = nil;
    if (tableView == _tableView)
    {
        brand = [[_sortedDeviceBrandArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        brand = [_searchDeviceBrandArray objectAtIndex:indexPath.row];
        
        [_searchDisplayController setActive:NO];
    }

    id<BIRRemote> remoter = nil;
    if (NSOrderedSame == [self.typeItem.typeId compare:@"1"])
    {
        remoter = [[DeviceManager sharedInstance] createBigRemoter:self.typeItem.typeId brandID:brand.brandId];
    }
    else
    {
        remoter = [[DeviceManager sharedInstance] createRemoter:self.typeItem.typeId brandID:brand.brandId module:nil];
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
                    
                    if (NSOrderedSame == [self.typeItem.typeId compare:@"1"])
                    {
                        TVDevice* device = [[TVDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"2"])
                    {
                        ACDevice* device = [[ACDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"3"])
                    {
                        SETTOPDevice* device = [[SETTOPDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"5"])
                    {
                        DVDDevice* device = [[DVDDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"6"])
                    {
                        MP3Device* device = [[MP3Device alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"4"])
                    {
                        AMPDevice* device = [[AMPDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"8"])
                    {
                        FanDevice* device = [[FanDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"7"])
                    {
                        GameDevice* device = [[GameDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"9"] )
                    {
                        PJDevice* device = [[PJDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"10"] )
                    {
                        RobotDevice* device = [[RobotDevice alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
                        device.brandID = brand.brandId;
                        device.brandName = brand.locationName;
                        device.remoter = remoter;
                        device.keys = keys;
                        
                        baseDevice = device;
                        
                        [[DeviceManager sharedInstance] addDevice:device];
                    }
                    else if (NSOrderedSame == [self.typeItem.typeId compare:@"11"] )
                    {
                        Device* device = [[Device alloc] init];
                        device.name = alertController.textFields[0].text;
                        device.typeID = self.typeItem.typeId;
                        device.typeName = self.typeItem.locationName;
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
            viewController.typeItem = self.typeItem;
            viewController.brandItem = brand;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)requestGetDeviceBrandList
{
    [UIUtil showProgressHUD:L(@"HintRequesting") inView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    ^{
        NSArray* array = [[DeviceManager sharedInstance] getDeviceBrandList:typeItem.typeId];
        dispatch_async(dispatch_get_main_queue(),
        ^{
            [UIUtil hideProgressHUD];
            
            [_deviceBrandArray addObjectsFromArray:array];
            
            [self SortBrandList];
            
            [_tableView reloadData];
        });
    });
}

#pragma mark - Search Delegate

- (BOOL)searchDisplayController:(UISearchDisplayController*)controller shouldReloadTableForSearchString:(NSString*)searchString
{
    [_searchDeviceBrandArray removeAllObjects];
    
    for (BIRBrandItem* brand in _deviceBrandArray)
    {
        if (NSNotFound != [brand.locationName rangeOfString:searchString].location)
        {
            [_searchDeviceBrandArray addObject:brand];
        }
    }
    
    return YES;
}

@end
