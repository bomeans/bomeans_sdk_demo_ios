/*
 ============================================================================
 Name        : DeviceModuleItemCell.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device module item cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "BIRModelItem.h"


@interface DeviceModuleItemCell : UITableViewCell
{
}

- (void)setupCellWithModule:(BIRModelItem*)module;

@end
