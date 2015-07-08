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

@property (nonatomic, strong) ASImageNode *backgroundImageNode;

@end

@implementation PCUVoiceMessageCell

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super initWithMessageInteractor:messageInteractor];
    if (self) {
        [self addSubnode:self.backgroundImageNode];
        [self addSubnode:self.voiceImageNode];
    }
    return self;
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize superSize = [super calculateSizeThatFits:constrainedSize];
    superSize.height += kCellGaps;
    return superSize;
}

- (void)layout {
    CGFloat backgroundWidth = MAX(1.0, [[self voiceMessageInteractor] voiceDuration] / 60.0) * 260.0;
    if ([super actionType] == PCUMessageActionTypeSend) {
        self.backgroundImageNode.image = [UIImage imageNamed:@"SenderTextNodeBkg"];
        self.backgroundImageNode.frame = CGRectMake(self.calculatedSize.width - kAvatarSize - 10.0 - backgroundWidth, 0.0, backgroundWidth, 44.0);
    }
    else if ([super actionType] == PCUMessageActionTypeReceive) {
        self.backgroundImageNode.image = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
        self.backgroundImageNode.frame = CGRectMake(kAvatarSize + 10.0, 0.0, backgroundWidth, 44.0);
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
    }
    return _voiceImageNode;
}

- (ASImageNode *)backgroundImageNode {
    if (_backgroundImageNode == nil) {
        _backgroundImageNode = [[ASImageNode alloc] init];
        _backgroundImageNode.backgroundColor = [UIColor clearColor];
    }
    return _backgroundImageNode;
}

@end
