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
    UIViewController *viewController = self;
    while (viewController.parentViewController != nil) {
        if ([viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
            break;
        }
        else {
            viewController = viewController.parentViewController;
        }
    }
    if (self.isSelecting) {
        if (self.originLeftItem == nil) {
            self.originLeftItem = viewController.navigationItem.leftBarButtonItem;
        }
        if (self.originRightItem == nil) {
            self.originRightItem = viewController.navigationItem.rightBarButtonItem;
        }
        if (self.originRightItems == nil) {
            self.originRightItems = viewController.navigationItem.rightBarButtonItems;
        }
        viewController.navigationItem.hidesBackButton = YES;
        viewController.navigationItem.leftBarButtonItem = [self selectionCancelButtonItem];
        if (self.originRightItems != nil) {
            viewController.navigationItem.rightBarButtonItems = nil;
        }
        viewController.navigationItem.rightBarButtonItem = [self selectionConfirmButtonItem];
    }
    else {
        viewController.navigationItem.hidesBackButton = NO;
        if (self.originLeftItem != nil) {
            viewController.navigationItem.leftBarButtonItem = self.originLeftItem;
        }
        else {
            viewController.navigationItem.leftBarButtonItem = nil;
        }
        if (self.originRightItems != nil) {
            viewController.navigationItem.rightBarButtonItems = self.originRightItems;
        }
        else if (self.originRightItem != nil) {
            viewController.navigationItem.rightBarButtonItem = self.originRightItem;
        }
        else {
            viewController.navigationItem.rightBarButtonItem = nil;
            viewController.navigationItem.rightBarButtonItems = nil;
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
