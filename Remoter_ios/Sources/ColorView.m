/*
 ============================================================================
 Name        : ColorView.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : 选色板
 ============================================================================
 */

#import <QuartzCore/QuartzCore.h>

#import "ColorView.h"


@interface ColorView ()
{
    CGFloat _bright;
    
    unsigned char* _pixel;
    
    CGPoint _lastPoint;
}

@end

@implementation ColorView

@synthesize bright = _bright;

- (void)dealloc
{
    free(_pixel);
    _pixel = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _bright = 1.0f;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)increaseBright
{
    _bright += 0.1;
    if (_bright > 0.4f)
    {
        _bright = 0.4f;
    }
    
    self.image = [self getImage:_bright];
}

- (void)decreaseBright
{
    _bright -= 0.1;
    if (_bright < -0.4f)
    {
        _bright = -0.4f;
    }
    
    self.image = [self getImage:_bright];
}

- (void)setBright:(CGFloat)bright
{
    _bright = bright;
    
    self.image = [self getImage:_bright];
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

- (UIColor*)colorOfPoint:(CGPoint)point
{
    /*
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor* color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
    */
    
    if (nil == _pixel)
    {
        _pixel = malloc(self.frame.size.width * self.frame.size.height * 4);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(_pixel, self.frame.size.width, self.frame.size.height, 8, self.frame.size.width*4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
        
        CGContextDrawImage(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height), self.image.CGImage);
        
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
    }
    
    unsigned char* rgbaData = &_pixel[(int)(((point.y * self.frame.size.width) + point.x) * 4)];
    UIColor* color = [UIColor colorWithRed:rgbaData[0]/255.0 green:rgbaData[1]/255.0 blue:rgbaData[2]/255.0 alpha:rgbaData[3]/255.0];
    
    return color;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    _lastPoint = point;
    
    if (nil != self.delegate && [self.delegate respondsToSelector:@selector(colorViewSelected:)])
    {
        [self.delegate colorViewSelected:[self colorOfPoint:point]];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    if (_lastPoint.x - point.x > 5 || _lastPoint.x - point.x < -5 || _lastPoint.y - point.y > 5 || _lastPoint.y - point.y < -5)
    {
        _lastPoint = point;
    
        if (CGRectContainsPoint(self.bounds, point))
        {
            if (nil != self.delegate && [self.delegate respondsToSelector:@selector(colorViewSelected:)])
            {
                [self.delegate colorViewSelected:[self colorOfPoint:point]];
            }
        }
    }
}

- (UIImage*)getImage:(CGFloat)bright
{
    CIImage* beginImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"led_color.png"].CGImage];
    CIFilter* filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:bright] forKey:@"inputBrightness"];
    
    CIImage* outputImage = [filter outputImage];
    CIContext* context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage* newImg = [UIImage imageWithCGImage:cgimg];

    CGImageRelease(cgimg);
    
    return newImg;
}

@end
