//
//  PCUMainViewController.m
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PCUCore.h"
#import "PCUMainViewController.h"
#import "PCUMainPresenter.h"
#import "PCUMessageInteractor.h"
#import "PCUMessageCell.h"
#import "PCUSlideUpCell.h"
#import "PCUMainViewController+PCUCellSelection.h"
#import "PCUMainViewController+PCUSlideUp.h"

@interface PCUTableView : ASTableView

@end

@interface PCUMainViewController ()<ASTableViewDataSource, ASTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ASTableView *tableView;

@property (nonatomic, strong) UIView      *activityIndicatorView;

@property (nonatomic, assign) BOOL hasReloaded;

@property (nonatomic, strong) NSTimer *reloadTimer;

@property (nonatomic, assign) NSUInteger lastRows;

@property (nonatomic, assign) BOOL disableAutoScroll;

@property (nonatomic, assign) BOOL noMoreMessages;

@property (nonatomic, assign) BOOL isFetchingMore;

@property (nonatomic, strong) NSTimer *fetchTimer;

@property (nonatomic, assign) BOOL isInsertingTwice;

@end

@implementation PCUMainViewController

#pragma mark - Object Life Cycle

- (void)dealloc
{
    _tableView.asyncDataSource = nil;
    _tableView.asyncDelegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _eventHandler = [[PCUMainPresenter alloc] init];
        _eventHandler.userInterface = self;
    }
    return self;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.slideUpTableView];
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0
                                                     green:235.0/255.0
                                                      blue:235.0/255.0
                                                     alpha:1.0];
    [self.eventHandler updateView];
    [self.tableView setAlpha:0.0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        [self.tableView setAlpha:1.0];
        [self.tableView.visibleNodes enumerateObjectsUsingBlock:^(PCUMessageCell *node, NSUInteger idx, BOOL *stop) {
            [self.eventHandler.messageInteractor.slideUpItems enumerateObjectsUsingBlock:^(PCUSlideUpItemInteractor *obj, NSUInteger idx, BOOL *stop) {
                [obj updateWithMessageID:node.messageInteractor.messageItem.messageID];
            }];
        }];
    });
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![UIView areAnimationsEnabled]) {
        [UIView setAnimationsEnabled:YES];
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.slideUpTableView.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 164.0,
                                             0.0,
                                             164.0,
                                             CGRectGetHeight(self.slideUpTableView.frame));
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.tableView reloadDataWithCompletion:^{
        [self forceScroll];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ASTableView

- (CGSize)contentSize {
    return self.tableView.contentSize;
}

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.row < [self.eventHandler.messageInteractor.items count]) {
            NSIndexPath *_indexPath = indexPath;
            if (self.isInsertingTwice) {
                _indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            }
            PCUMessageCell *cell = [PCUMessageCell cellForMessageInteractor:self.eventHandler.messageInteractor.items[_indexPath.row]];
            cell.delegate = self.delegate;
            cell.cellDelegate = (id)self;
            if ([self.delegate respondsToSelector:@selector(PCUCellShowNickname)]) {
                cell.showNickname = [self.delegate PCUCellShowNickname];
            }
            return cell;
        }
        else {
            return [PCUMessageCell cellForMessageInteractor:nil];
        }
    }
    else if (tableView == self.slideUpTableView) {
        return [self su_tableView:tableView nodeForRowAtIndexPath:indexPath];
    }
    else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return [self.eventHandler.messageInteractor.items count];
    }
    else if (tableView == self.slideUpTableView) {
        return [self.eventHandler.messageInteractor.slideUpItems count];
    }
    else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (void)tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        PCUMessageCell *node = (id)[tableView nodeForRowAtIndexPath:indexPath];
        [node resume];
        [self cs_tableView:tableView willDisplayNodeForRowAtIndexPath:indexPath];
        [self su_tableView:tableView willDisplayNodeForRowAtIndexPath:indexPath];
    }
}

- (void)reloadData {
    [self.tableView reloadDataWithCompletion:^{
        self.lastRows = [self.tableView numberOfRowsInSection:0];
        self.hasReloaded = YES;
        if (self.tableView.alpha == 0.0) {
            [UIView animateKeyframesWithDuration:0.20 delay:0.20 options:kNilOptions animations:^{
                self.tableView.alpha = 1.0;
            } completion:^(BOOL finished) {
                self.tableView.alpha = 1.0;
            }];
        }
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self forceScroll];
    });
}

- (void)insertDataWithIndexes:(NSArray<NSNumber *> *)indexes {
    if (indexes == nil || [indexes count] == 0) {
        return;
    }
    if (!self.hasReloaded) {
        [self.reloadTimer invalidate];
        self.reloadTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                            target:self
                                                          selector:@selector(reloadData)
                                                          userInfo:nil
                                                           repeats:NO];
    }
    else {
        BOOL isPushing = NO;
        if ([[indexes lastObject] unsignedIntegerValue] >= self.lastRows) {
            isPushing = YES;
        }
        [self.tableView beginUpdates];
        for (NSNumber *index in indexes) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[index unsignedIntegerValue] inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self.tableView endUpdatesAnimated:NO completion:^(BOOL completed) {
            self.lastRows = [self.tableView numberOfRowsInSection:0];
            if (self.isSliding) {
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            }
            else if (isPushing) {
                [self autoScroll];
            }
        }];
    }
}

- (void)deleteDataWithRow:(NSUInteger)row {
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdatesAnimated:YES completion:nil];
}

- (void)autoScroll {
    if (self.tableView.isTracking || self.disableAutoScroll) {
        return;
    }
    else if (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height * 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.tableView.isTracking || self.disableAutoScroll || self.tableView.contentOffset.y < self.tableView.contentSize.height - self.tableView.frame.size.height * 2) {
                return;
            }
            [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 1, 1, 1)
                                       animated:YES];
        });
    }
}

- (void)forceScroll {
    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 1, 1, 1)
                               animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 1, 1, 1)
                                   animated:NO];
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(PCUEndEditing)]) {
        [self.delegate PCUEndEditing];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (!self.tableView.isTracking) {
            if (self.tableView.contentOffset.y < -22.0) {
                [self handleFetchingMoreTrigger];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (self.tableView.contentOffset.y < 88.0) {
            [self handleFetchingMoreTrigger];
        }
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self handleFetchingMoreTrigger];
}

- (void)handleFetchingMoreTrigger {
    if (self.isFetchingMore) {
        [self.fetchTimer invalidate];
        self.fetchTimer = [NSTimer scheduledTimerWithTimeInterval:0.30 target:self selector:@selector(handleFetchingMoreTrigger) userInfo:nil repeats:NO];
        return;
    }
    if (self.noMoreMessages) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(PCUChatViewCanRequestPreviousMessages)]) {
        if ([self.delegate PCUChatViewCanRequestPreviousMessages]) {
            self.isFetchingMore = YES;
            [self.tableView setTableHeaderView:self.activityIndicatorView];
            [NSTimer scheduledTimerWithTimeInterval:0.3
                                             target:self
                                           selector:@selector(doFetchingMore)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}

- (void)doFetchingMore {
    if ([self.delegate respondsToSelector:@selector(PCUChatViewRequestPreviousMessages:)]) {
        self.tableView.automaticallyAdjustsContentOffset = YES;
        self.disableAutoScroll = YES;
        [self.delegate PCUChatViewRequestPreviousMessages:^(BOOL noMore) {
            if (noMore) {
                self.noMoreMessages = YES;
                [self removeTableViewHeader];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.tableView.automaticallyAdjustsContentOffset = NO;
                self.disableAutoScroll = NO;
                self.isFetchingMore = NO;
            });
        }];
    }
}

- (void)removeTableViewHeader {
    [UIView animateWithDuration:0.15 animations:^{
        [self.tableView setTableHeaderView:nil];
    }];
}

#pragma mark - Getter

- (ASTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[PCUTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
    }
    return _tableView;
}

- (ASTableView *)slideUpTableView {
    if (_slideUpTableView == nil) {
        _slideUpTableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
        _slideUpTableView.alpha = 0.0;
        _slideUpTableView.scrollsToTop = NO;
        _slideUpTableView.scrollEnabled = NO;
        _slideUpTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _slideUpTableView.asyncDataSource = self;
        _slideUpTableView.asyncDelegate = self;
        _slideUpTableView.backgroundColor = [UIColor clearColor];
    }
    return _slideUpTableView;
}

- (UIView *)activityIndicatorView {
    if (_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44.0)];
        _activityIndicatorView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [aiView startAnimating];
        [aiView setCenter:_activityIndicatorView.center];
        [_activityIndicatorView addSubview:aiView];
    }
    return _activityIndicatorView;
}

- (NSArray<PCUMessageEntity *> *)selectedItems {
    if (_selectedItems == nil) {
        _selectedItems = @[];
    }
    return _selectedItems;
}

@end

@interface ASTableView (PCUTableView)

- (NSArray *)rangeControllerVisibleNodeIndexPaths:(ASRangeController *)rangeController;

@end

@implementation PCUTableView

- (NSArray *)rangeControllerVisibleNodeIndexPaths:(ASRangeController *)rangeController {
    NSArray *indexPaths = [super rangeControllerVisibleNodeIndexPaths:rangeController];
    if ([indexPaths count] > 0) {
        NSMutableArray *mutableIndexPaths = [indexPaths mutableCopy];
        NSIndexPath *lastIndexPath = [mutableIndexPaths lastObject];
        if (lastIndexPath.row + 1 < [self numberOfRowsInSection:0]) {
            NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row + 1 inSection:0];
            [mutableIndexPaths addObject:addIndexPath];
        }
        if (lastIndexPath.row + 2 < [self numberOfRowsInSection:0]) {
            NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row + 2 inSection:0];
            [mutableIndexPaths addObject:addIndexPath];
        }
        if (lastIndexPath.row + 3 < [self numberOfRowsInSection:0]) {
            NSIndexPath *addIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row + 3 inSection:0];
            [mutableIndexPaths addObject:addIndexPath];
        }
        indexPaths = [mutableIndexPaths copy];
    }
    return indexPaths;
}

@end
