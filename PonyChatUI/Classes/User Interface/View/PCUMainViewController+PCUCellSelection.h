//
//  PCUMainViewController+PCUCellSelection.h
//  PonyChatUIV2
//
//  Created by 崔 明辉 on 15/9/11.
//  Copyright © 2015年 PonyCui. All rights reserved.
//

#import <PonyChatUI/PonyChatUI.h>

@interface PCUMainViewController (PCUCellSelection)

- (void)cs_tableView:(ASTableView *)tableView willDisplayNodeForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
