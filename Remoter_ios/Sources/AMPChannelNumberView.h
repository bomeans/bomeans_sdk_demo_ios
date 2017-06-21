/*
 ============================================================================
 Name        : AMPChannelNumberView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The AMP channel number view
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface AMPChannelNumberView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, readonly) NSArray* keyArray;

- (void)reloadData;

@end
