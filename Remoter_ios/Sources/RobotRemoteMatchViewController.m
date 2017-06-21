//
//  RobotRemoteMatchViewController.m
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/15.
//
//

#import "RobotRemoteMatchViewController.h"
#import "LocalizedStringTool.h"
#import "UIUtil.h"
#import "BIRRemote.h"
#import "BIRModelItem.h"
#import "DeviceManager.h"

@interface RobotRemoteMatchViewController () <UIActionSheetDelegate>
{
    IBOutlet UILabel* __weak _titleLabel;
    IBOutlet UIScrollView* __weak _contentView;
    IBOutlet UIButton* __weak _powerButton;
    IBOutlet UIButton* __weak _volumeUpButton;
    IBOutlet UIButton* __weak _channelUpButton;
    IBOutlet UIButton* __weak _muteButton;
    IBOutlet UIButton* __weak _menuButton;
    IBOutlet UIButton* __weak _commitButton;
    IBOutlet UIButton* __weak _leftButton;
    IBOutlet UIButton* __weak _rightButton;
    IBOutlet UIButton* __weak _checkButton;
    
    NSMutableArray* _keyArray;
    
    id<BIRRemote> _remoter;
    NSInteger _currentModelIndex;
    
    BOOL _isShowQuestion;
    UIButton* _clickedButton;
    
    NSTimer* _timer;
    BOOL isLeftButtonDown;
    
    id<BIRTVPicker> _picker;
    NSInteger _currentPickerIndex;
}
@end

@implementation RobotRemoteMatchViewController

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
    
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_MUTING", @"key", _muteButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_CHANNEL_UP", @"key", _channelUpButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_VOLUME_UP", @"key", _volumeUpButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_MENU", @"key", _menuButton, @"value", nil]];
    [_keyArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"IR_KEY_POWER_TOGGLE", @"key", _powerButton, @"value", nil]];
    
    BIRModelItem* model = [self.modelArray objectAtIndex:_currentModelIndex];
    _remoter = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:model.model];
    //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
    _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
    
    for (BIRModelItem* tmpModel in self.modelArray) {
        NSLog(@"model:%@", tmpModel.model);
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
    
    _picker = [[DeviceManager sharedInstance] createSmartPicker:self.device.typeID withBrand:self.device.brandID];
    
    if ([_picker begin].length > 0)
    {
        NSMutableArray* tempKeyArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:L(@"TVRemoter.plist") ofType:nil]];
        
        for (NSDictionary* dict in tempKeyArray)
        {
            NSString* strKey = [dict objectForKey:@"key"];
            
            if (NSOrderedSame == [strKey caseInsensitiveCompare:[_picker begin]])
            {
                [_checkButton setTitle:[dict objectForKey:@"value"] forState:UIControlStateNormal];
                
                break;
            }
        }
        
        _checkButton.hidden = NO;
    }
    else
    {
        _checkButton.hidden = YES;
    }
    
    UILabel *lable1 = [self.view viewWithTag:101];
    UILabel *lable2 = [self.view viewWithTag:102];
    UILabel *lable3 = [self.view viewWithTag:103];
    lable1.text = L(@"MatchRobotNote1");
    lable2.text = L(@"MatchACNote2");
    lable3.text = L(@"MatchACNote3");
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
        UIAlertView* alertView = [UIUtil showQuestion:nil title:L(@"HintButtonMatch") delegate:self];
        alertView.tag = 1;
    }
    
    _isShowQuestion = YES;
}

- (IBAction)checkButtonClicked:(id)sender
{
    [_picker transmitIR];
    
    UIAlertView* alertView = [UIUtil showQuestion:nil title:L(@"HintButtonMatch") delegate:self];
    alertView.tag = 2;
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
        
        //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
        _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
        
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
        
        //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
        _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
        
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
    self.device.remoter = _remoter;
    self.device.keys = [_remoter getAllKeys];
    
    [[DeviceManager sharedInstance] save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceRefreshNotification" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1 == alertView.tag)
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
    else if (2 == alertView.tag)
    {
        if (1 == buttonIndex)
        {
            int res = [_picker keyResult:YES];
            
            if (BIR_PNext == res)
            {
                NSString* key = [_picker getNextKey];
                if (key.length > 0)
                {
                    NSMutableArray* tempKeyArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:L(@"TVRemoter.plist") ofType:nil]];
                    
                    for (NSDictionary* dict in tempKeyArray)
                    {
                        NSString* strKey = [dict objectForKey:@"key"];
                        
                        if (NSOrderedSame == [strKey caseInsensitiveCompare:key])
                        {
                            [_checkButton setTitle:L([dict objectForKey:@"value"]) forState:UIControlStateNormal];
                            
                            break;
                        }
                    }
                    
                    _checkButton.hidden = NO;
                }
                else
                {
                    _checkButton.hidden = YES;
                }
                
                /*
                 NSMutableArray* tempModelArray = [[NSMutableArray alloc] initWithCapacity:1];
                 NSArray* array = [_picker getPickerResult];
                 for (BIRRemoteUID* uid in array)
                 {
                 BIRModelItem* item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
                 [tempModelArray addObject:item];
                 }
                 
                 self.modelArray = tempModelArray;
                 */
                _currentModelIndex = 0;
                
                //_currentPickerIndex += 1;
                
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
                
                //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
                _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
            }
            else if (BIR_PFind == res)
            {
                UIAlertView* alertView = [UIUtil showWarning:nil title:L(@"HintFoundRemoter") delegate:self];
                alertView.tag = 3;
                
                NSMutableArray* tempModelArray = [[NSMutableArray alloc] initWithCapacity:1];
                NSArray* array = [_picker getPickerResult];
                for (BIRRemoteUID* uid in array)
                {
                    BIRModelItem* item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
                    [tempModelArray addObject:item];
                }
                
                self.modelArray = tempModelArray;
                _currentModelIndex = 0;
                
                //_currentPickerIndex += 1;
                
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
                
                //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
                _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
            }
            else
            {
                UIAlertView* alertView = [UIUtil showWarning:nil title:L(@"HintFoundRemoter") delegate:self];
                alertView.tag = 3;
            }
        }
        else
        {
            int res = [_picker keyResult:NO];
            
            if (BIR_PNext == res)
            {
                NSString* key = [_picker getNextKey];
                if (key.length > 0)
                {
                    NSMutableArray* tempKeyArray = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:L(@"TVRemoter.plist") ofType:nil]];
                    
                    for (NSDictionary* dict in tempKeyArray)
                    {
                        NSString* strKey = [dict objectForKey:@"key"];
                        
                        if (NSOrderedSame == [strKey caseInsensitiveCompare:key])
                        {
                            [_checkButton setTitle:L([dict objectForKey:@"value"]) forState:UIControlStateNormal];
                            
                            break;
                        }
                    }
                    
                    _checkButton.hidden = NO;
                }
                else
                {
                    _checkButton.hidden = YES;
                }
                /*
                 NSMutableArray* tempModelArray = [[NSMutableArray alloc] initWithCapacity:1];
                 NSArray* array = [_picker getPickerResult];
                 for (BIRRemoteUID* uid in array)
                 {
                 BIRModelItem* item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
                 [tempModelArray addObject:item];
                 }
                 
                 self.modelArray = tempModelArray;
                 _currentModelIndex = 0;
                 
                 
                 BIRModelItem* model = [self.modelArray objectAtIndex:_currentModelIndex];
                 _remoter = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:model.model];
                 */
                _currentPickerIndex += 1;
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
                
                //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
                _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
            }
            else if (BIR_PFind == res)
            {
                UIAlertView* alertView = [UIUtil showWarning:nil title:L(@"HintFoundRemoter") delegate:self];
                alertView.tag = 3;
                
                /*
                 NSMutableArray* tempModelArray = [[NSMutableArray alloc] initWithCapacity:1];
                 NSArray* array = [_picker getPickerResult];
                 for (BIRRemoteUID* uid in array)
                 {
                 BIRModelItem* item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
                 [tempModelArray addObject:item];
                 }
                 
                 self.modelArray = tempModelArray;
                 _currentModelIndex = 0;
                 */
                _currentPickerIndex += 1;
                
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
                
                //_titleLabel.text = [NSString stringWithFormat:L(@"TVMatchTitle"), [_remoter getModuleName], _currentModelIndex+1, self.modelArray.count];
                _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex+1];
            }
            else
            {
                UIAlertView* alertView = [UIUtil showWarning:nil title:L(@"HintNoFoundRemoter") delegate:self];
                self.modelArray = [NSArray new];
                alertView.tag = 3;
            }
        }
    }
    else if (3 == alertView.tag)
    {
        if (self.modelArray.count == 0) {
            
        }
        else
            if (1 == self.modelArray.count)
            {
                [self commitButtonClicked:nil];
            }
            else
            {
                UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:L(@"ChooseRemote") delegate:self cancelButtonTitle:L(@"Cancel") destructiveButtonTitle:nil otherButtonTitles:nil];
                
                for (BIRModelItem* model in self.modelArray)
                {
                    [sheet addButtonWithTitle:model.model];
                }
                
                [sheet showInView:self.view];
            }
    }
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        return;
    }
    
    BIRModelItem* model = [self.modelArray objectAtIndex:buttonIndex-1];
    
    //self.device.name = model.model;
    self.device.modelID = model.model;
    self.device.remoter = _remoter;
    self.device.keys = [_remoter getAllKeys];
    
    [[DeviceManager sharedInstance] save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceRefreshNotification" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
