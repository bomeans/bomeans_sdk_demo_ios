/*
 ============================================================================
 Name        : AdsControl.m
 Version     : 1.0.0
 Copyright   : www.keruiyun.com
 Description : The advertisement control
 ============================================================================
 */

#import "AdsControl.h"
#import "AdsPage.h"
#import "AdsView.h"
#import "AppDelegate.h"
#import "SYPaginatorView.h"


@interface AdsControl () <SYPaginatorViewDataSource, SYPaginatorViewDelegate>
{
    AdsView* _adsView;
    NSTimer* _timer;
    
    NSMutableArray* _imageArray;
    NSMutableArray* _adsUrlArray;
    NSTimeInterval _timeInterval;
}

@end

@implementation AdsControl

@synthesize imageArray = _imageArray;
@synthesize adsUrlArray = _adsUrlArray;

- (void)dealloc
{
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)setupSelf
{
    _imageArray = [[NSMutableArray alloc] initWithCapacity:1];
    _adsUrlArray = [[NSMutableArray alloc] initWithCapacity:1];
    
    _adsView = [[AdsView alloc] initWithFrame:CGRectZero];
    _adsView.dataSource = self;
    _adsView.delegate = self;
    _adsView.currentPageIndex = 0;
    
    [self addSubview:_adsView];
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setupSelf];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setupSelf];
    }
    
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void)reloadData
{
    [_adsView reloadData];
    [_adsView setCurrentPageIndex:0];
}

- (void)startAnimationWithTimeInterval:(NSTimeInterval)interval
{
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
    
    _timeInterval = interval;
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                               target:self
                                             selector:@selector(timerCallback:)
                                             userInfo:nil
                                              repeats:NO];
}

- (void)stopAnimation
{
    if (nil != _timer)
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _adsView.frame = self.bounds;
}

- (void)timerCallback:(NSTimer*)timer
{
    int currIndex = _adsView.currentPageIndex;
    currIndex++;
    
    int count = _adsView.numberOfPages;
    if (currIndex >= count)
    {
        currIndex = 0;
    }
    
    [_adsView setCurrentPageIndex:currIndex animated:YES];
    
    [self startAnimationWithTimeInterval:_timeInterval];
}

#pragma mark - SYPaginatorViewDataSource

- (NSInteger)numberOfPagesForPaginatorView:(SYPaginatorView*)paginatorView
{
	return _imageArray.count;
}

- (SYPageView*)paginatorView:(SYPaginatorView*)paginatorView viewForPageAtIndex:(NSInteger)pageIndex
{
    static NSString* identifier = @"AdsPage";
    
    AdsPage* page = (AdsPage*)[paginatorView dequeueReusablePageWithIdentifier:identifier];
    if (!page)
    {
        page = [[AdsPage alloc] initWithReuseIdentifier:identifier];
    }
    
    page.imageButton.tag = pageIndex;
    [page.imageButton addTarget:self action:@selector(adsButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage* image = [_imageArray objectAtIndex:pageIndex];
    [page.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    
	return page;
}

#pragma mark - SYPaginatorViewDelegate

- (void)paginatorView:(SYPaginatorView*)paginatorView didScrollToPageAtIndex:(NSInteger)pageIndex
{
}

- (IBAction)adsButtonClick:(id)sender
{
    UIButton* button = sender;
    
    NSString* url = [_adsUrlArray objectAtIndex:button.tag];
}

@end
