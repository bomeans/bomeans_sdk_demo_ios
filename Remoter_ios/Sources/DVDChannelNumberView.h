/*
 ============================================================================
 Name        : DVDChannelNumberView.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The dvd channel number view
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface DVDChannelNumberView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, readonly) NSArray* keyArray;

- (void)reloadData;

@end
