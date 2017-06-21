/*
 ============================================================================
 Name        : DeviceManager.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device manager class
 ============================================================================
 */

#import <Foundation/Foundation.h>

#import "Device.h"
#import "BIRRemote.h"
#import "BIRModelItem.h"
#import "BIRTVPicker.h"
#import "BomeansConst.h"
#import "BIRVoiceSearchResultItem.h"

#define DeviceListChangedNotification    @"DeviceListChangedNotification"

typedef void (^SetupWifiCompletionCallback)();
typedef void (^SetupWifiFailCallback)();


@interface DeviceManager : NSObject
{
}

@property (nonatomic, readonly) NSMutableArray* deviceArray;
@property (nonatomic, strong) NSObject *irKit;

+ (DeviceManager*)sharedInstance;
+ (void)destroyInstance;

- (void)addDevice:(Device*)device;
- (void)deleteDevice:(Device*)device;

- (void)save;

- (void)setupWifi:(NSString*)wifi password:(NSString*)password completion:(SetupWifiCompletionCallback)completion fail:(SetupWifiFailCallback)fail;
- (NSArray*)getDeviceTypeList;
- (NSArray*)getTop10BrandList:(NSString*)typeID;
- (NSArray*)getDeviceBrandList:(NSString*)typeID;
- (NSArray*)getDeviceModelList:(NSString*)typeID brandID:(NSString*)brandID;
- (NSArray*)getKeyNameList:(NSString*)typeID;
- (id <BIRRemote>)createBigRemoter:(NSString*)typeID brandID:(NSString*)brandID;
- (id <BIRRemote>)createRemoter:(NSString*)typeID brandID:(NSString*)brandID module:(NSString*)moduleID;
- (void)turnOffWifi;
- (void)setWifiTimer:(NSDate*)beginTime endDate:(NSDate*)endTime;
- (BOOL)setLEDColor:(UIColor*)color;
- (void)turnOffLED;
- (void)turnOnLED;
- (void)setLEDTimer:(NSDate*)beginTime endDate:(NSDate*)endTime;

- (BOOL)wifiIRState;

- (void)setWifiToIrIP:(NSString*)ip;

- (id)createSmartPicker:(NSString*)type withBrand:(NSString*)brand;

- (void)wifiIRSwitch_OnOff:(BOOL)onOff;

- (void)WifiIRsetNowTime;
- (void)setCloudWifiToIr;
- (void)setLocalWifiToIr;

- (BIRVoiceSearchResultItem*)webVSearch:(NSString*)voiceCommand;

@end
