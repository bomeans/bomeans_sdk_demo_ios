//
//  RobotRemoteMatchViewController.h
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/15.
//
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface RobotRemoteMatchViewController : UIViewController

@property (nonatomic, strong) Device*  device;
@property (nonatomic, strong) NSArray* modelArray;

@end
