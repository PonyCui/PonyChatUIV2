//
//  PCUMainViewController.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/7/6.
//  Copyright (c) 2015年 PonyCui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUMainPresenter, PCUMessageEntity, ASTableView, PCUMessageManager;

@protocol PCUDelegate;

@interface PCUMainViewController : UIViewController

@property (nonatomic, weak) id<PCUDelegate> delegate;

@property (nonatomic, strong) PCUMainPresenter *eventHandler;

+ (PCUMainViewController *)mainViewControllerWithMessageManager:(PCUMessageManager *)messageManager
                                                completionBlock:(void (^)(PCUMainViewController *mainViewController))completionBlock;

- (CGSize)contentSize;

- (void)reloadData;

- (void)insertDataWithIndexes:(NSArray<NSNumber *> *)indexes;

- (void)deleteDataWithRow:(NSUInteger)row;

- (void)autoScroll;

- (void)forceScroll;

#pragma mark - Private 

#pragma mark -> PCUCellSelection

@property (nonatomic, assign) BOOL isSelecting;

@property (nonatomic, copy) NSArray<PCUMessageEntity *> *selectedItems;

@property (nonatomic, strong) UIBarButtonItem *originLeftItem;

@property (nonatomic, strong) UIBarButtonItem *originRightItem;

@property (nonatomic, copy)   NSArray *originRightItems;

#pragma mark -> PCUSlideUP

@property (nonatomic, assign) BOOL isSliding;

@property (nonatomic, strong) ASTableView *slideUpTableView;

@end
