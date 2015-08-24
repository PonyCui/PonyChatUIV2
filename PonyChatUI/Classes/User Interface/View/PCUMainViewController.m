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

@interface PCUMainViewController ()<ASTableViewDataSource, ASTableViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) ASTableView *tableView;

@property (nonatomic, assign) BOOL firstScrolled;

@end

@implementation PCUMainViewController

#pragma mark - Object Life Cycle

- (void)dealloc
{
    self.tableView.asyncDataSource = nil;
    self.tableView.asyncDelegate = nil;
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
    self.tableView.frame = self.view.bounds;
    self.tableView.backgroundColor = [UIColor colorWithRed:235.0/255.0
                                                     green:235.0/255.0
                                                      blue:235.0/255.0
                                                     alpha:1.0];
    [self.eventHandler updateView];
    [self.tableView setAlpha:0.0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView setAlpha:1.0];
    });
    // Do any additional setup after loading the view.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
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
    if (indexPath.row < [self.eventHandler.messageInteractor.items count]) {
        PCUMessageCell *cell = [PCUMessageCell cellForMessageInteractor:self.eventHandler.messageInteractor.items[indexPath.row]];
        cell.delegate = self.delegate;
        if ([self.delegate respondsToSelector:@selector(PCUCellShowNickname)]) {
            cell.showNickname = [self.delegate PCUCellShowNickname];
        }
        return cell;
    }
    else {
        return [PCUMessageCell cellForMessageInteractor:nil];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.eventHandler.messageInteractor.items count];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return 1;
}

- (void)tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath {
    PCUMessageCell *node = (id)[tableView nodeForRowAtIndexPath:indexPath];
    [node resume];
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)pushData {
    NSInteger lastItemIndex = [self.eventHandler.messageInteractor.items count] - 1;
    if (lastItemIndex < 0) {
        lastItemIndex = 0;
    }
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastItemIndex inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdatesAnimated:NO completion:^(BOOL completed) {
        [self autoScroll];
    }];
}

- (void)insertData {
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdatesAnimated:NO completion:^(BOOL completed) {
        if (self.tableView.contentOffset.y == self.tableView.contentSize.height - self.tableView.frame.size.height) {
            [self forceScroll];
        }
    }];
}

- (void)autoScroll {
    if (self.tableView.isTracking) {
        return;
    }
    else if (self.tableView.contentOffset.y >= self.tableView.contentSize.height - self.tableView.frame.size.height * 2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (!self.firstScrolled) {
                [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 1, 1, 1)
                                           animated:NO];
                [UIView animateWithDuration:0.15 animations:^{
                    [self.tableView setAlpha:1.0];
                }];
                self.firstScrolled = YES;
            }
            else {
                [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 1, 1, 1)
                                           animated:YES];
            }
        });
    }
}

- (void)forceScroll {
    [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height - 1, 1, 1)
                               animated:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.010 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    if (self.tableView.isTracking) {
        if (self.tableView.contentOffset.y < -22.0) {
            [self handleFetchingMoreTrigger];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y < -22.0) {
        [self handleFetchingMoreTrigger];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self handleFetchingMoreTrigger];
}

- (void)handleFetchingMoreTrigger {
    if ([self.delegate respondsToSelector:@selector(PCUChatViewRequestPreviouMessages)]) {
        self.tableView.automaticallyAdjustsContentOffset = YES;
        [self.delegate PCUChatViewRequestPreviouMessages];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.tableView.automaticallyAdjustsContentOffset = NO;
        });
    }
}

#pragma mark - Getter

- (ASTableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:NO];
        _tableView.contentInset = UIEdgeInsetsMake(8, 0, 8, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.asyncDataSource = self;
        _tableView.asyncDelegate = self;
    }
    return _tableView;
}

@end
