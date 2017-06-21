/*
 ============================================================================
 Name        : DeviceModuleItemCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device module item cell
 ============================================================================
 */

#import "DeviceModuleItemCell.h"
#import "LocalizedStringTool.h"


@interface DeviceModuleItemCell ()
{
    IBOutlet UILabel* _nameLabel;
}

@end

@implementation DeviceModuleItemCell

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

- (void)setupCellWithModule:(BIRModelItem*)module
{
    _nameLabel.text = module.model;
}

@end
