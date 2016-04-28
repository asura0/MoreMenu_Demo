//
//  MoreMenuView.h
//  MoreMenu
//
//  Created by 123 on 16/4/26.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CornerMarkLocationType){
    CornerMarkLocationTypeLeft = 0,
    CornerMarkLocationTypeRight = 1 << 1,
    CornerMarkLocationTypeNone = 1 << 2
};

typedef void(^handleSelectedIndex)(NSString *message);

@interface MoreMenuView : UIView

/**
 *  图片位置的枚举 (CornerMarkLocationTypeLeft,CornerMarkLocationTypeRight,CornerMarkLocationTypeNone),默认在左边
 */
@property (nonatomic, assign) CornerMarkLocationType cornerMarkLocationType;

/** 第一列第一级数据源 **/
@property (nonatomic, strong) NSArray *indexsOneFist;
/** 第一列第二级数据源 **/
@property (nonatomic, strong) NSArray *indexsOneSecond;
/** 第二列第一级数据源 **/
@property (nonatomic, strong) NSArray *indexsTwoFist;
/** 第二列第二级数据源 **/
@property (nonatomic, strong) NSArray *indexsTwoSecond;
/** 第三列第一级数据源 **/
@property (nonatomic, strong) NSArray *indexsThirFist;
/** 第三列第二级数据源 **/
@property (nonatomic, strong) NSArray *indexsThirSecond;
/** 第四列第一级数据源 **/
@property (nonatomic, strong) NSArray *indexsFourFist;
/** 第四列第二级数据源 **/
@property (nonatomic, strong) NSArray *indexsFourSecond;
/** 第五列第一级数据源 **/
@property (nonatomic, strong) NSArray *indexsFiveFist;
/** 第五列第二级数据源 **/
@property (nonatomic, strong) NSArray *indexsFiveSecond;

/** 点击回调 block **/
@property (nonatomic, copy) handleSelectedIndex selectedIndex;


/**
 *  asura 2016-4-27
 *
 *  @param frame  分段控件的大小
 *  @param titles 分段控件的标题(数组)
 *
 *  @return MoreMenuView
 */
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
