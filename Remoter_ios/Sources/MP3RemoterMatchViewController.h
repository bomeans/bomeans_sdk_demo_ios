/*
 ============================================================================
 Name        : MP3RemoterMatchViewController.h
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The mp3 remoter match view controller
 ============================================================================
 */

#import <UIKit/UIKit.h>

#import "Device.h"


@interface MP3RemoterMatchViewController : UIViewController
{
}

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
