//
//  PCUMessageItemInteractor.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PCUMessageItemInteractor.h"
#import "PCUMessageEntity.h"
#import "PCUTextMessageEntity.h"
#import "PCUTextMessageItemInteractor.h"
#import "PCUSystemMessageEntity.h"
#import "PCUSystemMessageItemInteractor.h"
#import "PCUImageMessageEntity.h"
#import "PCUImageMessageItemInteractor.h"
#import "PCUVoiceMessageEntity.h"
#import "PCUVoiceMessageItemInteractor.h"
#import "PCULinkMessageEntity.h"
#import "PCULinkMessageItemInteractor.h"

@implementation PCUMessageItemInteractor

+ (PCUMessageItemInteractor *)itemInteractorWithMessageItem:(PCUMessageEntity *)messageItem {
    if ([messageItem isKindOfClass:[PCUTextMessageEntity class]]) {
        return [[PCUTextMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
    else if ([messageItem isKindOfClass:[PCUSystemMessageEntity class]]) {
        return [[PCUSystemMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
    else if ([messageItem isKindOfClass:[PCUImageMessageEntity class]]) {
        return [[PCUImageMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
    else if ([messageItem isKindOfClass:[PCUVoiceMessageEntity class]]) {
        return [[PCUVoiceMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
    else if ([messageItem isKindOfClass:[PCULinkMessageEntity class]]) {
        return [[PCULinkMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
    else {
        return [[PCUMessageItemInteractor alloc] initWithMessageItem:messageItem];
    }
}

- (instancetype)initWithMessageItem:(PCUMessageEntity *)messageItem
{
    self = [super init];
    if (self) {
        _messageItem = messageItem;
        _ownSender = messageItem.ownSender;
        _messageOrder = messageItem.messageOrder;
        _avatarURLString = messageItem.senderAvatarURLString;
        _nicknameString = messageItem.senderNicknameString;
        _sendingStatus = messageItem.sendingStatus;
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)configureReactiveCocoa {
    @weakify(self);
    if (self.sendingStatus != PCUMessageItemSendingStatusSucceed) {
        [RACObserve(self.messageItem, sendingStatus) subscribeNext:^(id x) {
            @strongify(self);
            self.sendingStatus = [x integerValue];
        }];
    }
    [RACObserve(self.messageItem, senderNicknameString) subscribeNext:^(id x) {
        @strongify(self);
        self.nicknameString = self.messageItem.senderNicknameString;
    }];
    [RACObserve(self.messageItem, senderAvatarURLString) subscribeNext:^(id x) {
        @strongify(self);
        self.avatarURLString = self.messageItem.senderAvatarURLString;
    }];
}

@end
