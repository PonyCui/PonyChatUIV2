//
//  PCUSlideUpItemInteractor.m
//  xiaoquan
//
//  Created by 崔 明辉 on 15/9/6.
//  Copyright (c) 2015年 Pony.Cui. All rights reserved.
//

#import "PCUSlideUpItemInteractor.h"
#import "PCUSlideUpEntity.h"

@interface PCUSlideUpItemInteractor ()

@property (nonatomic, copy) PCUSlideUpEntity *item;

@end

@implementation PCUSlideUpItemInteractor

- (instancetype)initWithSlideUpItem:(PCUSlideUpEntity *)item
{
    self = [super init];
    if (self) {
        _item = item;
        _messageID = item.messageID;
        _titleText = item.titleText;
    }
    return self;
}

- (void)updateWithMessageID:(NSString *)messageID {
    if ([messageID isEqualToString:self.item.messageID]) {
        self.hidden = YES;
        [self.delegate slideUpItemInteractorBeHidden:self];
    }
}

@end
