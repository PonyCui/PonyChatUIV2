//
//  PCUSlideUpCell.h
//  xiaoquan
//
//  Created by 崔 明辉 on 15/9/6.
//  Copyright (c) 2015年 Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@class PCUSlideUpItemInteractor;

@protocol PCUSlideUpCellDelegate <NSObject>

- (void)slideUpCellTapped:(PCUSlideUpItemInteractor *)itemInteractor;

@end

@interface PCUSlideUpCell : ASCellNode

@property (nonatomic, weak) id<PCUSlideUpCellDelegate> delegate;

- (void)updateWithItemInteractor:(PCUSlideUpItemInteractor *)itemInteractor;

@end
