/*
 ============================================================================
 Name        : DeviceSubBrandViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device sub brand cell
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "DeviceTypeListViewController.h"


@interface DeviceSubBrandCell : UITableViewCell

@property (strong, nonatomic) NSArray* subCates;
@property (strong, nonatomic) DeviceTypeListViewController* cateVC;

- (void)setupCell;

@end
