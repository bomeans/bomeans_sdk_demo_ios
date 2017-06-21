/*
 ============================================================================
 Name        : DeviceBrandItemCell.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device brand item cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "BIRBrandItem.h"


@interface DeviceBrandItemCell : UITableViewCell
{
}

- (void)setupCellWithBrand:(BIRBrandItem*)brand;

@end
