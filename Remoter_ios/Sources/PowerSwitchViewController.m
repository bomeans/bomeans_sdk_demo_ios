/*
 ============================================================================
 Name        : PowerSwitchViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 电源插座
 ============================================================================
 */

#import "PowerSwitchViewController.h"
#import "LocalizedStringTool.h"
#import "TimerView.h"
#import "UIUtil.h"
#import "DeviceManager.h"


@interface PowerSwitchViewController() <TimerViewDelegate>
{
    IBOutlet UIScrollView* __weak _contentView;
    
    TimerView* _timerView;
}

@end

@implementation PowerSwitchViewController

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
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, 428.f);
    UILabel *lable1 = [self.view viewWithTag:101];
    UILabel *lable2 = [self.view viewWithTag:102];
    UILabel *lable3 = [self.view viewWithTag:103];
    lable1.text = L(@"Timer");
    lable2.text = L(@"PowerOff");
    lable3.text = L(@"PowerOn");
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

- (IBAction)powerOnButtonClicked:(id)sender
{
    //[[DeviceManager sharedInstance] turnOffWifi];
    NSLog(@"turn on switch");
    [[DeviceManager sharedInstance] wifiIRSwitch_OnOff:YES];
}

- (IBAction)powerOffButtonClicked:(id)sender
{
    //[[DeviceManager sharedInstance] turnOffWifi];
    NSLog(@"turn off switch");
    [[DeviceManager sharedInstance] wifiIRSwitch_OnOff:NO];
}

- (IBAction)timerButtonClicked:(id)sender
{
    _timerView.frame = self.view.bounds;
    
    [_contentView addSubview:_timerView];
}

- (void)TimerViewSelected:(NSDate*)beginTime endDate:(NSDate*)endTime
{
    //[[DeviceManager sharedInstance] WifiIRsetNowTime];
    [[DeviceManager sharedInstance] setWifiTimer:beginTime endDate:endTime];
}

@end
