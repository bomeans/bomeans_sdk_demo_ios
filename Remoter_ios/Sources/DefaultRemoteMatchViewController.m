//
//  DefaultRemoteMatchViewController.m
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/8.
//
//

#import "DefaultRemoteMatchViewController.h"
#import "DeviceManager.h"
#import "LocalizedStringTool.h"
#import "BIRKeyName.h"

@interface DefaultRemoteMatchViewController ()
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIScrollView *_contentView;
    __weak IBOutlet UIButton *_commitButton;
    __weak IBOutlet UIButton *_rightButton;
    __weak IBOutlet UIButton *_leftButton;
    __weak IBOutlet UIButton *_checkButton;
    
    id<BIRRemote> _remoter;
    NSInteger _currentPickerIndex;
    
    id<BIRTVPicker> _picker;
    NSMutableDictionary* _keyDic;
    
    NSMutableArray* _itemArray;
    
}
@end

@implementation DefaultRemoteMatchViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentPickerIndex = 1;
        _keyDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        _itemArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contentView.contentSize = CGSizeMake(_contentView.frame.size.width, 428.f);
    _picker = [[DeviceManager sharedInstance] createSmartPicker:self.device.typeID withBrand:self.device.brandID];
    
    _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex];
    
    UILabel *lable1 = [self.view viewWithTag:101];
    UILabel *lable2 = [self.view viewWithTag:102];
    UILabel *lable3 = [self.view viewWithTag:103];
    lable1.text = L(@"MatchTVNote1");
    lable2.text = L(@"MatchACNote2");
    lable3.text = L(@"MatchACNote3");
    [_commitButton setTitle:L(@"AddThisRemoter") forState:UIControlStateNormal];
    
    NSArray* typeKeyArray = [[DeviceManager sharedInstance] getKeyNameList:self.device.typeID];
    for (NSString* key in self.device.keys) {
        BOOL isAdd = NO;
        for (BIRKeyName* keyName in typeKeyArray) {
            if ([key isEqualToString:keyName.keyId]) {
                [_keyDic setObject:keyName.name forKey:keyName.keyId];
                isAdd = YES;
                break;
            }
        }
        if (!isAdd) {
            [_keyDic setObject:key forKey:key];
        }
    }
    
    if ([_picker begin].length > 0) {
        [_checkButton setTitle:[_keyDic objectForKey:[_picker begin]] forState:UIControlStateNormal];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)pickerResult:(BOOL)flag{
    int result = [_picker keyResult:flag];
    
    if (BIR_PNext == result) {
        NSString *key = [_picker getNextKey];
        if (key.length > 0) {
            [_checkButton setTitle:[_keyDic objectForKey:key] forState:UIControlStateNormal];
            _currentPickerIndex++;
            _titleLabel.text = [NSString stringWithFormat:L(@"SmartPickerTitle"), _currentPickerIndex];
            //_titleLabel.title = [self.brandName stringByAppendingFormat:@"-%ld", _currentIndex];
        }
    }else if (BIR_PFind == result){
        NSArray *resultArray = [_picker getPickerResult];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:1];
        for (BIRRemoteUID *uid in resultArray) {
            BIRModelItem *item = [[BIRModelItem alloc] initWithModel:uid.modelID machineModel:uid.modelID country:nil releaseTime:nil];
            [tempArray addObject:item];
        }
        _itemArray = tempArray;
        [self chooseModel];
    }else{  //BIR_PFail
        _itemArray = [NSMutableArray new];
        [self chooseModel];
    }
}

- (void)chooseModel{
    if (_itemArray.count == 0) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"Error" message:@"Did not find the matching remote control！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertView addAction:okAction];
        [self presentViewController:alertView animated:YES completion:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }else if (_itemArray.count == 1) {
        BIRModelItem* item = [_itemArray objectAtIndex:0];
        [self toCreateRemote:item];
    }else{
        UIAlertController* alertSheet = [UIAlertController alertControllerWithTitle:@"choice remote control" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
        
        [alertSheet addAction:cancelAction];
        
        for (int i = 0; i < _itemArray.count; i++) {
            BIRModelItem* model = _itemArray[i];
            UIAlertAction* action = [UIAlertAction actionWithTitle:model.model style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self toCreateRemote:model];
            }];
            [alertSheet addAction:action];
        }
        [self presentViewController:alertSheet animated:YES completion:nil];
    }
}

- (void)toCreateRemote:(BIRModelItem*)model{
    _remoter = [[DeviceManager sharedInstance] createRemoter:self.device.typeID brandID:self.device.brandID module:model.model];
    
    self.device.modelID = model.model;
    _device.remoter = _remoter;
    _device.keys = [_remoter getAllKeys];
    
    [[DeviceManager sharedInstance] save];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceChangedNotification" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceRefreshNotification" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Button Event
- (IBAction)backButtonClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)checkButtonClicked:(id)sender
{
    [_picker transmitIR];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Tip" message:@"是否有回應" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        [self pickerResult:NO];
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        [self pickerResult:YES];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)commitButtonClicked:(id)sender
{
    [self pickerResult:YES];
}

@end
