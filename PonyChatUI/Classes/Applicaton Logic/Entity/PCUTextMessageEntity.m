//
//  PCUTextMessageEntity.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUTextMessageEntity.h"

@implementation PCUTextMessageEntity

- (instancetype)initWithForwardMessageItem:(PCUTextMessageEntity *)messageItem {
    self = [super initWithForwardMessageItem:messageItem];
    if (self) {
        self.messageText = messageItem.messageText;
    }
    return self;
}

@end
