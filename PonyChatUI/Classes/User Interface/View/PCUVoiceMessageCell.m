//
//  PCUVoiceMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUVoiceMessageCell.h"
#import "PCUVoiceMessageItemInteractor.h"
#import "PCUVoiceMessageEntity.h"

@interface PCUVoiceMessageCell ()

@property (nonatomic, strong) ASImageNode *voiceImageNode;

@property (nonatomic, strong) ASTextNode *voiceLengthTextNode;

@property (nonatomic, strong) ASImageNode *backgroundImageNode;

@end

@implementation PCUVoiceMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self addSubnode:self.backgroundImageNode];
        [self addSubnode:self.voiceImageNode];
        [self addSubnode:self.voiceLengthTextNode];
    }
    return self;
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize superSize = [super calculateSizeThatFits:constrainedSize];
    superSize.height += kCellGaps;
    [self.voiceLengthTextNode measure:constrainedSize];
    return superSize;
}

- (void)layout {
    [super layout];
    CGFloat backgroundWidth = MAX(88.0, MIN(1.0, [[self voiceMessageInteractor] voiceDuration] / 60.0) * 160.0);
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.backgroundImageNode.image = [[UIImage imageNamed:@"SenderTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 10.0 - backgroundWidth, 2.0, backgroundWidth, 54.0);
        self.voiceImageNode.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
        self.voiceImageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 10.0 - 18.0 - self.voiceImageNode.image.size.width, 2.0, self.voiceImageNode.image.size.width, 44.0);
        self.voiceLengthTextNode.frame = CGRectMake(self.backgroundImageNode.frame.origin.x - self.voiceLengthTextNode.calculatedSize.width, 22.0, self.voiceLengthTextNode.calculatedSize.width, self.voiceLengthTextNode.calculatedSize.height);
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.backgroundImageNode.image = [[UIImage imageNamed:@"ReceiverTextNodeBkg"] resizableImageWithCapInsets:UIEdgeInsetsMake(28, 20, 15, 20) resizingMode:UIImageResizingModeStretch];
        self.backgroundImageNode.frame = CGRectMake(kAvatarSize + 10.0, 2.0, backgroundWidth, 54.0);
        self.voiceImageNode.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
        self.voiceImageNode.frame = CGRectMake(kAvatarSize + 10.0 + 18.0, 2.0, self.voiceImageNode.image.size.width, 44.0);
        self.voiceLengthTextNode.frame = CGRectMake(self.backgroundImageNode.frame.origin.x + self.backgroundImageNode.frame.size.width, 22.0, self.voiceLengthTextNode.calculatedSize.width, self.voiceLengthTextNode.calculatedSize.height);
    }
    else {
        self.backgroundImageNode.hidden = YES;
    }
}

#pragma mark - Getter

- (PCUVoiceMessageItemInteractor *)voiceMessageInteractor {
    return (id)[super messageInteractor];
}

- (ASImageNode *)voiceImageNode {
    if (_voiceImageNode == nil) {
        _voiceImageNode = [[ASImageNode alloc] init];
        _voiceImageNode.backgroundColor = [UIColor clearColor];
        _voiceImageNode.contentMode = UIViewContentModeCenter;
    }
    return _voiceImageNode;
}

- (ASTextNode *)voiceLengthTextNode {
    if (_voiceLengthTextNode == nil) {
        _voiceLengthTextNode = [[ASTextNode alloc] init];
        _voiceLengthTextNode.attributedString = [[NSAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%.0f''", [[self voiceMessageInteractor] voiceDuration]]
                                                 attributes:@{
                                                              NSFontAttributeName: [UIFont systemFontOfSize:14.0],
                                                              NSForegroundColorAttributeName: [UIColor grayColor]
                                                              }];
    }
    return _voiceLengthTextNode;
}

- (ASImageNode *)backgroundImageNode {
    if (_backgroundImageNode == nil) {
        _backgroundImageNode = [[ASImageNode alloc] init];
        _backgroundImageNode.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageNode;
}

@end
