//
//  PCUSelectionShape.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/10.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import "PCUSelectionShape.h"

@interface PCUSelectionShapeNormal : UIView

@end

@interface PCUSelectionShapeSelected : UIView

@end

@interface PCUSelectionShape ()

@property (nonatomic, strong) PCUSelectionShapeNormal *normalView;

@property (nonatomic, strong) PCUSelectionShapeSelected *selectedView;

@end

@implementation PCUSelectionShape

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.normalView];
        [self addSubview:self.selectedView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.selectedView.hidden = NO;
        self.normalView.hidden = YES;
    }
    else {
        self.selectedView.hidden = YES;
        self.normalView.hidden = NO;
    }
}

- (PCUSelectionShapeNormal *)normalView {
    if (_normalView == nil) {
        _normalView = [[PCUSelectionShapeNormal alloc] initWithFrame:self.bounds];
        _normalView.hidden = NO;
        _normalView.backgroundColor = [UIColor clearColor];
    }
    return _normalView;
}

- (PCUSelectionShapeSelected *)selectedView {
    if (_selectedView == nil) {
        _selectedView = [[PCUSelectionShapeSelected alloc] initWithFrame:self.bounds];
        _selectedView.hidden = YES;
        _selectedView.backgroundColor = [UIColor clearColor];
    }
    return _selectedView;
}

@end

@implementation PCUSelectionShapeNormal

- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.796 green: 0.796 blue: 0.796 alpha: 1];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 21, 21)];
    [color setStroke];
    ovalPath.lineWidth = 1.5;
    [ovalPath stroke];
}

@end

@implementation PCUSelectionShapeSelected

- (void)drawRect:(CGRect)rect {
    //// Color Declarations
    UIColor* color = [UIColor colorWithRed: 0.035 green: 0.733 blue: 0.027 alpha: 1];
    
    //// Oval Drawing
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(3, 3, 21, 21)];
    [color setFill];
    [ovalPath fill];
    [color setStroke];
    ovalPath.lineWidth = 1.5;
    [ovalPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(7.5, 15)];
    [bezier2Path addLineToPoint: CGPointMake(11.07, 19.19)];
    [bezier2Path addLineToPoint: CGPointMake(20.5, 10)];
    [bezier2Path addLineToPoint: CGPointMake(11.07, 16.97)];
    [bezier2Path addLineToPoint: CGPointMake(7.1, 14.63)];
    [bezier2Path addLineToPoint: CGPointMake(6.5, 14.31)];
    [UIColor.whiteColor setFill];
    [bezier2Path fill];
    [UIColor.whiteColor setStroke];
    bezier2Path.lineWidth = 1;
    [bezier2Path stroke];
    
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 1;
    [bezierPath stroke];


}

@end