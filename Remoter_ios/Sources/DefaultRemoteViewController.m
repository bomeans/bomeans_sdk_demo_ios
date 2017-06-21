//
//  DefaultRemoteViewController.m
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/6.
//
//

#import "DefaultRemoteViewController.h"
#import "DefaultRemoteViewCell.h"
#import "REMenu.h"
#import "DeviceManager.h"
#import "LocalizedStringTool.h"
#import "BIRKeyName.h"
#import "AppDelegate.h"
#import "WifiIRDeviceListViewController.h"
#import "DeviceTypeListViewController.h"
#import "WifiSettingViewController.h"
#import "LEDViewController.h"
#import "PowerSwitchViewController.h"
#import "UIUtil.h"
#import "DefaultRemoteMatchViewController.h"

@interface DefaultRemoteViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    __weak IBOutlet UICollectionView *_contentView;
    __weak IBOutlet UIButton *irStateButton;
    __weak IBOutlet UILabel *titleLabel;
    
    NSMutableDictionary* _keyDic;
    REMenu* _menu;
}

@end

@implementation DefaultRemoteViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WifiIRStateChangedNotification" object:nil];
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _keyDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceChangedNotification:) name:@"DeviceChangedNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWifiIRStateChangedNotification:) name:@"WifiIRStateChangedNotification" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    titleLabel.text = [NSString stringWithFormat:@"%@(%@)", self.device.brandName, self.device.typeName];
    
    [irStateButton setTitle:([[DeviceManager sharedInstance] wifiIRState]) ? L(@"DeviceConnected") : L(@"DeviceNotConnected") forState:UIControlStateNormal];
    
    [_contentView registerNib:[UINib nibWithNibName:@"DefaultRemoteViewCell" bundle:nil] forCellWithReuseIdentifier:@"cellIdentifier"];
    [_contentView setScrollEnabled:YES];
    _contentView.dataSource = self;
    _contentView.delegate = self;
    
    //未匹配前取得萬能key來使用
    if (self.device.remoter == nil) {
        id<BIRRemote> remote;
        remote = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:nil];
        self.device.remoter = remote;
        self.device.keys = [remote getAllKeys];
    }
//    NSArray* tempKeyArray = [[DeviceManager sharedInstance] getKeyNameList:self.device.typeID];
//    NSArray* typeKeyArray = [tempKeyArray arrayByAddingObjectsFromArray:[[DeviceManager sharedInstance] getKeyNameList:@"1"]];
    //parameter nil = all key
    NSArray* typeKeyArray = [[DeviceManager sharedInstance] getKeyNameList:nil];
    
    for (NSString* key in self.device.keys) {
        BOOL isAdd = NO;
        for (BIRKeyName* keyName in typeKeyArray) {
            if ([key isEqualToString:keyName.keyId]) {
                [_keyDic setObject:keyName.name forKey:keyName.keyId];
                isAdd = YES;
                break;
            }
        }
        if (!isAdd) {
            [_keyDic setObject:key forKey:key];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Button Event

- (IBAction)backButtonClicked:(id)sender
{
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
            [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 246.0f) inView:appDelegate.window];
        }
        else
        {
            [_menu showFromRect:CGRectMake(appDelegate.window.bounds.size.width-128.0f, 64.0f, 128.0f, 216.0f) inView:appDelegate.window];
        }
    }
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
                                              DefaultRemoteMatchViewController* viewController = [[DefaultRemoteMatchViewController alloc] init];
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

- (void)cellButtonClick:(UIButton*) button
{
    UIImageView *view = [button.superview viewWithTag:1];
    view.image = [UIImage imageNamed:@"按键配对背景图-亮"];
    //NSLog(@"%@", button.titleLabel.text);
    //NSLog(@"%@", [_keyDic allKeysForObject:button.titleLabel.text][0]);
    NSString* ir = [_keyDic allKeysForObject:button.titleLabel.text][0];
    [self.device.remoter transmitIR:ir withOption:nil];
}

- (void)cellButtonTouchDown:(UIButton*) button
{
    UIImageView *view = [button.superview viewWithTag:1];
    view.image = [UIImage imageNamed:@"按键配对背景图-暗"];
}

- (void)cellButtonTouchUpOutside:(UIButton*) button
{
    UIImageView *view = [button.superview viewWithTag:1];
    view.image = [UIImage imageNamed:@"按键配对背景图-亮"];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.device.keys.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //DefaultRemoteViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    static NSString* cellIdentifier = @"cellIdentifier";
    DefaultRemoteViewCell* cell = (DefaultRemoteViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[DefaultRemoteViewCell alloc] init];
    }
    UIImageView* cellImg = [cell viewWithTag:1];
    cellImg.image = [UIImage imageNamed:@"按键配对背景图-亮"];
    
    UIButton* cellButton = [cell viewWithTag:2];
    NSString* key = [self.device.keys objectAtIndex:indexPath.row];
    NSString* title = [_keyDic objectForKey:key];
    [cellButton setTitle:title forState:UIControlStateNormal];
    [cellButton addTarget:self action:@selector(cellButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cellButton addTarget:self action:@selector(cellButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
    [cellButton addTarget:self action:@selector(cellButtonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70 , 70);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

#pragma mark - Notification
- (void)handleDeviceChangedNotification:(NSNotification*)notification
{
    _keyDic = [NSMutableDictionary new];
    NSArray* tempKeyArray = [[DeviceManager sharedInstance] getKeyNameList:self.device.typeID];
    NSArray* typeKeyArray = [tempKeyArray arrayByAddingObjectsFromArray:[[DeviceManager sharedInstance] getKeyNameList:@"1"]];
    
    for (NSString* key in self.device.keys) {
        BOOL isAdd = NO;
        for (BIRKeyName* keyName in typeKeyArray) {
            if ([key isEqualToString:keyName.keyId]) {
                [_keyDic setObject:keyName.name forKey:keyName.keyId];
                isAdd = YES;
                break;
            }
        }
        if (!isAdd) {
            [_keyDic setObject:key forKey:key];
        }
    }
    [_contentView reloadData];
}

- (void)handleWifiIRStateChangedNotification:(NSNotification*)notification
{
    [irStateButton setTitle:([[DeviceManager sharedInstance] wifiIRState]) ? L(@"DeviceConnected") : L(@"DeviceNotConnected") forState:UIControlStateNormal];
}
@end
