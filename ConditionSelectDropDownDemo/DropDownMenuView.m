//
//  DropDownMenuView.m
//  ConditionSelectDropDownDemo
//
//  Created by qzwh on 2018/6/24.
//  Copyright © 2018年 qzwh. All rights reserved.
//

#import "DropDownMenuView.h"
#import "ZSButton.h"
#import "MyCollectionViewCell.h"

#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define kIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kHeight_StatusBar       kIsiPhoneX?44.0f:20.0f
#define kHeight_NavBar          kIsiPhoneX?88.0f:64.0f
#define kHeight_TabBar          kIsiPhoneX?83.0f:49.0f

#define kSpace                          5       //collectioncell之间的间隔
#define kCollectionCellHeight           30      //collectioncell的高度
#define kCollectionCellCountForRow      4       //collection每行显示多少个cell

#define idenfier    @"idenfierCell"

@interface DropDownMenuView ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *modelArr;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectBtnIndex; //-1表示当前没有选中的条件
@property (nonatomic, copy) void(^backParamBlock)(NSInteger selectBtnIndex, NSInteger filterIndex);
@end

@implementation DropDownMenuView

- (instancetype)initWithFrame:(CGRect)frame modelArr:(NSArray *)modelArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.modelArr = modelArr;
        //创建控件
        [self createUI];
        self.selectBtnIndex = -1;
    }
    return self;
}

- (void)createUI {
    CGFloat x = 0;
    CGFloat width = self.frame.size.width/self.modelArr.count;
    for (int i = 0; i < self.modelArr.count; i++) {
        Model *model = self.modelArr[i];
        
        ZSButton *btn = [ZSButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, 0, width, self.frame.size.height);
        [btn setTitle:model.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"pullDownImage"] forState:UIControlStateNormal];
        btn.imageSize = CGSizeMake(10, 8);
        btn.customSpace = 4;
        btn.customstyle = ZSButtonCustomStylePicRight;
        btn.tag = 100 + i;
        [btn addTarget:self action:@selector(handleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        x += width;
        
        if (i != self.modelArr.count - 1) {
            UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 0.5, self.frame.size.height)];
            sepLine.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:sepLine];
        }
    }
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width, 0.5)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
}

- (void)handleBtnAction:(ZSButton *)sender {
    NSInteger index = sender.tag - 100;
    Model *model = self.modelArr[index];
    //当前tableView已经出现的时候   点击其他的条件选择按钮没有效果
    for (Model *tempModel in self.modelArr) {
        if (tempModel.isSelect && index != self.selectBtnIndex) {
            return;
        }
    }
    
    if (!sender.selected) { //按钮选中
        self.selectBtnIndex = index;
        [sender setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        
        if (model.type == DropDownMenuViewType_table) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.tableView.frame;
                frame.size.height = (kScreenHeight)-(kHeight_NavBar)-self.frame.size.height;
                self.tableView.frame = frame;
            }];
            [self.tableView reloadData];
        } else {
            NSInteger row = (model.fileterArr.count%kCollectionCellCountForRow)?((model.fileterArr.count/kCollectionCellCountForRow)+1):(model.fileterArr.count/kCollectionCellCountForRow);
            CGFloat collectionViewHeight = (row+1)*kSpace+(row*kCollectionCellHeight);
            self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, collectionViewHeight);
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.contentView.frame;
                frame.size.height = (kScreenHeight)-(kHeight_NavBar)-self.frame.size.height;
                self.contentView.frame = frame;
            }];
            [self.collectionView reloadData];
        }
    } else { //按钮未选中
        self.selectBtnIndex = -1;
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sender setTitle:model.fileterIndex?model.fileterArr[model.fileterIndex]:model.title forState:UIControlStateNormal];
        
        if (model.type == DropDownMenuViewType_table) {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.tableView.frame;
                frame.size.height = 0;
                self.tableView.frame = frame;
            } completion:^(BOOL finished) {
                [self.tableView removeFromSuperview];
                self.tableView = nil;
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                CGRect frame = self.contentView.frame;
                frame.size.height = 0;
                self.contentView.frame = frame;
            } completion:^(BOOL finished) {
                [self.contentView removeFromSuperview];
                self.contentView = nil;
                self.collectionView = nil;
            }];
        }
    }
    
    sender.selected = !sender.selected;
    model.isSelect = sender.selected;
    [sender imageViewAnimateRotateWithState:sender.selected];
}

- (void)handleTapAction:(UIGestureRecognizer *)gesture {
    ZSButton *btn = (ZSButton *)[self viewWithTag:100+self.selectBtnIndex];
    [self handleBtnAction:btn];
}

- (void)backParam:(void(^)(NSInteger selectBtnIndex, NSInteger filterIndex))block {
    self.backParamBlock = [block copy];
}

//MARK:UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectBtnIndex == -1) {
        return 0;
    }
    Model *model = self.modelArr[self.selectBtnIndex];
    return model.fileterArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfier forIndexPath:indexPath];
    Model *model = self.modelArr[self.selectBtnIndex];
    if (model.fileterIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor orangeColor];
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", model.fileterArr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectBtnIndex != -1) {
        Model *model = self.modelArr[self.selectBtnIndex];
        
        //改变样式
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:model.fileterIndex inSection:0];
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
        oldCell.textLabel.textColor = [UIColor blackColor];
        
        UITableViewCell *currentCell = [tableView cellForRowAtIndexPath:indexPath];
        currentCell.textLabel.textColor = [UIColor orangeColor];
        
        //改变选中下标
        model.fileterIndex = indexPath.row;
        
        if (self.backParamBlock) {
            self.backParamBlock(self.selectBtnIndex, indexPath.row);
        }
        
        ZSButton *btn = (ZSButton *)[self viewWithTag:100+self.selectBtnIndex];
        [self handleBtnAction:btn];
    }
}

//MARK:UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.selectBtnIndex == -1) {
        return 0;
    }
    Model *model = self.modelArr[self.selectBtnIndex];
    return model.fileterArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenfier forIndexPath:indexPath];
    Model *model = self.modelArr[self.selectBtnIndex];
    if (model.fileterIndex == indexPath.row) {
        cell.cellTitle.textColor = [UIColor orangeColor];
    } else {
        cell.cellTitle.textColor = [UIColor blackColor];
    }
    cell.cellTitle.text = [NSString stringWithFormat:@"%@", model.fileterArr[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectBtnIndex != -1) {
        Model *model = self.modelArr[self.selectBtnIndex];
        
        //改变样式
        NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:model.fileterIndex inSection:0];
        MyCollectionViewCell *oldCell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:oldIndexPath];
        oldCell.cellTitle.textColor = [UIColor blackColor];
        
        MyCollectionViewCell *currentCell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        currentCell.cellTitle.textColor = [UIColor orangeColor];
        
        //改变选中下标
        model.fileterIndex = indexPath.row;
        
        if (self.backParamBlock) {
            self.backParamBlock(self.selectBtnIndex, indexPath.row);
        }
        
        //收回弹出视图
        ZSButton *btn = (ZSButton *)[self viewWithTag:100+self.selectBtnIndex];
        [self handleBtnAction:btn];
    }
}

//MARK:UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //获取当前手势点击的视图：他会是UITableViewCell或者UICollectionViewCell的内容视图
    //然后获取到他的父视图 可以找到你自己定义的cell类
    //通过判断类型来阻断手势触发
    if ([touch.view.superview isKindOfClass:[UITableViewCell class]] || [touch.view.superview isKindOfClass:[MyCollectionViewCell class]]) {
        return NO;
    }
    return  YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (kHeight_NavBar)+self.frame.size.height, kScreenWidth, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:idenfier];
        [[UIApplication sharedApplication].keyWindow addSubview:_tableView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [_tableView addGestureRecognizer:tap];
    }
    return _tableView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, (kHeight_NavBar)+self.frame.size.height, kScreenWidth, 0)];
        _contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:_contentView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
        tap.numberOfTapsRequired = 1;
        tap.delegate = self;
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kScreenWidth-(kCollectionCellCountForRow+1)*kSpace)/kCollectionCellCountForRow, kCollectionCellHeight);
        layout.minimumLineSpacing = kSpace;
        layout.minimumInteritemSpacing = kSpace;
        layout.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, 0, kSpace);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:idenfier];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

@end

@implementation Model
@end
