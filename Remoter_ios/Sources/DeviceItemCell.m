/*
 ============================================================================
 Name        : DeviceItemCell.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The device item cell
 ============================================================================
 */

#import "DeviceItemCell.h"
#import "LocalizedStringTool.h"
#import "Device.h"
#import "DeviceManager.h"


@interface DeviceItemCell ()
{
    IBOutlet UILabel* _brandLabel;
    IBOutlet UILabel* _nameLabel;
    IBOutlet UIImageView* _iconImageView;
    IBOutlet UIButton* _switchButton;
}

@property (nonatomic, strong) Device* device;

@end

@implementation DeviceItemCell

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

- (void)setupCellWithDevice:(Device*)device
{
    self.device = device;
    
    _brandLabel.text = device.brandName;
    _nameLabel.text = device.name;
    
    _switchButton.selected = device.isSelected;
    
    if (NSOrderedSame == [device.typeID compare:@"1"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-电视机.png"];
    }
    else if (NSOrderedSame == [device.typeID compare:@"2"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-空调.png"];
    }
    else if (NSOrderedSame == [device.typeID compare:@"3"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-机顶盒.png"];
    }
    else if (NSOrderedSame == [device.typeID compare:@"5"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-DVD.png"];
    }
    else if (NSOrderedSame == [device.typeID compare:@"6"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-MP3.png"];
    }
    else if (NSOrderedSame == [device.typeID compare:@"4"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-扩大机.png"];
    }
    else if (NSOrderedSame == [device.typeID compare:@"8"])
    {
        _iconImageView.image = [UIImage imageNamed:@"ico-摇控器类型-风扇.png"];
    }
    else
    {
        _iconImageView.image = [UIImage imageNamed:@"5.1.1_节目介绍-收藏.png"];
    }
}

- (IBAction)switchButtonClicked:(id)sender
{
    _switchButton.selected = !_switchButton.selected;
    
    self.device.isSelected = _switchButton.selected;
    [[DeviceManager sharedInstance] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceListChangedNotification" object:nil];
}

@end
