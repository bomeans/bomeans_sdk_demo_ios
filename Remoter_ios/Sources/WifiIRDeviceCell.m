/*
 ============================================================================
 Name        : WifiIRDeviceCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device cell
 ============================================================================
 */

#import "WifiIRDeviceCell.h"
#import "LocalizedStringTool.h"


@interface WifiIRDeviceCell ()
{
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UILabel* __weak _infoLabel;
}

@end

@implementation WifiIRDeviceCell

@synthesize titleLabel = _titleLabel;
@synthesize infoLabel = _infoLabel;

- (void)setupSelf
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSelf];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self setupSelf];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
