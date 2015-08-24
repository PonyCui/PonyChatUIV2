//
//  PCUPopMenuViewController.m
//  bubble
//
//  Created by 崔 明辉 on 15/8/13.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUPopMenuViewController.h"

#define kTopBottomSpace 14.0
#define kLeftRightSpace 8.0
#define kMenuHeight 36.0

@interface PCUPopMenuViewController ()

@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) UIView *upTriangleView;
@property (nonatomic, strong) UIView *downTriangleView;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@end

@interface PCUPopMenuUpTriangleView: UIView

@end

@interface PCUPopMenuDownTriangleView : UIView

@end

@implementation PCUPopMenuViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.backgroundColor = [UIColor clearColor];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)]];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.upTriangleView];
    [self.view addSubview:self.downTriangleView];
    [self.view addSubview:self.segmentedControl];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentMenuViewControllerWithReferencePoint:(CGPoint)referencePoint {
    [self updateControl];
    
    CGRect sFrame = CGRectMake(referencePoint.x - [self segmentedControlWidth] / 2.0,
                               referencePoint.y - kTopBottomSpace - kMenuHeight,
                               [self segmentedControlWidth],
                               kMenuHeight);
    if (sFrame.origin.y < 0.0) {
        sFrame.origin.y = referencePoint.y + kTopBottomSpace;
        self.isDown = YES;
    }
    else {
        self.isDown = NO;
    }
    
    
    CGFloat triangleX = referencePoint.x - 20.0;
    if (referencePoint.x < 20.0) {
        triangleX = 20.0;
    }
    else if (referencePoint.x > CGRectGetWidth(self.view.bounds) - 66.0) {
        triangleX = CGRectGetWidth(self.view.bounds) - 66.0;
    }
    self.upTriangleView.frame = CGRectMake(triangleX,
                                           sFrame.origin.y - 20.0,
                                           40,
                                           20);
    self.downTriangleView.frame = CGRectMake(triangleX,
                                             sFrame.origin.y + kMenuHeight,
                                             40,
                                             20);
    if (sFrame.origin.x < 0 + kLeftRightSpace) {
        sFrame.origin.x = 0.0 + kLeftRightSpace;
    }
    else if (sFrame.origin.x + sFrame.size.width > CGRectGetWidth(self.view.bounds) - kLeftRightSpace) {
        sFrame.origin.x = CGRectGetWidth(self.view.bounds) - sFrame.size.width - kLeftRightSpace;
    }
    self.segmentedControl.frame = sFrame;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.view];
    [UIView animateWithDuration:0.15 animations:^{
        self.segmentedControl.alpha = 1.0;
        if (self.isDown) {
            self.upTriangleView.alpha = 1.0;
        }
        else {
            self.downTriangleView.alpha = 1.0;
        }
    }];
}

- (void)dismiss {
    self.segmentedControl.alpha = 0.0;
    self.upTriangleView.alpha = 0.0;
    self.downTriangleView.alpha = 0.0;
    [self.view removeFromSuperview];
}

#pragma mark - UISegmentedControl

- (void)updateControl {
    [self.segmentedControl removeAllSegments];
    [self.titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        [self.segmentedControl insertSegmentWithTitle:obj atIndex:idx animated:NO];
        CGSize textSize = [obj boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                            options:kNilOptions
                                         attributes:@{
                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                      NSFontAttributeName: [UIFont systemFontOfSize:14.0]
                                                      }
                                            context:NULL].size;
        [self.segmentedControl setWidth:textSize.width + 32.0 forSegmentAtIndex:idx];
    }];
}

- (void)handleValueChanged {
    if ([self.delegate respondsToSelector:@selector(menuItemDidPressed:itemIndex:)]) {
        [self.delegate menuItemDidPressed:self itemIndex:self.segmentedControl.selectedSegmentIndex];
    }
    [self.segmentedControl setSelectedSegmentIndex:-1];
    [self dismiss];
}

- (CGFloat)segmentedControlWidth {
    __block CGFloat width = 0.0;
    [self.titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        CGSize textSize = [obj boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)
                                            options:kNilOptions
                                         attributes:@{
                                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                                      NSFontAttributeName: [UIFont systemFontOfSize:14.0]
                                                      }
                                            context:NULL].size;
        width += textSize.width;
        width += 32.0;
    }];
    if ([self.titles count] > 1) {
        width += 4.0;
    }
    return width;
}

#pragma mark - Private

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - Getter

- (UIView *)upTriangleView {
    if (_upTriangleView == nil) {
        _upTriangleView = [[PCUPopMenuUpTriangleView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _upTriangleView.backgroundColor = [UIColor clearColor];
        _upTriangleView.alpha = 0.0;
    }
    return _upTriangleView;
}

- (UIView *)downTriangleView {
    if (_downTriangleView == nil) {
        _downTriangleView = [[PCUPopMenuDownTriangleView alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        _downTriangleView.backgroundColor = [UIColor clearColor];
        _downTriangleView.alpha = 0.0;
    }
    return _downTriangleView;
}

- (UISegmentedControl *)segmentedControl {
    if (_segmentedControl == nil) {
        _segmentedControl = [[UISegmentedControl alloc] init];
        _segmentedControl.tintColor = [UIColor clearColor];
        _segmentedControl.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.85];
        _segmentedControl.layer.cornerRadius = 6.0f;
        _segmentedControl.layer.masksToBounds = YES;
        [_segmentedControl setTitleTextAttributes:@{
                                                    NSForegroundColorAttributeName: [UIColor whiteColor],
                                                    NSFontAttributeName: [UIFont systemFontOfSize:14.0]
                                                    } forState:UIControlStateNormal];
        [_segmentedControl setTitleTextAttributes:@{
                                                    NSForegroundColorAttributeName: [UIColor colorWithWhite:1.0 alpha:0.5]
                                                    } forState:UIControlStateHighlighted];
        [_segmentedControl setDividerImage:[self imageWithColor:[UIColor colorWithWhite:1.0 alpha:0.25]]
                       forLeftSegmentState:UIControlStateNormal
                         rightSegmentState:UIControlStateNormal
                                barMetrics:UIBarMetricsDefault];
        [_segmentedControl addTarget:self
                              action:@selector(handleValueChanged)
                    forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

@end

@implementation PCUPopMenuUpTriangleView

- (void)drawRect:(CGRect)rect {
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithWhite:0.0 alpha:0.85];
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Polygon Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 20, 17);
    
    UIBezierPath* polygonPath = UIBezierPath.bezierPath;
    [polygonPath moveToPoint: CGPointMake(0, -7.25)];
    [polygonPath addLineToPoint: CGPointMake(9.74, 3.62)];
    [polygonPath addLineToPoint: CGPointMake(-9.74, 3.63)];
    [polygonPath closePath];
    [color setFill];
    [polygonPath fill];
    
    CGContextRestoreGState(context);


}

@end

@implementation PCUPopMenuDownTriangleView

- (void)drawRect:(CGRect)rect {
    
    //// Color Declarations
    UIColor* color = [UIColor colorWithWhite:0.0 alpha:0.85];
    
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Polygon Drawing
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 20, 3);
    CGContextRotateCTM(context, -180 * M_PI / 180);
    
    UIBezierPath* polygonPath = UIBezierPath.bezierPath;
    [polygonPath moveToPoint: CGPointMake(0, -7.25)];
    [polygonPath addLineToPoint: CGPointMake(9.74, 3.62)];
    [polygonPath addLineToPoint: CGPointMake(-9.74, 3.63)];
    [polygonPath closePath];
    [color setFill];
    [polygonPath fill];
    
    CGContextRestoreGState(context);

}

@end

