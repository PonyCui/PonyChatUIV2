//
//  PCUMainViewController+PCUSlideUp.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/11.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import "PCUMainViewController+PCUSlideUp.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "PCUMainPresenter.h"
#import "PCUMessageInteractor.h"
#import "PCUMessageCell.h"
#import "PCUSlideUpCell.h"

@interface PCUMainViewController (PCUSlideUpProperties)

@property (nonatomic, readonly) ASTableView *tableView;

@end

@implementation PCUMainViewController (PCUSlideUp)

- (void)reloadSlideUpData {
    CGRect frame = self.slideUpTableView.frame;
    frame.size.height = 50.0 * [self.eventHandler.messageInteractor.slideUpItems count];
    self.slideUpTableView.frame = frame;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.slideUpTableView reloadData];
        [UIView animateWithDuration:0.25 animations:^{
            self.slideUpTableView.alpha = 1.0;
        }];
    });
}

- (void)deleteSlideUpDataWithRow:(NSUInteger)row {
    [self.slideUpTableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.slideUpTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.slideUpTableView endUpdatesAnimated:YES completion:nil];
}

- (void)slideToMessageWithMessageID:(NSString *)messageID {
    NSUInteger nodeIndex = NSNotFound;
    CGFloat    nodeOffset = 0.0;
    NSUInteger nodeCount = [self.tableView numberOfRowsInSection:0];
    for (NSUInteger i = 0; i < nodeCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        PCUMessageCell *cell = (id)[self.tableView nodeForRowAtIndexPath:indexPath];
        if ([cell.messageInteractor.messageItem.messageID isEqualToString:messageID]) {
            nodeIndex = i;
            break;
        }
        else {
            nodeOffset += CGRectGetHeight(cell.frame);
        }
    }
    if (nodeIndex != NSNotFound) {
        [self.tableView setContentOffset:CGPointMake(0, nodeOffset) animated:YES];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(PCURequireSlideToMessageID:)]) {
            self.tableView.automaticallyAdjustsContentOffset = YES;
            [self.delegate PCURequireSlideToMessageID:messageID];
            self.isSliding = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isSliding = NO;
            });
        }
    }
}

- (void)slideUpCellTapped:(PCUSlideUpItemInteractor *)itemInteractor {
    [self slideToMessageWithMessageID:itemInteractor.messageID];
}

#pragma mark - Delegate

- (void)su_tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        PCUMessageCell *node = (id)[tableView nodeForRowAtIndexPath:indexPath];
        if ([self.eventHandler.messageInteractor.slideUpItems count] > 0) {
            [self.eventHandler.messageInteractor.slideUpItems enumerateObjectsUsingBlock:^(PCUSlideUpItemInteractor *obj, NSUInteger idx, BOOL *stop) {
                [obj updateWithMessageID:node.messageInteractor.messageItem.messageID];
            }];
        }
    }
}

- (ASCellNode *)su_tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.eventHandler.messageInteractor.slideUpItems count]) {
        PCUSlideUpCell *cell = [[PCUSlideUpCell alloc] init];
        cell.delegate = self;
        [cell updateWithItemInteractor:self.eventHandler.messageInteractor.slideUpItems[indexPath.row]];
        return cell;
    }
    else {
        return [[PCUSlideUpCell alloc] init];
    }
}

@end
