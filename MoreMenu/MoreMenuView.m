//
//  MoreMenuView.m
//  MoreMenu
//
//  Created by 123 on 16/4/26.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "MoreMenuView.h"
#import "SegmentButton.h"

#define kSelfCGRectGetMaxX CGRectGetMaxX(self.frame)
#define kSelfCGRectGetMaxY CGRectGetMaxY(self.frame)
#define kTableViewHeight (([UIScreen mainScreen].bounds.size.height - kSelfCGRectGetMaxY) - 49) * 3 / 4
#define kSelfBottomButtonHeight ([UIScreen mainScreen].bounds.size.height - kSelfCGRectGetMaxY) - 49
#define kAnimationDurtimer 0.5

static NSString *indefier = @"UITableViewCell";

@interface MoreMenuView () <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_segmentButtonTitle;//选择条件后,分段控件上标题
}

//标题
@property (nonatomic, strong) NSMutableArray *titles;

//表视图
@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UITableView *rightTableView;
//数据源
@property (nonatomic, strong) NSArray *datasourceOne;
@property (nonatomic, strong) NSArray *datasourceTwo;
@property (nonatomic, strong) NSArray *datasourceMain;
//底层视图
@property (nonatomic, strong) UIButton *bottomButton;
//记录几级菜单
@property (nonatomic, assign) BOOL isMoreMenu;
//没有数据的标示
@property (nonatomic, assign) BOOL notDatasource;

//当有二级菜单时,点击一级菜单的下标
@property (nonatomic, assign) NSInteger index;
//存放分段控件的数据
@property (nonatomic, strong) NSMutableArray *segmentButtons;
//记录用户点击的最后一次的惟一的一个 button
@property (nonatomic, strong) NSMutableArray *soleButtons;

@end

@implementation MoreMenuView 


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}

#pragma mark - lazyloaed
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        self.mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSelfCGRectGetMaxX, kTableViewHeight) style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        [self.bottomButton addSubview:_mainTableView];
    }
    return _mainTableView;
}

- (UITableView *)rightTableView{
    if (!_rightTableView) {
        self.rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(kSelfCGRectGetMaxX / 3, 0, kSelfCGRectGetMaxX  * 2 / 3, kTableViewHeight) style:UITableViewStylePlain];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        [self.bottomButton addSubview:_rightTableView];
    }
    return _rightTableView;
}

- (UITableView *)leftTableView{
    if (!_leftTableView) {
        self.leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSelfCGRectGetMaxX  / 3, kTableViewHeight) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        [self.bottomButton addSubview:_leftTableView];
    }
    return _leftTableView;
}

- (NSMutableArray *)segmentButtons{
    if (!_segmentButtons) {
        self.segmentButtons = [NSMutableArray array];
    }
    return _segmentButtons;
}

- (NSMutableArray *)soleButtons{
    if (!_soleButtons) {
        self.soleButtons = [NSMutableArray array];
    }
    return _soleButtons;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    self = [[MoreMenuView alloc]initWithFrame:frame];
    self.titles = [titles mutableCopy];
    self.backgroundColor = [UIColor lightGrayColor];
    return self;
}

#pragma mark -layoutSubViews
- (void)layoutSubviews{

    [super layoutSubviews];
}

#pragma mark - confgure segmenBtutton

//配置 buttons 和imageViews
- (void)didMoveToSuperview{
    
    CGFloat button_width = self.bounds.size.width / self.titles.count;
    CGFloat button_height = CGRectGetHeight(self.bounds);
    
    for (int i = 0; i < self.titles.count; i ++) {
        //创建按钮
        SegmentButton *segmentButton = [[SegmentButton alloc]initWithFrame:CGRectMake(button_width * i, 1, button_width, button_height - 2) With:self.cornerMarkLocationType];
        [self addSubview:segmentButton];
        
        [segmentButton setTitle:self.titles[i] forState:UIControlStateNormal];
        [segmentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [segmentButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [segmentButton addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
        
        segmentButton.backgroundColor = [UIColor whiteColor];
        segmentButton.tag = 100 + i;
        
        //最后一个移除掉划线
        if (i == self.titles.count - 1) {
            [segmentButton.shaperLayer removeFromSuperlayer];
        }
        
        [self.segmentButtons addObject:segmentButton];
    }
    
    //底层视图,初始化隐藏
    self.bottomButton = [[UIButton alloc]initWithFrame:CGRectMake(0, kSelfCGRectGetMaxY, kSelfCGRectGetMaxX, kSelfBottomButtonHeight)];
    [self.superview addSubview:self.bottomButton];
    [self.bottomButton addTarget:self action:@selector(dismissAllViews:) forControlEvents:UIControlEventTouchDown];
    self.bottomButton.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.2];
    self.bottomButton.hidden = YES;
}

#pragma mark - segmentAction
//点击 button
- (void)handleAction:(SegmentButton *)sender{
    
    sender.selected = !sender.selected;
    //判断点击的是哪个 button
    if (self.soleButtons.lastObject == sender && !sender.selected) {
        
        //如果是同一个按钮,则直接消失 return
        [self dismissTableViewAnimation];
        
        return;
    }else{
        
        self.bottomButton.hidden = NO;
        //改变选择状态
        for (SegmentButton *segmentButton in self.segmentButtons) {
            if (sender != segmentButton) {
                segmentButton.selected = NO;
            }
        }
    }
    
    //第一次点击.设置底层视图显示
    if (self.soleButtons.count == 0) {
        self.bottomButton.hidden = NO;
    }
    //移除掉第一个元素,保证唯一,且添加保存
    if (self.soleButtons.count > 1) {
        [self.soleButtons removeObjectAtIndex:0];
    }
    
    [self.soleButtons addObject:sender];
        switch (sender.tag) {
        case 100:
        {
            [self creatTableViewWithIndexsFist:self.indexsOneFist indexsTwo:self.indexsOneSecond sender:sender];
        }
            break;
        case 101:
        {
            [self creatTableViewWithIndexsFist:self.indexsTwoFist indexsTwo:self.indexsTwoSecond sender:sender];
        }
            break;
        case 102:
        {
            [self creatTableViewWithIndexsFist:self.indexsThirFist indexsTwo:self.indexsThirSecond sender:sender];
        }
            break;
        case 103:
        {
            [self creatTableViewWithIndexsFist:self.indexsFourFist indexsTwo:self.indexsFourSecond sender:sender];
        }
            break;
        case 104:
        {
            [self creatTableViewWithIndexsFist:self.indexsFiveFist indexsTwo:self.indexsFiveSecond sender:sender];
        }
            break;
            
        default:
            break;
    }
}

//点击消失视图事件
- (void)dismissAllViews:(UIButton *)sender{
    
    //改变所有分段控件的状态
    for (SegmentButton *segmentButton in self.segmentButtons) {
        segmentButton.selected = NO;
    }
    
    //设置视图隐藏
    [self dismissTableViewAnimation];
    
    //清空唯一标示数组
    self.soleButtons = nil;
}

//根据数据源,初始化 tableView
- (void)creatTableViewWithIndexsFist:(NSArray *)oneArray indexsTwo:(NSArray *)secondArray sender:(SegmentButton *)sender{
    if (oneArray.count != 0) {
        
        if (secondArray.count != 0) {
            //二级菜单
            self.datasourceOne = oneArray;
            self.datasourceTwo = secondArray;
            //菜单级别唯一标识
            self.isMoreMenu = YES;

            [self showTableViewAnimation:@[self.rightTableView,self.leftTableView] sender:sender];
        }else{
        //一级菜单
        self.isMoreMenu = NO;

        self.datasourceMain = oneArray;

        [self showTableViewAnimation:@[self.mainTableView] sender:sender];

        }
    }else{
        //没数据
        self.datasourceMain = @[@"无数据"];
        self.datasourceTwo = nil;
        self.datasourceOne = nil;
        //有无数据唯一标示
        self.notDatasource = YES;

        [self showTableViewAnimation:@[self.mainTableView] sender:sender];
    }
    //设置偏移量
    self.leftTableView.contentOffset = CGPointMake(0, 0);
    self.rightTableView.contentOffset = CGPointMake(0, 0);
    self.mainTableView.contentOffset = CGPointMake(0, 0);
    
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    [self.mainTableView reloadData];
}

#pragma mark - tbaleViewsStateAnimation
//对 tableView 的状态管理---显示
- (void)showTableViewAnimation:(NSArray <UITableView *>*)tableViews sender:(SegmentButton *)sender{
    
    __block CGFloat tableViewHeight = kTableViewHeight;
    __block CGFloat bottomHeight = kSelfBottomButtonHeight;
    __block CGRect  leftTableViewFrame = CGRectZero;
    __block CGRect  rightTableViewFrame = CGRectZero;
    __block CGRect  mainTableViewFrame = CGRectZero;
    __block CGRect  bottomButtonFrame = self.bottomButton.frame;

    
    for (UITableView *tableView in tableViews) {
        if (tableView == self.mainTableView) {
            
            mainTableViewFrame = self.mainTableView.frame;
            mainTableViewFrame.size.height = 0;
            self.mainTableView.frame = mainTableViewFrame;
            self.leftTableView.hidden = YES;
            self.rightTableView.hidden = YES;
            self.mainTableView.hidden = NO;
        }
        if (tableView == self.leftTableView) {
            
            leftTableViewFrame = self.leftTableView.frame;
            leftTableViewFrame.size.height = 0;
            self.leftTableView.frame = leftTableViewFrame;
            self.leftTableView.hidden = NO;
            self.rightTableView.hidden = NO;
            self.mainTableView.hidden = YES;
        }
        if (tableView == self.rightTableView) {
            
            rightTableViewFrame = self.rightTableView.frame;
            rightTableViewFrame.size.height = 0;
            self.rightTableView.frame = rightTableViewFrame;
            self.leftTableView.hidden = NO;

        }
    }
    
    //设置动画
    [UIView animateWithDuration:kAnimationDurtimer animations:^{
       
        bottomButtonFrame.size.height = bottomHeight;
        self.bottomButton.frame = bottomButtonFrame;
        
        if (!self.isMoreMenu || self.notDatasource) {
            mainTableViewFrame.size.height = tableViewHeight;
            self.mainTableView.frame = mainTableViewFrame;
            [self rotationSegmentButtonAnimation:sender show:YES];
            self.notDatasource = NO;
        }else{
            leftTableViewFrame.size.height = tableViewHeight;
            rightTableViewFrame.size.height = tableViewHeight;
            self.leftTableView.frame = leftTableViewFrame;
            self.rightTableView.frame = rightTableViewFrame;
            [self rotationSegmentButtonAnimation:sender show:YES];
        }
        
    } completion:^(BOOL finished) {

    }];
}

//对 tableView 的状态管理---消失
- (void)dismissTableViewAnimation{
    
    __block CGRect  leftTableViewFrame = self.leftTableView.frame;
    __block CGRect  rightTableViewFrame = self.rightTableView.frame;
    __block CGRect  mainTableViewFrame = self.mainTableView.frame;
    __block CGRect  bottomButtonFrame = self.bottomButton.frame;
    
    SegmentButton *segmentButton = self.soleButtons.lastObject;
    
    if (!self.isMoreMenu) {
        
        [UIView animateWithDuration:kAnimationDurtimer animations:^{
            
            mainTableViewFrame.size.height = 0;
            self.mainTableView.frame = mainTableViewFrame;
            bottomButtonFrame.size.height = 0;
            self.bottomButton.frame = bottomButtonFrame;
            [self rotationSegmentButtonAnimation:segmentButton show:NO];

        } completion:^(BOOL finished) {
            self.bottomButton.hidden = YES;
        }];
    }else{
        [UIView animateWithDuration:kAnimationDurtimer animations:^{
            
            leftTableViewFrame.size.height = 0;
            self.leftTableView.frame = leftTableViewFrame;
            rightTableViewFrame.size.height = 0;
            self.rightTableView.frame = rightTableViewFrame;
            bottomButtonFrame.size.height = 0;
            self.bottomButton.frame = bottomButtonFrame;
            [self rotationSegmentButtonAnimation:segmentButton show:NO];
            
        } completion:^(BOOL finished) {
            self.bottomButton.hidden = YES;
        }];
    }
}

//三角图片动画
- (void)rotationSegmentButtonAnimation:(SegmentButton *)sender show:(BOOL)show{
  
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    //判断是显示还是消失
    if (show) {
        //如果不是点击的上个按钮,那就先将上个恢复
        if (sender != self.soleButtons.firstObject) {
            basicAnimation.fromValue = [NSNumber numberWithFloat:M_PI];
            basicAnimation.toValue = @0;
            basicAnimation.duration = kAnimationDurtimer;
            basicAnimation.repeatCount = 1;
            basicAnimation.removedOnCompletion = NO;
            basicAnimation.fillMode = kCAFillModeForwards;
            SegmentButton *sender = self.soleButtons.firstObject;
            [sender.imgView.layer addAnimation:basicAnimation forKey:@"rotation_"];
        }
            //正转
        basicAnimation.fromValue = @0;
        basicAnimation.toValue = [NSNumber numberWithFloat:M_PI];
        
        _segmentButtonTitle = nil;
        
    }else{
        //反转
        basicAnimation.fromValue = [NSNumber numberWithFloat:M_PI];
        basicAnimation.toValue = @0;
    }
    
    basicAnimation.duration = kAnimationDurtimer;
    basicAnimation.repeatCount = 1;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [sender.imgView.layer addAnimation:basicAnimation forKey:@"rotation"];
    
    //按钮赋值
    if (_segmentButtonTitle == nil || [_segmentButtonTitle isEqualToString:@"无数据"]) {
        return;
    }
    [sender setTitle:_segmentButtonTitle forState:UIControlStateNormal];
}

#pragma mark -UITableView delegate && datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.mainTableView) {
        //一级菜单
        return self.datasourceMain.count;
    }else if (tableView == self.leftTableView) {
        return self.datasourceOne.count;
    }
    return [self.datasourceTwo[self.index] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefier];
    }
    NSString *string;
    if (tableView == self.mainTableView) {
        //一级菜单
        string = self.datasourceMain[indexPath.row];
    }else if (tableView == self.leftTableView) {
        string = self.datasourceOne[indexPath.row];
    }else{
        string = self.datasourceTwo[self.index][indexPath.row];
    }
    
    cell.textLabel.text = string;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (self.rightTableView == tableView) {
        cell.backgroundColor = [UIColor colorWithRed:0.925 green:0.925 blue:0.925 alpha:1];
    }
        return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *string;
    if (tableView == self.mainTableView) {
        //一级菜单.点击完后直接回调
        string = self.datasourceMain[indexPath.row];
        self.selectedIndex ? self.selectedIndex(string) : nil;
        _segmentButtonTitle = string;

        //初始化下标
        _index = 0;
        [self dismissAllViews:nil];

    }else if (tableView == self.leftTableView){
        
        //记录一级菜单点击下标,刷新二级菜单
        self.index = indexPath.row;
        [self.rightTableView reloadData];
        
    }else if (tableView == self.rightTableView){
        
        //拼接两级的数据,回调
        string = [NSString stringWithFormat:@"%@%@",self.datasourceOne[_index],self.datasourceTwo[self.index][indexPath.row]];
        self.selectedIndex ? self.selectedIndex(string) : nil;
        _segmentButtonTitle = string;

        //初始化下标
        _index = 0;
        [self dismissAllViews:nil];

    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    __block CGRect cellFrame = cell.frame;
    CGFloat cellOrigin = cellFrame.origin.y;
    cellFrame.origin.y = 0;
    cell.frame = cellFrame;
    [UIView animateWithDuration:kAnimationDurtimer animations:^{
        cellFrame.origin.y = cellOrigin;
        cell.frame = cellFrame;
    } completion:^(BOOL finished) {
    }];
}

@end
