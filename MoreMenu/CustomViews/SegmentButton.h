//
//  SegmentButton.h
//  MoreMenu
//
//  Created by 123 on 16/4/27.
//  Copyright © 2016年 asura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreMenuView.h"

@interface SegmentButton : UIButton

/** 划线的 layer **/
@property (nonatomic, strong) CAShapeLayer *shaperLayer;

/** 箭头图片 **/
@property (nonatomic, strong) UIImageView *imgView;

/**
 *  asura 2016-4-27
 *
 *  @param frame                  大小 frmae
 *  @param cornerMarkLocationType  图片的位置
 *
 *  @return SegmentButton
 */
- (instancetype)initWithFrame:(CGRect)frame With:(CornerMarkLocationType)cornerMarkLocationType;

@end
