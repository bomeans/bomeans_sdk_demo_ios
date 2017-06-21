/*
 ============================================================================
 Name        : Device.h
 Version     : 1.0.0
 Copyright   : www.keruiyun
 Description : The device class
 ============================================================================
 */

#import <Foundation/Foundation.h>

#import "BIRRemote.h"


@interface Device : NSObject<NSCoding>
{
    
}

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* typeID;
@property (nonatomic, strong) NSString* typeName;
@property (nonatomic, strong) NSString* brandID;
@property (nonatomic, strong) NSString* brandName;
@property (nonatomic, strong) NSString* modelID;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) id<BIRRemote> remoter;
@property (nonatomic, strong) NSArray* keys;

- (UIImage*)iconImage;

@end
