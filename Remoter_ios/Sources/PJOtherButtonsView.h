//
//  PJOtherButtonsView.h
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/15.
//
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface PJOtherButtonsView : UIView

@property (nonatomic, strong) Device* device;
@property (nonatomic, strong) NSArray* mainKeyArray;

- (void)reloadData;

@end
