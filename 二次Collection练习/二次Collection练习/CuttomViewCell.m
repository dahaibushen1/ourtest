//
//  CuttomViewCell.m
//  二次Collection练习
//
//  Created by hu on 16/1/18.
//  Copyright © 2016年 hu. All rights reserved.
//

#import "CuttomViewCell.h"

@implementation CuttomViewCell

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.showImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 120)];
        self.showImage.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.showImage];
        
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.showImage.frame.origin.y+self.showImage.frame.size.height+5, self.frame.size.width, self.frame.size.height - self.showImage.frame.size.height-self.showImage.frame.origin.y-5)];
        self.label.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:self.label];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
   // NSLog(@"--------: %f----: %f",rect.size.width,rect.size.height);
    
    //重新绘图（重新绘图也要快于在cell中加载图片的步伐，不然绘图慢于加载，也没什么用啊）
    [self.showImage.image drawInRect:CGRectMake(0, 0, 150, 120)];
}

@end
