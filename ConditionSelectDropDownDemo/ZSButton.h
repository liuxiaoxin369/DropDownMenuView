//
//  ZSButton.h
//  ZhishanFund
//
//  Created by qzwh on 2018/1/25.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮的样式
 
 - ZSButtonCustomStyleNomal: 普通样式
 - ZSButtonCustomStylePicTop: 图片在上文字在下
 - ZSButtonCustomStylePicLeft: 图片在左文字在右
 - ZSButtonCustomStylePicDown: 图片在下文字在上
 - ZSButtonCustomStylePicRight: 图片在右文字在左
 */
typedef NS_ENUM(NSUInteger, ZSButtonCustomStyle) {
    ZSButtonCustomStyleNomal = 0,
    ZSButtonCustomStylePicTop,
    ZSButtonCustomStylePicLeft,
    ZSButtonCustomStylePicDown,
    ZSButtonCustomStylePicRight,
};

@interface ZSButton : UIButton

@property (assign, nonatomic) ZSButtonCustomStyle customstyle;
@property (assign, nonatomic) CGFloat customSpace;
@property (nonatomic, assign) CGSize labelSize;
@property (nonatomic, assign) CGSize imageSize;

//动画旋转180度
- (void)imageViewAnimateRotateWithState:(BOOL)state;

@end
