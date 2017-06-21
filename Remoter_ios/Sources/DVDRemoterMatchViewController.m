/*
 ============================================================================
 Name        : DVDRemoterMatchViewController.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The dvd remoter match view controller
 ============================================================================
 */

#import "DVDRemoterMatchViewController.h"
#import "LocalizedStringTool.h"
#import "UIUtil.h"
#import "BIRRemote.h"
#import "BIRModelItem.h"
#import "DeviceManager.h"


@interface DVDRemoterMatchViewController()
{
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UIScrollView* __weak _contentView;
    IBOutlet UIButton* __weak _powerButton;
    IBOutlet UIButton* __weak _takeOutButton;
    IBOutlet UIButton* __weak _playButton;
    IBOutlet UIButton* __weak _menuButton;
    IBOutlet UIButton* __weak _commitButton;
    IBOutlet UIButton* __weak _leftButton;
    IBOutlet UIButton* __weak _rightButton;
    
    NSMutableArray* _keyArray;
    
    id<BIRRemote> _remoter;
    NSInteger _currentModelIndex;
    
    BOOL _isShowQuestion;
    UIButton* _clickedButton;
    
    NSTimer* _timer;
    BOOL isLeftButtonDown;
}

@end

@implementation DVDRemoterMatchViewController

@synthesize device;
@synthesize modelArray;

- (void)dealloc
{
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        _keyArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _isShowQuestion = YES;
    
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, 428.f);
    
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_MENU", @"key", _menuButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_POP_UP", @"key", _takeOutButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_POWER_TOGGLE", @"key", _powerButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_PLAY", @"key", _playButton, @"value", nil]];
    
    BIRModelItem* model = [self.modelArray objectAtIndex:_currentModelIndex];
    _remoter = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:model.model];
    _titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
    
    if (0 == _currentModelIndex)
    {
        _leftButton.enabled = NO;
    }
    else
    {
        _leftButton.enabled = YES;
    }
    
    if (self.modelArray.count-1 == _currentModelIndex)
    {
        _rightButton.enabled = NO;
    }
    else
    {
        _rightButton.enabled = YES;
    }
    
    UILabel *lable1 = [self.view viewWithTag:101];
    UILabel *lable2 = [self.view viewWithTag:102];
    UILabel *lable3 = [self.view viewWithTag:103];
    lable1.text = L(@"MatchDVDNote1");
    lable2.text = L(@"MatchACNote2");
    lable3.text = L(@"MatchACNote3");
    [_powerButton setTitle:L(@"Power") forState:UIControlStateNormal];
    [_takeOutButton setTitle:L(@"TakeOut") forState:UIControlStateNormal];
    [_menuButton setTitle:L(@"Menu") forState:UIControlStateNormal];
    [_commitButton setTitle:L(@"AddThisRemoter") forState:UIControlStateNormal];
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

- (IBAction)keyButtonClicked:(id)sender
{
    for (NSDictionary* dict in _keyArray)
    {
        if (sender == [dict objectForKey:@"value"])
        {
            [_remoter transmitIR:[dict objectForKey:@"key"] withOption:nil];
            break;
        }
    }
    
    if (_isShowQuestion)
    {
        _clickedButton = sender;
        [UIUtil showQuestion:nil title:L(@"HintButtonMatch") delegate:self];
    }
    
    _isShowQuestion = YES;
}

- (IBAction)leftButtonClicked:(id)sender
{
    if (_currentModelIndex > 0)
    {
        _currentModelIndex--;
        
        BIRModelItem* model = [self.modelArray objectAtIndex:_currentModelIndex];
        _remoter = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:model.model];
        
        for (NSInteger i = 0; i < _keyArray.count; i++)
        {
            NSDictionary* dict = [_keyArray objectAtIndex:i];
            UIButton* button = [dict objectForKey:@"value"];
            button.selected = NO;
            
            if (0 == i)
            {
                //button.userInteractionEnabled = YES;
                //button.enabled = YES;
                //button.selected = NO;
            }
            else
            {
                //button.userInteractionEnabled = YES;
                //button.enabled = NO;
                //button.selected = NO;
            }
        }
        
        _titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
        
        _isShowQuestion = NO;
        NSDictionary* dict = [_keyArray objectAtIndex:0];
        UIButton* button = [dict objectForKey:@"value"];
        [self keyButtonClicked:button];
    }
    
    if (0 == _currentModelIndex)
    {
        _leftButton.enabled = NO;
    }
    else
    {
        _leftButton.enabled = YES;
    }
    
    if (self.modelArray.count-1 == _currentModelIndex)
    {
        _rightButton.enabled = NO;
    }
    else
    {
        _rightButton.enabled = YES;
    }

    isLeftButtonDown = YES;
    
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(timerCallback:)
                                            userInfo:nil
                                             repeats:NO];
}

- (IBAction)leftButtonUp:(id)sender
{
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (IBAction)rightButtonClicked:(id)sender
{
    if (_currentModelIndex < self.modelArray.count-1)
    {
        _currentModelIndex++;
        
        BIRModelItem* model = [self.modelArray objectAtIndex:_currentModelIndex];
        _remoter = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:model.model];
        
        for (NSInteger i = 0; i < _keyArray.count; i++)
        {
            NSDictionary* dict = [_keyArray objectAtIndex:i];
            UIButton* button = [dict objectForKey:@"value"];
            button.selected = NO;
            
            if (0 == i)
            {
                //button.userInteractionEnabled = YES;
                //button.enabled = YES;
                //button.selected = NO;
            }
            else
            {
                //button.userInteractionEnabled = YES;
                //button.enabled = NO;
                //button.selected = NO;
            }
        }
        
        _titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
        
        _isShowQuestion = NO;
        NSDictionary* dict = [_keyArray objectAtIndex:0];
        UIButton* button = [dict objectForKey:@"value"];
        [self keyButtonClicked:button];
    }
    
    if (0 == _currentModelIndex)
    {
        _leftButton.enabled = NO;
    }
    else
    {
        _leftButton.enabled = YES;
    }
    
    if (self.modelArray.count-1 == _currentModelIndex)
    {
        _rightButton.enabled = NO;
    }
    else
    {
        _rightButton.enabled = YES;
    }
    
    isLeftButtonDown = NO;
    
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                              target:self
                                            selector:@selector(timerCallback:)
                                            userInfo:nil
                                             repeats:NO];
}

- (IBAction)rightButtonUp:(id)sender
{
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerCallback:(NSTimer*)timer
{
    if (isLeftButtonDown)
    {
        [self leftButtonClicked:nil];
    }
    else
    {
        [self rightButtonClicked:nil];
    }
}

- (IBAction)commitButtonClicked:(id)sender
{
    BIRModelItem* model = [self.modelArray objectAtIndex:_currentModelIndex];
    
    //self.device.name = model.model;
    self.device.modelID = model.model;
    device.remoter = _remoter;
    device.keys = [_remoter getAllKeys];
    
    [[DeviceManager sharedInstance] save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceRefreshNotification" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == buttonIndex)
    {
        _clickedButton.selected = YES;
        
        /*
         for (NSInteger i = 0; i < _keyArray.count; i++)
         {
         NSDictionary* dict = [_keyArray objectAtIndex:i];
         UIButton* button = [dict objectForKey:@"value"];
         if (button.enabled && !button.selected)
         {
         button.selected = YES;
         //button.userInteractionEnabled = NO;
         
         if (i < _keyArray.count-1)
         {
         NSDictionary* dict = [_keyArray objectAtIndex:i+1];
         UIButton* button = [dict objectForKey:@"value"];
         
         button.enabled = YES;
         }
         
         //if (i == _keyArray.count-1)
         //{
         //    _commitButton.enabled = YES;
         //}
         
         break;
         }
         }
         */
    }
    else
    {
        _clickedButton.selected = NO;
    }
}

@end
