/*
 ============================================================================
 Name        : DeviceManager.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device manager class
 ============================================================================
 */

#import <SystemConfiguration/CaptiveNetwork.h>

#import "DeviceManager.h"
#import "BomeansIRKit.h"
#import "BIRTypeItem.h"
#import "BomeansDelegate.h"
#import "AppData.h"
#import "Reachability.h"
#import "BomeansDelegate.h"
#import "BomeansWifiToIRDiscovery.h"
#import "BIRIpAndMac.h"
#import "myHW.h"
#import "BomeansWifiToIR.h"


@interface DeviceManager () <BIRBroadcastSSID_Delegate>
{
    BomeansIRKit* _bomeansIrKit;
    BomeansWifiToIR* _wifiToIR;
    
    
    NSMutableArray* _deviceArray;
    
    Reachability* _reachability;
    
    SetupWifiCompletionCallback _setupWifiCompletionCallback;
    SetupWifiFailCallback _setupWifiFailCallback;
    
    NSTimer* _timer;
}

@end

@implementation DeviceManager

@synthesize deviceArray = _deviceArray;

static DeviceManager* _sharedInstance;

- (void)dealloc
{
    [_reachability stopNotifier];
    
    _bomeansIrKit = nil;
    _wifiToIR = nil;
    
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

+ (DeviceManager*)sharedInstance
{
    if (nil == _sharedInstance)
    {
        _sharedInstance = [[DeviceManager alloc] init];
    }
    
	return _sharedInstance;
}

+ (void)destroyInstance
{
    if (nil != _sharedInstance)
    {
        _sharedInstance = nil;
    }
}

- (id)init
{
    self = [super init];
    if (self)
    {
        //_reachability = [Reachability reachabilityForLocalWiFi];
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        //[_reachability startNotifier];
        
        _bomeansIrKit = [[BomeansIRKit alloc] initWithKey:@""];
        [BomeansIRKit setUseChineseServer:NO];
        _wifiToIR = [[BomeansWifiToIR alloc] init];
        
        _deviceArray = [[NSMutableArray alloc] initWithCapacity:1];
        
        NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        NSData* data = [userDefaults objectForKey:@"DeviceArray"];
        [_deviceArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:data]];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5.0f
                                                  target:self
                                                selector:@selector(timerCallback:)
                                                userInfo:nil
                                                 repeats:NO];
        
        //判斷使用遠端還近端
        NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
        NSString *wifiRoIr =[defaultValue stringForKey:@"wifiToIR"];
        if([wifiRoIr isEqual:@"cloud"]){
            //使用自定義的HW (遠端)
            myHW *myHW_1 = [[myHW alloc] init];     // 建立你的hw
            [_bomeansIrKit setIRHW:myHW_1];         // 設定給SDK 使用
        }
        else{
            [_bomeansIrKit setIRHW:_wifiToIR];
        }
        //NSString *deviceCoreID =[defaultValue stringForKey:@"deviceCoreID"];
        //NSLog(@"%@",deviceCoreID);
        
    }
    
    return self;
}

- (void)timerCallback:(NSTimer*)timer
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WifiIRStateChangedNotification" object:nil];
}

- (void)reachabilityChanged:(NSNotification*)note
{
    if (nil == _bomeansIrKit || nil == _wifiToIR)
    {
        return;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithDictionary:[AppData wifiList]];
    NSString* password = [dict objectForKey:[self getWifiName]];
    
    if (/*![_bomeansIrKit wifiIRState] &&*/ [self getWifiName].length > 0 && password.length > 0)
    {
        [_wifiToIR broadcastSSID:[self getWifiName] passWord:password authMode:AuthModeAutoSwitch waitTime:3 delegate:self];
        
    }
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

- (void)addDevice:(Device*)device
{
    [_deviceArray insertObject:device atIndex:0];
    
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceListChangedNotification object:nil];
}

- (void)deleteDevice:(Device*)device
{
    [_deviceArray removeObject:device];
    
    [self save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DeviceListChangedNotification object:nil];
}

- (void)setupWifi:(NSString*)wifi password:(NSString*)password completion:(SetupWifiCompletionCallback)completion fail:(SetupWifiFailCallback)fail
{
    _setupWifiCompletionCallback = [completion copy];
    _setupWifiFailCallback = [fail copy];
    
    if (wifi.length > 0 && password.length > 0)
    {
        [_wifiToIR broadcastSSID:wifi passWord:password authMode:AuthModeAutoSwitch waitTime:45 delegate:self];
    }
}

//只取出AC
- (NSArray*)getDeviceTypeList
{
    //return [_bomeansIrKit webGetTypeList:[self language]];
    NSMutableArray *typeArray = [[NSMutableArray alloc] init]  ;
    
    //NSMutableArray *typeArray =   ;
    NSArray *typeArrayTmp = [_bomeansIrKit webGetTypeList:[self language]];
    //NSInteger typeArraySize = sizeof typeArrayTmp;
    
    for (BIRTypeItem* type in typeArrayTmp) {
        if ([type.typeId isEqualToString:@"1"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"2"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"3"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"4"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"5"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"6"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"8"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"7"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"9"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"10"]) {
            [typeArray addObject:type];
        } else if ([type.typeId isEqualToString:@"11"]) {
            [typeArray addObject:type];
        }
        
    }
    /*
    for(NSInteger index=0 ; index < typeArraySize ; ++index)
    {
        BIRTypeItem *type = typeArrayTmp[index];
        //NSLog(@"%@",type.typeId);
        
        
        if( [type.typeId isEqualToString : @"2"])
        {
            typeArray[0] = [typeArrayTmp objectAtIndex: index]; //[type objectAtIndex:index];;
        }
        //if(typeArray[index].typeID)
    }
    */
    return typeArray;

}

- (NSArray*)getTop10BrandList:(NSString*)typeID
{
    return [_bomeansIrKit webGetTopBrandList:typeID start:0 number:10 language:[self language] getNew:NO];
}

- (NSArray*)getDeviceBrandList:(NSString*)typeID
{
    return [_bomeansIrKit webGetBrandList:typeID start:0 number:1800 language:[self language] brandName:nil];
}

- (NSArray*)getDeviceModelList:(NSString*)typeID brandID:(NSString*)brandID
{
    return [_bomeansIrKit webGetRemoteModelList:typeID andBrand:brandID];
}

- (NSArray*)getKeyNameList:(NSString*)typeID
{
    return [_bomeansIrKit webGetKeyName:typeID language:[self language] getNew:NO];
}

- (id <BIRRemote>)createBigRemoter:(NSString*)typeID brandID:(NSString*)brandID
{
    return [_bomeansIrKit createBigCombineRemote:typeID withBrand:brandID];
}

- (id <BIRRemote>)createRemoter:(NSString*)typeID brandID:(NSString*)brandID module:(NSString*)moduleID
{
    return [_bomeansIrKit createRemoteType:typeID withBrand:brandID andModel:moduleID];
}

//設定小火山現在時間
- (void)WifiIRsetNowTime
{
    [_wifiToIR wifiIR_SetNowTime:16 min:32 sec:00];
}

- (void)turnOffWifi
{
    [_wifiToIR wifiIR_TuneOffWifi];
}

- (void)wifiIRSwitch_OnOff:(BOOL)onOff
{
    [_wifiToIR wifiIRSwitch_OnOff:onOff];
}

- (void)setWifiTimer:(NSDate*)beginTime endDate:(NSDate*)endTime
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* beginCmps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:beginTime];
    NSDateComponents* endCmps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:endTime];
    
    //[_bomeansIrKit wifiIR_SetOnTimer:YES hour:(int)beginCmps.hour min:(int)beginCmps.minute sec:0];
    //[_bomeansIrKit wifiIR_SetOffTimer:YES hour:(int)endCmps.hour min:(int)endCmps.minute sec:0];
    [_wifiToIR wifiIRSwitch_SetOnTimer:YES hour:(int)beginCmps.hour min:(int)beginCmps.minute sec:0];
    [_wifiToIR wifiIRSwitch_SetOffTimer:YES hour:(int)endCmps.hour min:(int)endCmps.minute sec:0];
}

- (BOOL)setLEDColor:(UIColor*)color
{
    BOOL ret = NO;
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (0 != alpha)
    {
        if (BIROK == [_wifiToIR wifiIRLed_Color:red greenColor:green blueColor:blue])
        {
            ret = YES;
        }
    }
    
    return ret;
}

- (void)turnOffLED
{
    [_wifiToIR wifiIRLed_OnOff:NO];
}

- (void)turnOnLED
{
    [_wifiToIR wifiIRLed_OnOff:YES];
}

- (void)setLEDTimer:(NSDate*)beginTime endDate:(NSDate*)endTime
{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* beginCmps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:beginTime];
    NSDateComponents* endCmps = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute fromDate:endTime];
    
    [_wifiToIR wifiIRLed_SetOnTimer:YES hour:(int)beginCmps.hour min:(int)beginCmps.minute sec:0];
    [_wifiToIR wifiIRLed_SetOffTimer:YES hour:(int)endCmps.hour min:(int)endCmps.minute sec:0];
}

- (BOOL)wifiIRState
{
    return (BIROK == [_wifiToIR wifiIRState]) ? YES : NO;
}


- (void)setWifiToIrIP:(NSString*)ip
{
    [_wifiToIR setWifiToIrIP:ip];
}

- (id)createSmartPicker:(NSString*)type withBrand:(NSString*)brand
{
    return [_bomeansIrKit createSmartPicker:type withBrand:brand getNew:NO];
}

- (NSString*)language
{
    return @"tw";
}

-(void)broadcastSSID:(id)obj process:(int)second
{
    if (BIROK == [_wifiToIR wifiIRState] && nil != _setupWifiCompletionCallback)
    {
        [_wifiToIR cancelBroadcastSSID];
        
        _setupWifiCompletionCallback();
        _setupWifiCompletionCallback = nil;
    }
}

-(void)broadcastSSID:(id)obj end:(int)result
{
    if (BIRResultUserCancal != result && nil != _setupWifiFailCallback)
    {
        _setupWifiFailCallback();
        _setupWifiFailCallback = nil;
    }
}

- (void)save
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_deviceArray];
    [userDefaults setObject:data forKey:@"DeviceArray"];
    [userDefaults synchronize];
}

- (void)clear
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"DeviceArray"];
    [userDefaults synchronize];
}

//檢查遠端轉發器是否上線
-(BOOL)checkRemoteWifiToIRLogin:(NSString*)coreID{
    
    NSString *fiviApiUrl = @"http://api.openfivi.com:3000/login";
    
    
    //1.Use NSDictionary
    //NSDictionary *postDict = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                          coreID, @"coreid",
    //                          nil];
    //NSData* jsonData = [NSJSONSerialization dataWithJSONObject:postDict options:kNilOptions error:&error];
    
    //2.use json string
    NSString *jsonStr = [NSString stringWithFormat: @"{\"coreid\":\"%@\"}", coreID];
    //NSLog(@"Post jsonStr : %@", jsonStr);
    
    NSError *error = nil;
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSURLResponse *response;
    NSData *localData = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:fiviApiUrl]];
    [request setHTTPMethod:@"POST"];
    
    if (error == nil)
    {
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:jsonData];
        
        // Send the request and get the response
        localData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSString *result = [[NSString alloc] initWithData:localData encoding:NSASCIIStringEncoding];
        NSLog(@"Post result : %@", result);
        
        //NSArray *Array = [result valueForKey:@"array"];
        
        //NSString *success = [localData valueForKey:@"success"];
        //NSLog(@"%@",Array);
        
        return YES;
    }
    else
    {
        return NO;
    }
    
    
    
}



//搜尋 wifiToIR 裝置
- (void)discoveryWifiToIR {
    
    BomeansWifiToIRDiscovery *wifiIR = [[BomeansWifiToIRDiscovery alloc] init];
    
    if( [wifiIR discoryBlockTryTime:5] )
    {
        //NSDictionary *all = wifiIR.allWifiToIr;
        //NSEnumerator *enumeratorKey = [all keyEnumerator];
        /*for(NSString *mac in enumeratorKey)
         {
         //NSLog(@"mac is %@",mac);
         }*/
        
        //搜尋所有轉發器裝置
        NSArray *allDevice =wifiIR.allWifiToIr.allValues;
        //NSLog(@"all : %@",device0.extraInfo);
        for(BIRIpAndMac *device in allDevice)
        {
            NSString *deviceIP =device.ip;
            NSString *deviceCoreID =device.extraInfo;
            NSLog(@"IP is %@ , coreID is %@",deviceIP, deviceCoreID);
            
            //使用NSUserDefaults方式儲存 wifiToIR device coreID
            NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
            
            [defaultValue setObject:deviceCoreID forKey:@"deviceCoreID"];
            [defaultValue setObject:deviceIP forKey:@"deviceIP"];

            //NSUserDefaults 同步儲存
            [defaultValue synchronize];
            
            //設定此用此裝置
            [self setWifiToIrIP: deviceIP];
        }
    }
    else
    {
        NSLog(@"Not find wifiTO ir");
    }
    
    //NSLog(@"%d",[wifiIR isFind]);
    
}


- (void)setCloudWifiToIr{
    NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    //遠端
    [defaultValue setObject:@"cloud" forKey:@"wifiToIR"];
    [defaultValue synchronize];
    
    myHW *myHW_1 = [[myHW alloc] init];
    [_bomeansIrKit setIRHW:myHW_1];
    NSLog(@"cloud");
    
    [self discoveryWifiToIR];
    
}

- (void)setLocalWifiToIr{
    NSUserDefaults *defaultValue = [NSUserDefaults standardUserDefaults];
    //近端
    [defaultValue setObject:@"local" forKey:@"wifiToIR"];
    [defaultValue synchronize];
    
    [_bomeansIrKit setIRHW:_wifiToIR];
    NSLog(@"local");
    
    [self discoveryWifiToIR];
}

- (BIRVoiceSearchResultItem*)webVSearch:(NSString*)voiceCommand{
    BIRVoiceSearchResultItem *webVSearchResult = [_bomeansIrKit webVSearch:voiceCommand language:[self language]];
    NSLog(@"voiceCommand : %@", voiceCommand);
    NSLog(@"webVSearchResult : %@",webVSearchResult);
    return webVSearchResult;
}


@end
