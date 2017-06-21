/*
 ============================================================================
 Name        : LEDViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 七彩灯
 ============================================================================
 */

#import "LEDViewController.h"
#import "LocalizedStringTool.h"
#import "TimerView.h"
#import "UIUtil.h"
#import "DeviceManager.h"
#import "ColorView.h"
#import "EFCircularSlider.h"


@interface LEDViewController() <TimerViewDelegate, ColorViewDelegate>
{
    IBOutlet UIScrollView* _contentView;
    IBOutlet UIView* _containerView;
    IBOutlet UIView* _sliderContainerView;
    
    TimerView* _timerView;
    ColorView* _colorView;
    
    UIColor* _lastColor;
    CGFloat _bright;
}

@end

@implementation LEDViewController

- (void)dealloc
{
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _timerView = [[[NSBundle mainBundle] loadNibNamed:@"TimerView" owner:nil options:nil] objectAtIndex:0];
        _timerView.delegate = self;
        
        _colorView = [[[NSBundle mainBundle] loadNibNamed:@"ColorView" owner:nil options:nil] objectAtIndex:0];
        
        _bright = 1.0f;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, 428.f);
    
    _colorView.delegate = self;
    
    [_containerView addSubview:_colorView];
    
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:CGRectMake(-_sliderContainerView.bounds.size.width/2, 0, _sliderContainerView.bounds.size.width*2, _sliderContainerView.bounds.size.height*2)];
    circularSlider.filledColor = [UIColor clearColor];
    circularSlider.unfilledColor = [UIColor clearColor];
    circularSlider.handleColor = [UIColor clearColor];
    [circularSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [_sliderContainerView addSubview:circularSlider];
    
    UILabel *lable1 = [self.view viewWithTag:101];
    UILabel *lable2 = [self.view viewWithTag:102];
    UILabel *lable3 = [self.view viewWithTag:103];
    UILabel *lable4 = [self.view viewWithTag:104];
    lable1.text = L(@"LEDSetting");
    lable2.text = L(@"Timer");
    lable3.text = L(@"PowerOff");
    lable4.text = L(@"PowerOn");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)LED01ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0xfc/255.0f green:0x02/255.0f blue:0x00/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0xfc/255.0f green:0x02/255.0f blue:0x00/255.0f alpha:1.0f];
    }
}

- (IBAction)LED02ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0xfe/255.0f green:0x99/255.0f blue:0x01/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0xfe/255.0f green:0x99/255.0f blue:0x01/255.0f alpha:1.0f];
    }
}

- (IBAction)LED03ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0xfe/255.0f green:0xff/255.0f blue:0x02/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0xfe/255.0f green:0xff/255.0f blue:0x02/255.0f alpha:1.0f];
    }
}

- (IBAction)LED04ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0x00/255.0f green:0xff/255.0f blue:0x02/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0x00/255.0f green:0xff/255.0f blue:0x02/255.0f alpha:1.0f];
    }
}

- (IBAction)LED05ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0x00/255.0f green:0x7e/255.0f blue:0xff/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0x00/255.0f green:0x7e/255.0f blue:0xff/255.0f alpha:1.0f];
    }
}

- (IBAction)LED06ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0x00/255.0f green:0x00/255.0f blue:0xff/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0x00/255.0f green:0x00/255.0f blue:0xff/255.0f alpha:1.0f];
    }
}

- (IBAction)LED07ButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor colorWithRed:0x8a/255.0f green:0x00/255.0f blue:0xff/255.0f alpha:1.0f]])
    {
        _lastColor = [UIColor colorWithRed:0x8a/255.0f green:0x00/255.0f blue:0xff/255.0f alpha:1.0f];
    }
}

- (IBAction)powerOffButtonClicked:(id)sender
{
    [[DeviceManager sharedInstance] turnOffLED];
}

- (IBAction)powerOnButtonClicked:(id)sender
{
    [[DeviceManager sharedInstance] turnOnLED];
}

- (IBAction)timerButtonClicked:(id)sender
{
    _timerView.frame = self.view.bounds;
    
    [_contentView addSubview:_timerView];
}

- (IBAction)whiteButtonClicked:(id)sender
{
    if ([[DeviceManager sharedInstance] setLEDColor:[UIColor whiteColor]])
    {
        _lastColor = [UIColor whiteColor];
    }
}

- (IBAction)decreaseBrightButtonClicked:(id)sender
{
    //[_colorView decreaseBright];
    
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    [_lastColor getHue:&h saturation:&s brightness:&b alpha:&a];
    
    _bright = _bright - 0.1f;
    if (_bright < 0.1f)
    {
        _bright = 0.1f;
    }
    
    UIColor* color = [UIColor colorWithHue:h saturation:s brightness:_bright alpha:a];
    
    [[DeviceManager sharedInstance] setLEDColor:color];
}

- (IBAction)increaseBrightButtonClicked:(id)sender
{
    //[_colorView increaseBright];
    
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    [_lastColor getHue:&h saturation:&s brightness:&b alpha:&a];
    
    _bright = _bright + 0.1f;
    if (_bright > 1)
    {
        _bright = 1;
    }
    
    UIColor* color = [UIColor colorWithHue:h saturation:s brightness:_bright alpha:a];
    
    [[DeviceManager sharedInstance] setLEDColor:color];
}

- (void)TimerViewSelected:(NSDate*)beginTime endDate:(NSDate*)endTime
{
    [[DeviceManager sharedInstance] setLEDTimer:beginTime endDate:endTime];
}

- (void)colorViewSelected:(UIColor*)color
{
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    [color getHue:&h saturation:&s brightness:&b alpha:&a];
    
    UIColor* color2 = [UIColor colorWithHue:h saturation:s brightness:_bright alpha:a];
    
    if ([[DeviceManager sharedInstance] setLEDColor:color2])
    {
        _lastColor = color;
    }
}

- (void)valueChanged:(EFCircularSlider*)slider
{
    CGFloat value = slider.currentValue;
    if (value > 0 && value <= 25)
    {
        value = (value*2+50) / 100;
    
    //    [_colorView setBright:value];
    }
    else if (value <= 100 && value >= 75)
    {
        value = ((value-75)*2) / 100;
    
    //    [_colorView setBright:value];
    }
    else
    {
        return;
    }
    
    if (value < 0.1f)
    {
        value = 0.1f;
    }
    
    CGFloat h;
    CGFloat s;
    CGFloat b;
    CGFloat a;
    [_lastColor getHue:&h saturation:&s brightness:&b alpha:&a];
    
    b = value;
    UIColor* color = [UIColor colorWithHue:h saturation:s brightness:b alpha:a];
    _bright = b;
    
    [[DeviceManager sharedInstance] setLEDColor:color];
}

@end
