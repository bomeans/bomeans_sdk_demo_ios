/*
 ============================================================================
 Name        : Device.m
 Version     : 1.0.0
 Copyright   : www.keruiyun
 Description : The device class
 ============================================================================
 */

#import "Device.h"


@interface Device ()
{
}

@end

@implementation Device

- (id)init
{
    if (self = [super init])
    {
        self.isSelected = YES;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.typeID = [aDecoder decodeObjectForKey:@"typeID"];
        self.typeName = [aDecoder decodeObjectForKey:@"typeName"];
        self.brandID = [aDecoder decodeObjectForKey:@"brandID"];
        self.brandName = [aDecoder decodeObjectForKey:@"brandName"];
        self.modelID = [aDecoder decodeObjectForKey:@"modelID"];
        self.isSelected = [aDecoder decodeBoolForKey:@"isSelected"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.typeID forKey:@"typeID"];
    [aCoder encodeObject:self.typeName forKey:@"typeName"];
    [aCoder encodeObject:self.brandID forKey:@"brandID"];
    [aCoder encodeObject:self.brandName forKey:@"brandName"];
    [aCoder encodeObject:self.modelID forKey:@"modelID"];
    [aCoder encodeBool:self.isSelected forKey:@"isSelected"];
}

- (UIImage*)iconImage
{
    if (NSOrderedSame == [self.typeID compare:@"1"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-电视机.png"];
    }
    else if (NSOrderedSame == [self.typeID compare:@"2"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-空调.png"];
    }
    else if (NSOrderedSame == [self.typeID compare:@"3"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-机顶盒.png"];
    }
    else if (NSOrderedSame == [self.typeID compare:@"5"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-DVD.png"];
    }
    else if (NSOrderedSame == [self.typeID compare:@"6"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-MP3.png"];
    }
    else if (NSOrderedSame == [self.typeID compare:@"4"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-扩大机.png"];
    }
    else if (NSOrderedSame == [self.typeID compare:@"8"])
    {
        return [UIImage imageNamed:@"ico-摇控器类型-风扇.png"];
    }
    else
    {
        return [UIImage imageNamed:@"5.1.1_节目介绍-收藏.png"];
    }
}

@end
