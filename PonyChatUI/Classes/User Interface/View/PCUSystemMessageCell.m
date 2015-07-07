//
//  PCUSystemMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUSystemMessageCell.h"
#import "PCUSystemMessageItemInteractor.h"

static const CGFloat kTextPaddingTop = 6.0f;
static const CGFloat kTextPaddingLeft = 24.0f;
static const CGFloat kTextPaddingRight = 24.0f;
static const CGFloat kTextPaddingBottom = 6.0f;

@interface PCUSystemMessageCell ()

@property (nonatomic, strong) ASTextNode *textNode;

@end

@implementation PCUSystemMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self addSubnode:self.textNode];
    }
    return self;
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    if (constrainedSize.width == 0.0) {
        return CGSizeZero;
    }
    CGSize textSize = [self.textNode measure:CGSizeMake(constrainedSize.width - kTextPaddingLeft - kTextPaddingRight,
                                                        constrainedSize.height)];
    return CGSizeMake(constrainedSize.width, textSize.height + kTextPaddingTop + kTextPaddingBottom + kCellGaps);
}

- (void)layout {
    self.textNode.frame = CGRectMake((self.calculatedSize.width - self.textNode.calculatedSize.width) / 2.0,
                                     kTextPaddingTop,
                                     self.calculatedSize.width,
                                     self.calculatedSize.height);
}

#pragma mark - Getter

- (PCUSystemMessageItemInteractor *)systemMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASTextNode *)textNode {
    if (_textNode == nil) {
        _textNode = [[ASTextNode alloc] init];
        NSString *text = [[self systemMessageInteractor] messageText];
        if (text == nil) {
            text = @"";
        }
        _textNode.attributedString = [[NSAttributedString alloc] initWithString:text attributes:[self textStyle]];
    }
    return _textNode;
}

- (NSDictionary *)textStyle {
    UIFont *font = [UIFont systemFontOfSize:kFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.15 * font.lineHeight;
    style.hyphenationFactor = 1.0;
    return @{
             NSFontAttributeName: font,
             NSParagraphStyleAttributeName: style
             };
}

@end
