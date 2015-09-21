//
//  PCUMessageManager.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import "PCUMessageManager.h"

@interface PCUMessageManager ()

@end

@implementation PCUMessageManager

- (void)addInitalizeMessageItems:(NSArray<PCUMessageEntity *> *)messageItems {
    [self didReceiveMessageItems:messageItems];
}

- (void)didInsertMessageItem:(PCUMessageEntity *)messageItem nextItem:(PCUMessageEntity *)nextItem {
    if (messageItem != nil && ![self.messageItems containsObject:messageItem]) {
        NSMutableArray *messageItems = [self.messageItems mutableCopy];
        [messageItems addObject:messageItem];
        PCUSystemMessageEntity *dateItem = [self dateItemCompareCurrentItem:messageItem nextItem:nextItem];
        if (dateItem != nil) {
            [messageItems addObject:dateItem];
        }
        self.messageItems = [self sortedItems:messageItems];
        [self.delegate messageManagerItemsDidChanged];
    }
}

- (void)didReceiveMessageItem:(PCUMessageEntity *)messageItem {
    if (messageItem != nil && ![self.messageItems containsObject:messageItem]) {
        NSMutableArray *messageItems = [self.messageItems mutableCopy];
        [messageItems addObject:messageItem];
        self.messageItems = [self sortedItems:messageItems];
        [self addDateItem];
        [self.delegate messageManagerItemsDidChanged];
    }
}

- (void)didReceiveMessageItems:(NSArray<PCUMessageEntity *> *)messageItems {
    if (messageItems != nil) {
        NSMutableArray *theMessageItems = [self.messageItems mutableCopy];
        [theMessageItems addObjectsFromArray:messageItems];
        self.messageItems = [self sortedItems:theMessageItems];
        [self addDateItem];
        [self.delegate messageManagerItemsDidChanged];
    }
}

- (void)didDeletedMessageItem:(PCUMessageEntity *)messageItem {
    if (messageItem != nil && [self.messageItems containsObject:messageItem]) {
        NSMutableArray *theMessageItems = [self.messageItems mutableCopy];
        NSUInteger theIndex = [theMessageItems indexOfObject:messageItem];
        if (theIndex < [theMessageItems count]) {
            [theMessageItems removeObject:messageItem];
        }
        self.messageItems = theMessageItems;
        [self.delegate messageManagerItemDidDeletedWithIndex:theIndex];
    }
}

- (void)addSlideUpItem:(PCUSlideUpEntity *)slideUpItem {
    NSMutableArray *items = [self.slideUpItems mutableCopy];
    [items addObject:slideUpItem];
    self.slideUpItems = items;
    [self.delegate messageManagerSlideUpItemsDidChanged];
}

- (PCUSystemMessageEntity *)dateItemCompareCurrentItem:(PCUMessageEntity *)currentItem
                                              nextItem:(PCUMessageEntity *)nextItem {
    if ([currentItem.messageDate timeIntervalSinceDate:nextItem.messageDate] > 180 || nextItem == nil) {
        //create an system message with date and return
        PCUSystemMessageEntity *item = [[PCUSystemMessageEntity alloc] init];
        item.messageID = [NSString stringWithFormat:@"%f", currentItem.messageOrder - 0.05];
        item.messageOrder = currentItem.messageOrder - 0.000001;
        item.messageDate = currentItem.messageDate;
        item.messageText = [self dateDescription:item.messageDate];
        return item;
    }
    else {
        return nil;
    }
}

- (void)addDateItem {
    __block NSDate *lastDate = [NSDate distantPast];
    NSMutableArray *items = [NSMutableArray array];
    [self.messageItems enumerateObjectsUsingBlock:^(PCUMessageEntity *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PCUSystemMessageEntity class]]) {
            lastDate = obj.messageDate;
        }
        else if ([obj.messageDate timeIntervalSinceDate:lastDate] > 180.0) {
            //create an system message with date
            PCUSystemMessageEntity *item = [[PCUSystemMessageEntity alloc] init];
            item.messageID = [NSString stringWithFormat:@"%f", obj.messageOrder - 0.05];
            item.messageOrder = obj.messageOrder - 0.000001;
            item.messageDate = obj.messageDate;
            item.messageText = [self dateDescription:item.messageDate];
            [items addObject:item];
            lastDate = obj.messageDate;
        }
        else {
            lastDate = obj.messageDate;
        }
        [items addObject:obj];
    }];
    self.messageItems = [self sortedItems:items];
}

- (NSString *)dateDescription:(NSDate *)date {
    static NSDateFormatter *timeFormatter;
    static NSDateFormatter *dateFormatter;
    static NSDateFormatter *previousDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timeFormatter = [[NSDateFormatter alloc] init];
        timeFormatter.dateFormat = @"a hh:mm";
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM/dd";
        previousDateFormatter = [[NSDateFormatter alloc] init];
        previousDateFormatter.dateFormat = @"MM/dd HH:mm";
    });
    if ([[dateFormatter stringFromDate:date]
         isEqualToString:[dateFormatter stringFromDate:[NSDate date]]]) {
        //Today
        return [timeFormatter stringFromDate:date];
    }
    else {
        return [previousDateFormatter stringFromDate:date];
    }
}

- (NSArray<PCUMessageEntity *> *)sortedItems:(NSArray<PCUMessageEntity *> *)items {
    return [items sortedArrayUsingComparator:^NSComparisonResult(PCUMessageEntity *obj1, PCUMessageEntity *obj2) {
        if (obj1.messageOrder == obj2.messageOrder) {
            return NSOrderedSame;
        }
        else {
            return obj1.messageOrder > obj2.messageOrder ? NSOrderedDescending : NSOrderedAscending;
        }
    }];
}

- (NSArray<PCUMessageEntity *> *)messageItems {
    if (_messageItems == nil) {
        _messageItems = @[];
    }
    return _messageItems;
}

- (NSArray<PCUSlideUpEntity *> *)slideUpItems {
    if (_slideUpItems == nil) {
        _slideUpItems = @[];
    }
    return _slideUpItems;
}

@end
