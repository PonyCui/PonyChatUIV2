//
//  PCULinkMessageItemInteractor.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/14.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import "PCULinkMessageItemInteractor.h"
#import "PCULinkMessageEntity.h"

@implementation PCULinkMessageItemInteractor

- (instancetype)initWithMessageItem:(PCULinkMessageEntity *)messageItem {
    self = [super initWithMessageItem:messageItem];
    if (self) {
        _titleString = messageItem.messageText;
        _subTitleString = messageItem.descriptionText;
        _thumbURLString = messageItem.thumbURLString;
        _linkURLString = messageItem.linkURLString;
        _largerLink = messageItem.largerLink;
    }
    return self;
}

@end
