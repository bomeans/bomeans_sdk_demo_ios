/*
 ============================================================================
 Name        : DeviceTypeItemCell.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device type item cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "BIRTypeItem.h"
#import "SKSTableViewCell.h"


@interface DeviceTypeItemCell : SKSTableViewCell
{
}

- (void)setupCellWithType:(BIRTypeItem*)type;

@end
