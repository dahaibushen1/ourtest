//
//  MyCollectionReusableView.m
//  二次Collection练习
//
//  Created by hu on 16/6/3.
//  Copyright © 2016年 hu. All rights reserved.
//

#import "MyCollectionReusableView.h"
#import "PureLayout.h"

@interface MyCollectionReusableView ()

@property (nonatomic,strong)UILabel *label;

@end

@implementation MyCollectionReusableView

-(UILabel*)label{


    if (!_label) {
        _label = [UILabel newAutoLayoutView];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

-(id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        [self.label autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return self;
}
-(void)resettitle{

    self.label.text = @"小操作";
}

@end
