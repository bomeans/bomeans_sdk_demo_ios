//
//  DefaultRemoteMatchViewController.h
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/8.
//
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface DefaultRemoteMatchViewController : UIViewController

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* modelArray;

@end
