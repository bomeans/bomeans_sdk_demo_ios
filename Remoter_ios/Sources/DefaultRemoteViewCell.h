//
//  DefaultRemoteViewCell.h
//  Remoter_ios
//
//  Created by Hung Ricky on 2017/6/6.
//
//

#import <UIKit/UIKit.h>

@interface DefaultRemoteViewCell : UICollectionViewCell
@property (weak, nonatomic) UIImageView *cellImageView;
@property (weak, nonatomic) UIButton *cellButton;


-(void)initCell;

@end
