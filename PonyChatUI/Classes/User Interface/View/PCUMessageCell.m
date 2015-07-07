//
//  PCUMessageCell.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUMessageInteractor.h"
#import "PCUTextMessageItemInteractor.h"
#import "PCUMessageCell.h"
#import "PCUTextMessageCell.h"

@interface PCUMessageCell ()

@property (nonatomic, strong) ASNetworkImageNode *avatarImageNode;

@end

@implementation PCUMessageCell

+ (PCUMessageCell *)cellForMessageInteractor:(PCUMessageItemInteractor *)messageInteractor {
    if ([messageInteractor isKindOfClass:[PCUTextMessageItemInteractor class]]) {
        return [[PCUTextMessageCell alloc] initWithMessageInteractor:messageInteractor];
    }
    else {
        return [[PCUMessageCell alloc] initWithMessageInteractor:messageInteractor];
    }
}

- (instancetype)initWithMessageInteractor:(PCUMessageItemInteractor *)messageInteractor
{
    self = [super init];
    if (self) {
        [super setSelectionStyle:UITableViewCellSelectionStyleNone];
        _messageInteractor = messageInteractor;
        [self addSubnode:self.avatarImageNode];
    }
    return self;
}

#pragma mark - Node

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    return CGSizeMake(constrainedSize.width, kAvatarSize + kCellGaps);
}

- (void)layout {
    if (self.actionType == PCUMessageActionTypeSend) {
        self.avatarImageNode.frame = CGRectMake(self.calculatedSize.width - 10 - kAvatarSize, 5, kAvatarSize, kAvatarSize);
    }
    else if (self.actionType == PCUMessageActionTypeReceive) {
        self.avatarImageNode.frame = CGRectMake(10, 5, kAvatarSize, kAvatarSize);
    }
    else {
        self.avatarImageNode.frame = CGRectZero;
    }
}

#pragma mark - Getter

- (ASNetworkImageNode *)avatarImageNode {
    if (_avatarImageNode == nil) {
        _avatarImageNode = [[ASNetworkImageNode alloc] init];
        _avatarImageNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _avatarImageNode.URL = [NSURL URLWithString:@"http://tp4.sinaimg.cn/1651799567/180/1290860930/1"];
//        _avatarImageNode.URL = [NSURL URLWithString:self.messageInteractor.avatarURLString];
    }
    return _avatarImageNode;
}

- (PCUMessageActionType)actionType {
    if (_actionType == 0) {
        if (arc4random() % 2 == 0) {
            _actionType = PCUMessageActionTypeSend;
        }
        else {
            _actionType = PCUMessageActionTypeReceive;
        }
    }
    return _actionType;
}

@end
