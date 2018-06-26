//
//  MyCollectionViewCell.m
//  ConditionSelectDropDownDemo
//
//  Created by qzwh on 2018/6/25.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.cellTitle];
    }
    return self;
}

- (UILabel *)cellTitle {
    if (!_cellTitle) {
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
        _cellTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _cellTitle;
}

@end
