/*
 ============================================================================
 Name        : DeviceGridCell.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device grid cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "UIGridViewCell.h"


@interface DeviceGridCell : UIGridViewCell
{
}

@property (nonatomic, weak) UIButton* deviceButton;
@property (nonatomic, weak) UILabel* deviceLabel;

@end
