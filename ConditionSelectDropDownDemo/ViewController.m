//
//  ViewController.m
//  ConditionSelectDropDownDemo
//
//  Created by qzwh on 2018/6/20.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "ViewController.h"
#import "DropDownMenuView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"首页";
    self.navigationController.navigationBar.translucent = NO;
    
    NSArray *dicArr = @[
                        @{
                            @"title":@"城市",
                            @"type":@(DropDownMenuViewType_table),
                            @"isSelect":@(NO),
                            @"fileterIndex":@(0),
                            @"fileterArr":@[@"未知", @"河南", @"上海", @"重庆", @"四川", @"海南", @"河北", @"北京", @"深圳"]},
                        @{
                            @"title":@"年龄",
                            @"type":@(DropDownMenuViewType_table),
                            @"isSelect":@(NO),
                            @"fileterIndex":@(0),
                            @"fileterArr":@[@"未知", @"1~20", @"20~40", @"40~60"]},
                        @{
                            @"title":@"性别",
                            @"type":@(DropDownMenuViewType_table),
                            @"isSelect":@(NO),
                            @"fileterIndex":@(0),
                            @"fileterArr":@[@"未知", @"男", @"女"]},
                        @{
                            @"title":@"星座",
                            @"type":@(DropDownMenuViewType_collect),
                            @"isSelect":@(NO),
                            @"fileterIndex":@(0),
                            @"fileterArr":@[@"未知", @"射手座", @"巨蟹座", @"处女座", @"水瓶座", @"天秤座", @"狮子座", @"摩羯座"]}
                        ];
    NSMutableArray *modelArr = [NSMutableArray array];
    for (NSDictionary *tempDic in dicArr) {
        Model *model = [Model new];
        [model setValuesForKeysWithDictionary:tempDic];
        [modelArr addObject:model];
    }
    
    DropDownMenuView *dropDownMenuView = [[DropDownMenuView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30) modelArr:modelArr];
    [dropDownMenuView backParam:^(NSInteger selectBtnIndex, NSInteger filterIndex) {
        NSLog(@"按钮位置%ld, 查询参数位置%ld", selectBtnIndex, filterIndex);
    }];
    [self.view addSubview:dropDownMenuView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
