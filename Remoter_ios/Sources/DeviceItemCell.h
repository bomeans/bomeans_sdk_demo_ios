/*
 ============================================================================
 Name        : DeviceItemCell.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device item cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface DeviceItemCell : UITableViewCell
{
}

- (void)setupCellWithDevice:(Device*)device;

@end
