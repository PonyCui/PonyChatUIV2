//
//  PCUSlideUpCell.m
//  xiaoquan
//
//  Created by 崔 明辉 on 15/9/6.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import "PCUSlideUpCell.h"
#import "PCUSlideUpItemInteractor.h"

@interface PCUSlideUpCellArrow : UIView

@end

@interface PCUSlideUpCell ()

@property (nonatomic, strong) PCUSlideUpItemInteractor *itemInteractor;

@property (nonatomic, strong) ASControlNode *contentNode;

@property (nonatomic, strong) ASDisplayNode *backgroundNode;

@property (nonatomic, strong) ASTextNode    *textNode;

@property (nonatomic, strong) ASDisplayNode *arrowNode;

@end

@implementation PCUSlideUpCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self addSubnode:self.contentNode];
        [self.contentNode addSubnode:self.backgroundNode];
        [self.contentNode addSubnode:self.textNode];
        [self.contentNode addSubnode:self.arrowNode];
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return CGSizeMake(constrainedSize.width, 50.0);
}

- (void)layout {
    [self.textNode measure:self.calculatedSize];
    self.contentNode.frame = CGRectMake(84.0 - self.textNode.calculatedSize.width - 10.0, 0.0, 114.0, 50.0);
    self.backgroundNode.frame = CGRectMake(0.0, 7.0, 114.0 + 17.0, 36.0);
    self.textNode.frame = CGRectMake(30.0, 7.0 + 9.0, 114.0 - 30.0, 18.0);
    self.arrowNode.frame = CGRectMake(12.0, 7.0 + 10.0, 14.0, 16.0);
}

- (void)handleCellTapped {
    [self.delegate slideUpCellTapped:self.itemInteractor];
}

#pragma mark - Reload

- (void)updateWithItemInteractor:(PCUSlideUpItemInteractor *)itemInteractor {
    self.itemInteractor = itemInteractor;
    if (itemInteractor.titleText != nil) {
        self.textNode.attributedString = [[NSAttributedString alloc]
                                          initWithString:itemInteractor.titleText
                                          attributes:@{
                                                       NSForegroundColorAttributeName: [UIColor
                                                                                        colorWithRed:240.0/255.0
                                                                                        green:121.0/255.0
                                                                                        blue:97.0/255.0
                                                                                        alpha:1.0],
                                                       NSFontAttributeName: [UIFont systemFontOfSize:15.0]
                                                       }];
    }
}

#pragma mark - Getter

- (ASControlNode *)contentNode {
    if (_contentNode == nil) {
        _contentNode = [[ASControlNode alloc] init];
        [_contentNode addTarget:self action:@selector(handleCellTapped) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _contentNode;
}

- (ASDisplayNode *)backgroundNode {
    if (_backgroundNode == nil) {
        _backgroundNode = [[ASDisplayNode alloc] init];
        _backgroundNode.backgroundColor = [UIColor colorWithRed:249.0/255.0
                                                          green:249.0/255.0
                                                           blue:249.0/255.0
                                                          alpha:1.0];
        _backgroundNode.layer.cornerRadius = 18.0f;
        _backgroundNode.layer.borderColor = [UIColor colorWithRed:211.0/255.0
                                                            green:211.0/255.0
                                                             blue:211.0/255.0
                                                            alpha:1.0].CGColor;
        _backgroundNode.layer.borderWidth = 0.5f;
    }
    return _backgroundNode;
}

- (ASTextNode *)textNode {
    if (_textNode == nil) {
        _textNode = [[ASTextNode alloc] init];
        _textNode.backgroundColor = [UIColor clearColor];
    }
    return _textNode;
}

- (ASDisplayNode *)arrowNode {
    if (_arrowNode == nil) {
        _arrowNode = [[ASDisplayNode alloc] initWithViewBlock:^UIView *{
            return [[PCUSlideUpCellArrow alloc] initWithFrame:CGRectMake(0, 0, 14, 16)];
        }];
    }
    return _arrowNode;
}

@end

@implementation PCUSlideUpCellArrow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *arrowColor = [UIColor
                           colorWithRed:240.0/255.0
                           green:121.0/255.0
                           blue:97.0/255.0
                           alpha:1.0];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = UIBezierPath.bezierPath;
    [bezierPath moveToPoint: CGPointMake(3, 7)];
    [bezierPath addLineToPoint: CGPointMake(7, 3)];
    [bezierPath addLineToPoint: CGPointMake(11, 7)];
    [arrowColor setStroke];
    bezierPath.lineWidth = 2;
    [bezierPath stroke];
    
    
    //// Bezier 2 Drawing
    UIBezierPath* bezier2Path = UIBezierPath.bezierPath;
    [bezier2Path moveToPoint: CGPointMake(3, 13)];
    [bezier2Path addLineToPoint: CGPointMake(7, 9)];
    [bezier2Path addLineToPoint: CGPointMake(11, 13)];
    [arrowColor setStroke];
    bezier2Path.lineWidth = 2;
    [bezier2Path stroke];
}

@end
