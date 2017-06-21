/*
 ============================================================================
 Name        : DeviceGridCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device grid cell
 ============================================================================
 */

#import <QuartzCore/QuartzCore.h>

#import "DeviceGridCell.h"


@interface DeviceGridCell ()
{
    IBOutlet UIButton* __weak _deviceButton;
    IBOutlet UILabel* __weak _deviceLabel;
}

@end

@implementation DeviceGridCell

@synthesize deviceButton = _deviceButton;
@synthesize deviceLabel = _deviceLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
