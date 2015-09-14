//
//  PCULinkMessageEntity.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/14.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import "PCULinkMessageEntity.h"

@implementation PCULinkMessageEntity

- (instancetype)initWithForwardMessageItem:(PCULinkMessageEntity *)messageItem {
    self = [super initWithForwardMessageItem:messageItem];
    if (self) {
        _messageText = messageItem.messageText;
        _descriptionText = messageItem.descriptionText;
        _thumbURLString = messageItem.thumbURLString;
        _linkURLString = messageItem.linkURLString;
    }
    return self;
}

@end
