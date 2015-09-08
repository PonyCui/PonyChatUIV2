//
//  PCUImageMessageEntity.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/7.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUImageMessageEntity.h"

@implementation PCUImageMessageEntity

- (instancetype)initWithForwardMessageItem:(PCUImageMessageEntity *)messageItem
{
    self = [super initWithForwardMessageItem:messageItem];
    if (self) {
        self.imageURLString = [messageItem imageURLString];
        self.imageSize = [messageItem imageSize];
    }
    return self;
}

@end
