//
//  PCUTextMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUTextMessageCell.h"
#import "PCUTextMessageItemInteractor.h"

static const CGFloat kTextPaddingLeft = 18.0f;
static const CGFloat kTextPaddingRight = 18.0f;
static const CGFloat kTextPaddingTop = 12.0f;
static const CGFloat kTextPaddingBottom = 10.0f;

@interface PCUTextMessageCell ()

@property (nonatomic, strong) ASTextNode *textNode;

@property (nonatomic, strong) ASImageNode *backgroundImageNode;

@end

@implementation PCUTextMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self addSubnode:self.backgroundImageNode];
        [self addSubnode:self.textNode];
    }
    return self;
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize superSize = [super calculateSizeThatFits:constrainedSize];
    CGSize textSize = [self.textNode measure:CGSizeMake(constrainedSize.width - kAvatarSize - 10.0 - kTextPaddingLeft - kTextPaddingRight - 60.0,
                                                        constrainedSize.height)];
    CGFloat requiredHeight = MAX(superSize.height, textSize.height + kTextPaddingTop + kTextPaddingBottom);
    return CGSizeMake(constrainedSize.width, requiredHeight + kCellGaps);
}

- (void)layout {
    [super layout];
    if ([super actionType] == PCUMessageActionTypeSend) {
        CGRect textNodeFrame = CGRectMake(self.calculatedSize.width - kAvatarSize - 10.0 - kTextPaddingRight - self.textNode.calculatedSize.width,
                                          kTextPaddingTop,
                                          self.textNode.calculatedSize.width,
                                          self.textNode.calculatedSize.height);
        if (self.textNode.lineCount == 1 && self.textNode.calculatedSize.height < 19.0) {
            textNodeFrame.origin.y += 8.0;
        }
        else if (self.textNode.lineCount == 1) {
            textNodeFrame.origin.y += 3.0;
        }
        else {
            textNodeFrame.origin.y += 2.0;
        }
        self.textNode.frame = textNodeFrame;
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        CGRect textNodeFrame = CGRectMake(kAvatarSize + 10.0 + kTextPaddingLeft,
                                          kTextPaddingTop,
                                          self.textNode.calculatedSize.width,
                                          self.textNode.calculatedSize.height);
        if (self.textNode.lineCount == 1 && self.textNode.calculatedSize.height < 19.0) {
            textNodeFrame.origin.y += 8.0;
        }
        else if (self.textNode.lineCount == 1) {
            textNodeFrame.origin.y += 3.0;
        }
        else {
            textNodeFrame.origin.y += 2.0;
        }
        self.textNode.frame = textNodeFrame;
    }
    else {
        self.textNode.frame = CGRectZero;
    }
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.backgroundImageNode.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        CGRect frame = self.textNode.frame;
        frame.origin.x -= kTextPaddingLeft;
        frame.origin.y -= kTextPaddingTop;
        frame.size.width += kTextPaddingLeft + kTextPaddingRight;
        frame.size.height += kTextPaddingTop + kTextPaddingBottom + kTextPaddingBottom;
        if (self.textNode.lineCount == 1 && self.textNode.calculatedSize.height < 19.0) {
            frame.size.height += 6.0;
            frame.origin.y -= 3.0;
        }
        self.backgroundImageNode.frame = frame;
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.backgroundImageNode.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        CGRect frame = self.textNode.frame;
        frame.origin.x -= kTextPaddingLeft;
        frame.origin.y -= kTextPaddingTop;
        frame.size.width += kTextPaddingLeft + kTextPaddingRight;
        frame.size.height += kTextPaddingTop + kTextPaddingBottom + kTextPaddingBottom;
        if (self.textNode.lineCount == 1 && self.textNode.calculatedSize.height < 19.0) {
            frame.size.height += 6.0;
            frame.origin.y -= 3.0;
        }
        self.backgroundImageNode.frame = frame;
    }
    else {
        self.backgroundImageNode.hidden = YES;
    }
}

#pragma mark - Getter

- (PCUTextMessageItemInteractor *)textMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASTextNode *)textNode {
    if (_textNode == nil) {
        _textNode = [[ASTextNode alloc] init];
        NSString *text = [[self textMessageInteractor] messageText];
        if (text == nil) {
            text = @"";
        }
        _textNode.attributedString = [[NSAttributedString alloc] initWithString:text attributes:[self textStyle]];
    }
    return _textNode;
}

- (ASImageNode *)backgroundImageNode {
    if (_backgroundImageNode == nil) {
        _backgroundImageNode = [[ASImageNode alloc] init];
        _backgroundImageNode.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageNode;
}

- (NSDictionary *)textStyle {
    UIFont *font = [UIFont systemFontOfSize:kFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.25 * font.lineHeight;
    style.lineSpacing = 6.0f;
    style.hyphenationFactor = 1.0;
    return @{
             NSFontAttributeName: font,
             NSParagraphStyleAttributeName: style
             };
}

@end
