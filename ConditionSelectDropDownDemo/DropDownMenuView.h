//
//  DropDownMenuView.h
//  ConditionSelectDropDownDemo
//
//  Created by qzwh on 2018/6/24.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DropDownMenuViewType) {
    DropDownMenuViewType_table = 0,
    DropDownMenuViewType_collect,
};

@interface DropDownMenuView : UIView

/**
 @param modelArr 参数数组
 */
- (instancetype)initWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr;

- (void)backParam:(void(^)(NSInteger selectBtnIndex, NSInteger filterIndex))block;

@end

@interface Model : NSObject
@property (nonatomic, strong) NSString *title; //分类标题
@property (nonatomic, assign) DropDownMenuViewType type; //弹出视图类型
@property (nonatomic, assign) BOOL isSelect; //当前是否被选中
@property (nonatomic, assign) NSInteger fileterIndex; //选中条件的下标 默认选中第一个
@property (nonatomic, strong) NSArray *fileterArr; //查询条件数组
@end
