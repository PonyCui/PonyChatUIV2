//
//  PCUMainViewController+PCUSlideUp.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/11.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUCore.h"
#import "PCUMainViewController.h"
#import "PCUSlideUpCell.h"

@class ASCellNode;

@interface PCUMainViewController (PCUSlideUp)<PCUSlideUpCellDelegate>

- (void)reloadSlideUpData;

- (void)deleteSlideUpDataWithRow:(NSUInteger)row;

- (void)su_tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath;

- (ASCellNode *)su_tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
