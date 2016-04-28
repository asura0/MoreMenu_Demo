//
//  SegmentButton.m
//  MoreMenu
//
//  Created by 123 on 16/4/27.
//  Copyright © 2016年 asura. All rights reserved.
//

#import "SegmentButton.h"

@interface SegmentButton ()

@property (nonatomic, assign) CornerMarkLocationType cornerMarkLocationType;


@end

@implementation SegmentButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame With:(CornerMarkLocationType)cornerMarkLocationType{
    self = [SegmentButton buttonWithType:UIButtonTypeCustom];
    self.frame = frame;
    self.cornerMarkLocationType = cornerMarkLocationType;
    self.imgView = [[UIImageView alloc]init];
    [self drawBezierPath];
    [self addSubview:self.imgView];
    return self;
}

//画线
- (void)drawBezierPath{
    
    CGFloat button_width = self.frame.size.width;
    CGFloat button_height = CGRectGetHeight(self.frame);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    CGPoint pointOne = CGPointMake(0, button_height / 4);
    CGPoint pointSecond = CGPointMake(0, button_height * 3 / 4);
    [bezierPath moveToPoint:pointOne];
    [bezierPath addLineToPoint:pointSecond];

    [bezierPath closePath];
    
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    
    self.shaperLayer = [CAShapeLayer layer];
    self.shaperLayer.frame = CGRectMake(button_width - 1, 0, 1, button_height);
    self.shaperLayer.path = bezierPath.CGPath;
    self.shaperLayer.lineWidth = 0.4;
    self.shaperLayer.strokeColor = [UIColor magentaColor].CGColor;
    [self.layer addSublayer:self.shaperLayer];
}

//重新布局子势图
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat button_width = self.frame.size.width;
    CGFloat button_height = CGRectGetHeight(self.frame);
    
    CGFloat imageView_width = button_width / 7;
    
    //创建图标.三种样式.(左.中.右)
    if (self.cornerMarkLocationType == CornerMarkLocationTypeLeft) {
        
        self.imgView.frame = CGRectMake(3 , 0, imageView_width, imageView_width / 2);
        self.titleLabel.frame = CGRectMake(3 + imageView_width, 0, button_width - imageView_width- 3 - 1, button_height);
        
    }else if (self.cornerMarkLocationType == CornerMarkLocationTypeRight){
        
        self.imgView.frame = CGRectMake(button_width * 6 / 7 - 3 - 1, 0, imageView_width, imageView_width / 2);
        self.titleLabel.frame = CGRectMake(0 , 0, button_width - (button_width / 7 + 3 + 1), button_height);
    }else if (self.cornerMarkLocationType == CornerMarkLocationTypeNone){
        
        self.imgView.frame = CGRectZero;
        self.titleLabel.frame = CGRectMake(0, 0, button_width - 1, button_height);
    }
    CGPoint imageViewCenter = self.imgView.center;
    imageViewCenter.y = button_height / 2;
    self.imgView.center = imageViewCenter;
    self.imgView.image = [UIImage imageNamed:@"箭头向上"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
