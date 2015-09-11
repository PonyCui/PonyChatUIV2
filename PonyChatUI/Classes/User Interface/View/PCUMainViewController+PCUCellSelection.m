//
//  PCUMainViewController+PCUCellSelection.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/11.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import "PCUMainViewController+PCUCellSelection.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUMessageCell.h"

@interface PCUMainViewController (PCUCellSelectionProperty) <PCUMessageCellDelegate>

@property (nonatomic, readonly) ASTableView *tableView;

@end

@implementation PCUMainViewController (PCUCellSelection)

- (void)mainViewShouldEnteringSeletionMode {
    [self setSelecting:YES];
}

- (void)messageCellShouldToggleSelection:(PCUMessageCell *)cell messageItem:(PCUMessageEntity *)messageItem {
    if ([self.selectedItems containsObject:messageItem]) {
        NSMutableArray *items = [self.selectedItems mutableCopy];
        [items removeObject:messageItem];
        self.selectedItems = items;
        [cell setSelected:NO];
    }
    else {
        NSMutableArray *items = [self.selectedItems mutableCopy];
        [items addObject:messageItem];
        self.selectedItems = items;
        [cell setSelected:YES];
    }
}

- (void)setSelecting:(BOOL)selecting {
    self.isSelecting = selecting;
    [self configureNavigationItem];
    [[[self.tableView visibleNodes] copy] enumerateObjectsUsingBlock:^(PCUMessageCell *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj setSelecting:selecting animated:YES];
    }];
}

- (void)configureNavigationItem {
    if (self.isSelecting) {
        if (self.originLeftItem == nil) {
            self.originLeftItem = self.parentViewController.navigationItem.leftBarButtonItem;
        }
        if (self.originRightItem == nil) {
            self.originRightItem = self.parentViewController.navigationItem.rightBarButtonItem;
        }
        if (self.originRightItems == nil) {
            self.originRightItems = self.parentViewController.navigationItem.rightBarButtonItems;
        }
        self.parentViewController.navigationItem.hidesBackButton = YES;
        self.parentViewController.navigationItem.leftBarButtonItem = [self selectionCancelButtonItem];
        self.parentViewController.navigationItem.rightBarButtonItem = [self selectionConfirmButtonItem];
    }
    else {
        self.parentViewController.navigationItem.hidesBackButton = NO;
        if (self.originLeftItem != nil) {
            self.parentViewController.navigationItem.leftBarButtonItem = self.originLeftItem;
        }
        else {
            self.parentViewController.navigationItem.leftBarButtonItem = nil;
        }
        if (self.originRightItems != nil) {
            self.parentViewController.navigationItem.rightBarButtonItems = self.originRightItems;
        }
        else if (self.originRightItem != nil) {
            self.parentViewController.navigationItem.rightBarButtonItem = self.originRightItem;
        }
        else {
            self.parentViewController.navigationItem.rightBarButtonItem = nil;
            self.parentViewController.navigationItem.rightBarButtonItems = nil;
        }
    }
}

- (UIBarButtonItem *)selectionCancelButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(handleSelectionCancelButtonItemTapped)];
    return item;
}

- (UIBarButtonItem *)selectionConfirmButtonItem {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"批量操作" style:UIBarButtonItemStylePlain target:self action:@selector(handleSelectionConfirmButtonItemTapped)];
    return item;
}

- (void)handleSelectionCancelButtonItemTapped {
    [self setSelecting:NO];
    self.selectedItems = @[];
}

- (void)handleSelectionConfirmButtonItemTapped {
    if ([self.delegate respondsToSelector:@selector(PCURequireBatchOperateWithMessageItems:completionBlock:)]) {
        [self.delegate PCURequireBatchOperateWithMessageItems:self.selectedItems
                                              completionBlock:^(BOOL finished) {
                                                  if (finished) {
                                                      [self setSelecting:NO];
                                                      self.selectedItems = @[];
                                                  }
                                              }];
    }
}

#pragma mark - Delegate

- (void)cs_tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        PCUMessageCell *node = (id)[tableView nodeForRowAtIndexPath:indexPath];
        [node setSelecting:self.isSelecting animated:NO];
    }
}

@end
