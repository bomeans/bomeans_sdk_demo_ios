//
//  GameOtherButtonsView.m
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/15.
//
//

#import "GameOtherButtonsView.h"
#import "ButtonCollectionViewCell.h"
#import "LocalizedStringTool.h"
#import "DeviceManager.h"
#import "BIRKeyName.h"

@interface GameOtherButtonsView ()
{
    IBOutlet UICollectionView* _collectionView;
    NSMutableArray* _keyArray;
}
@end

@implementation GameOtherButtonsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _keyArray = [[NSMutableArray alloc] initWithCapacity:1];

    [_collectionView registerNib:[UINib nibWithNibName:@"ButtonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ButtonCollectionViewCell"];
    UIButton *button1 = (UIButton*) [_collectionView.superview viewWithTag:201];
    [button1 setTitle:L(@"OtherButton") forState:UIControlStateNormal];
    
}

- (void)reloadData
{
    [_keyArray removeAllObjects];
    
    NSArray* serverKeyArray = [[DeviceManager sharedInstance] getKeyNameList:nil];
    
    for (NSString* strKey in self.device.keys) {
        BOOL isFound = NO;
        for (BIRKeyName* keyName in serverKeyArray) {
            if (NSOrderedSame == [strKey caseInsensitiveCompare:keyName.keyId]) {
                isFound = YES;
            }
            
            if (isFound) {
                isFound = NO;
                for (NSDictionary* mainKeyDict in self.mainKeyArray) {
                    if (NSOrderedSame == [strKey caseInsensitiveCompare:[mainKeyDict objectForKey:@"key"]]) {
                        isFound = YES;
                        break;
                    }
                }
                
                if (!isFound) {
                    NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys:keyName.keyId, @"key", keyName.name, @"value", nil];
                    [_keyArray addObject:dict];
                    break;
                }
            }
        }
    }
    
    [_collectionView reloadData];
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

- (IBAction)backgroundButtonClicked:(id)sender
{
    [self removeFromSuperview];
}

- (IBAction)keyButtonClicked:(id)sender
{
    for (NSDictionary* dict in _keyArray)
    {
        if (sender == [dict objectForKey:@"value"])
        {
            [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:nil];
            break;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return _keyArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath*)indexPath;
{
    NSString* identifier = @"ButtonCollectionViewCell";
    ButtonCollectionViewCell* cell = [cv dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (nil == cell)
    {
        NSArray* cells = [[NSBundle mainBundle] loadNibNamed:@"ButtonCollectionViewCell" owner:nil options:nil];
        cell = [cells objectAtIndex:0];
        NSAssert(nil != cell, @"Not found a cell in ButtonCollectionViewCell");
    }
    
    NSDictionary* dict = [_keyArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = L([dict objectForKey:@"value"]);
    
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSDictionary* dict = [_keyArray objectAtIndex:indexPath.row];
    [self.device.remoter transmitIR:[dict objectForKey:@"key"] withOption:nil];
}

@end
