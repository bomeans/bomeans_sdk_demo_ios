/*
 ============================================================================
 Name        : DeviceModuleListViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device module list view controller
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "BIRTypeItem.h"
#import "BIRBrandItem.h"


@interface DeviceModuleListViewController : UIViewController
{
}

@property (nonatomic, strong) BIRTypeItem* typeItem;
@property (nonatomic, strong) BIRBrandItem* brandItem;

@end
