/*
 ============================================================================
 Name        : ACDevice.m
 Version     : 1.0.0
 Copyright   : www.keruiyun
 Description : 空调
 ============================================================================
 */

#import "ACDevice.h"


@interface ACDevice ()
{
}

@end

@implementation ACDevice

@synthesize power;
@synthesize mode;
@synthesize temperature;
@synthesize swingUpDown;
@synthesize swingLeftRight;
@synthesize timer;
@synthesize fanspeed;
@synthesize turbo;
@synthesize airSwap;
@synthesize light;
@synthesize warmUp;
@synthesize sleep;
@synthesize airClean;

- (id)init
{
    if (self = [super init])
    {
        self.power = @"IR_ACOPT_POWER_OFF";
        self.mode = @"IR_ACOPT_MODE_COOL";
        self.temperature = @"IR_ACSTATE_TEMP_26";
        self.swingUpDown = @"IR_ACOPT_AIRSWING_UD_OFF";
        self.swingLeftRight = @"IR_ACOPT_AIRSWING_LR_OFF";
        self.timer = @"";
        self.fanspeed = @"IR_ACOPT_FANSPEED_A";
        self.turbo= @"IR_ACOPT_POWER_OFF";
        self.airSwap = @"IR_ACOPT_POWER_OFF";
        self.light = @"IR_ACOPT_POWER_OFF";
        self.warmUp = @"IR_ACOPT_POWER_OFF";
        self.sleep = @"IR_ACOPT_POWER_OFF";
        self.airClean = @"IR_ACOPT_POWER_OFF";
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.power = [aDecoder decodeObjectForKey:@"power"];
        self.mode = [aDecoder decodeObjectForKey:@"mode"];
        self.temperature = [aDecoder decodeObjectForKey:@"temperature"];
        self.swingUpDown = [aDecoder decodeObjectForKey:@"swingUpDown"];
        self.swingLeftRight = [aDecoder decodeObjectForKey:@"swingLeftRight"];
        self.timer = [aDecoder decodeObjectForKey:@"timer"];
        self.fanspeed = [aDecoder decodeObjectForKey:@"fanspeed"];
        self.turbo = [aDecoder decodeObjectForKey:@"turboArray"];
        self.airSwap = [aDecoder decodeObjectForKey:@"airSwapArray"];
        self.light = [aDecoder decodeObjectForKey:@"lightArray"];
        self.warmUp = [aDecoder decodeObjectForKey:@"warmUpArray"];
        self.sleep = [aDecoder decodeObjectForKey:@"sleepArray"];
        self.airClean = [aDecoder decodeObjectForKey:@"airCleanArray"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder*)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:self.power forKey:@"power"];
    [aCoder encodeObject:self.mode forKey:@"mode"];
    [aCoder encodeObject:self.temperature forKey:@"temperature"];
    [aCoder encodeObject:self.swingUpDown forKey:@"swingUpDown"];
    [aCoder encodeObject:self.swingLeftRight forKey:@"swingLeftRight"];
    [aCoder encodeObject:self.timer forKey:@"timer"];
    [aCoder encodeObject:self.fanspeed forKey:@"fanspeed"];
    [aCoder encodeObject:self.turbo forKey:@"turboArray"];
    [aCoder encodeObject:self.airSwap forKey:@"airSwapArray"];
    [aCoder encodeObject:self.light forKey:@"lightArray"];
    [aCoder encodeObject:self.warmUp forKey:@"warmUpArray"];
    [aCoder encodeObject:self.sleep forKey:@"sleepArray"];
    [aCoder encodeObject:self.airClean forKey:@"airCleanArray"];
}

@end
