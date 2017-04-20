//
//  ELoadingView.m
//  E_Reader
//
//  Created by 阿虎 on 2017/4/18.
//  Copyright © 2017年 tigerWF. All rights reserved.
//

#import "ELoadingView.h"
#import "ECommonHeader.h"

#ifndef RGBA
#define RGBA(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define RGBCOLORV(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

#endif

float Degrees2Radians(float degrees) { return degrees * M_PI / 180; }

@interface ELoadingView()
{
    NSInteger   _animationIndex;
}

@property (nonatomic, weak) UIView              *hudView;
@property (nonatomic, strong) NSArray           *ringsColor;
@property (nonatomic, strong) NSArray           *shapeLayers;

@end

@implementation ELoadingView

+ (instancetype)standardView {
    ELoadingView *loadingView = [[ELoadingView alloc] initWithFrame: CGRectZero];
    loadingView.bounds = CGRectMake(0.0, 0.0, 7*5, 7);//间距：14px, 圆形大小:14px
    return loadingView;
}

+ (instancetype)standardViewShowOnView:(UIView *)aView {
    ELoadingView *loadingView = [[ELoadingView alloc] initWithFrame:aView.bounds];
    return loadingView;
}

- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.0;
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
            _diameter = 7.0;
        } else {
            _diameter = 7.0;
        }
        [self initSubviews];
        
        self.ringsColor = [self configRingsColor];
        
        self.backgroundColor = [UIColor clearColor];
        _hudView.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (NSArray *)configRingsColor {
    UIColor *color =  RGBCOLORV(0xf04442);
   
    switch (self.loadingStyle) {
        case LoadingStyleGray:
            color = [UIColor grayColor];
            break;
            
        case LoadingStyleRed:
            color =  RGBCOLORV(0xf04442);
            break;
            
        case LoadingStyleWhite:
            color = [UIColor whiteColor];
            break;
            
        default:
            break;
    }
    
    NSArray *ringsColor = @[color,
                            color,
                            color];
    
    return ringsColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layout];
}

- (void)layout {
    CGFloat hudWidth;
    CGFloat hudHeight;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        hudWidth = 200.0;
        hudHeight = 80.0;
    } else {
        hudWidth = 210.0;
        hudHeight = 90.0;
    }
    self.hudView.frame = CGRectMake((CGRectGetWidth(self.bounds)-hudWidth)*0.5, (CGRectGetHeight(self.bounds)-hudHeight)*0.5, hudWidth, hudHeight);
}

#pragma mark - init Method
- (void)initSubviews {
    UIView *hudView = [[UIView alloc] initWithFrame:CGRectZero];
    _hudView = hudView;
    _hudView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:_hudView];
    
    UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    stringLabel.backgroundColor = [UIColor clearColor];
    stringLabel.font = [UIFont systemFontOfSize:16.0f];
    stringLabel.textColor = [UIColor whiteColor];
    stringLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark - Private Method
- (NSArray *)createColorShapes:(NSArray *)colors {
    NSMutableArray *shapesArray = [NSMutableArray array];
    
    CGFloat x = (CGRectGetWidth(_hudView.bounds)-_diameter*(_ringsColor.count*2-1))*0.5;
    CGFloat y;
    y = CGRectGetHeight(_hudView.bounds)*0.5;
    CGPoint lastPoint = CGPointMake(x, y);
    for (UIColor *color in colors) {
        CGRect rect = CGRectMake(lastPoint.x, lastPoint.y, self.diameter, self.diameter);
        CGPoint newPoint = [self nextPointFromPoint:lastPoint];
        lastPoint = newPoint;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, rect);
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.fillColor = color.CGColor;
        shapeLayer.path = path;
        shapeLayer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge | kCALayerBottomEdge;
        shapeLayer.allowsEdgeAntialiasing = YES;
        CGPathRelease(path);
        [shapesArray addObject:shapeLayer];
    }
    
    return shapesArray;
}

- (CGPoint)nextPointFromPoint:(CGPoint)point {
    CGPoint newPoint = CGPointZero;
    newPoint.x = point.x + _diameter*2;
    newPoint.y = point.y;
    return newPoint;
}

- (void)startAnimation {
    
    for (CAShapeLayer *layer in self.shapeLayers) {
        [layer removeAllAnimations];
    }
    
    //    NSLog(@"动画线程 --- %@",[NSThread currentThread]);
    
    NSTimeInterval interval = 0;
    for (int i = 0; i< self.shapeLayers.count; i++) {
        
        CALayer *layer = [self.shapeLayers objectAtIndex:i];
        WS(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf addAnimationToLayer:layer];
        });
        interval += 0.22;
        
        //        NSLog(@"interval = %f", interval);
        //        CALayer *layer = [self.shapeLayers objectAtIndex:i];
        //        [self performSelector:@selector(addAnimationToLayer:)
        //                   withObject:layer
        //                   afterDelay:interval];
        //        interval += 0.22;
    }
}

- (CALayer *)layerOfIndex:(NSInteger)index {
    return [_shapeLayers objectAtIndex:index];
}

- (void)addAnimationToLayer:(CALayer *)layer {
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    fadeInAnimation.toValue = [NSNumber numberWithFloat:0.0];
    fadeInAnimation.autoreverses = YES;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.duration = 0.44f;
    fadeInAnimation.repeatCount = MAXFLOAT;
    [layer addAnimation:fadeInAnimation forKey:nil];
}


#pragma mark - Show/Dismiss Method
- (void)show {
    [self showWithAnimation:NO];
}

- (void)showWithAnimation:(BOOL)animated {
    self.isLoading = YES;
    
    [self layout];
    _animationIndex = 0;
    
    if (self.shapeLayers.count == 0) {
        self.shapeLayers = [self createColorShapes:_ringsColor];
        for (CAShapeLayer *layer in _shapeLayers) {
            [_hudView.layer addSublayer:layer];
        }
    }
    
    //    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1.0f];
    
    if (animated) {
        [UIView animateWithDuration:0.44f
                         animations:^{
                             self.alpha = 1.0f;
                         } completion:^(BOOL finished) {
                             [self startAnimation];
                         }];
    } else {
        self.alpha = 1.0f;
        [self startAnimation];
    }
}

- (void)showWithAnimation:(BOOL)animated duration:(NSTimeInterval)duration {
    [self showWithAnimation:animated];
    [self performSelector:@selector(dismissWithAnimation:) withObject:[NSNumber numberWithBool:YES] afterDelay:duration];
}

- (void)dismiss {
    self.isLoading = NO;
    for (CAShapeLayer *shapeLayer in self.shapeLayers) {
        [shapeLayer removeAllAnimations];
    }
    [self removeFromSuperview];
}

- (void)dismissWithAnimation:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             [self dismiss];
                         }];
    } else {
        [self dismiss];
    }
}

- (void)setLoadingViewBackgroundViewColor:(UIColor *)color {
    self.backgroundColor = color;
}

- (void)setLoadingViewHudViewColor:(UIColor *)color {
    self.hudView.backgroundColor = color;
}

#pragma mark - Getter & Setter

- (void)setLoadingStyle:(LoadingStyle)loadingStyle {
    _loadingStyle = loadingStyle;
    
    UIColor *color = nil;
    if (loadingStyle == LoadingStyleRed) {
        color =  RGBCOLORV(0xf04442);
        
    } else if (loadingStyle == LoadingStyleWhite) {
        color = [UIColor whiteColor];
    }
    else if (loadingStyle == LoadingStyleGray) {
        color = [UIColor grayColor];
    }
    
    for (CAShapeLayer *shapeLayer in self.shapeLayers) {
        shapeLayer.fillColor = color.CGColor;
    }
    self.ringsColor = [self configRingsColor];
}


#pragma mark - For Refresh

- (void)setRefreshStatus:(RefreshStatus)status {
    if (self.shapeLayers.count < 3) {
        return;
    }
    
    if (!self.isLoading) {
        [self show];
    }
    
    CAShapeLayer *fristLayer = self.shapeLayers[0];
    CAShapeLayer *secondLayer = self.shapeLayers[1];
    CAShapeLayer *thridLayer = self.shapeLayers[2];
    [fristLayer removeAllAnimations];
    [secondLayer removeAllAnimations];
    [thridLayer removeAllAnimations];
    
    switch (status) {
        case RefreshStatusBegin:
            fristLayer.hidden = NO;
            secondLayer.hidden = YES;
            thridLayer.hidden = YES;
            break;
            
        case RefreshStatusChanged:
            fristLayer.hidden = NO;
            secondLayer.hidden = NO;
            thridLayer.hidden = YES;
            break;
            
        case RefreshStatusEnd:
            fristLayer.hidden = NO;
            secondLayer.hidden = NO;
            thridLayer.hidden = NO;
            break;
            
        default:
            break;
    }
}

@end
