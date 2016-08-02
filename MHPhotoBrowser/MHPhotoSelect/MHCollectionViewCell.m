//
//  MHCollectionViewCell.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/28.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHCollectionViewCell.h"
#import "MHPhotoSelectConfig.h"

@interface MHCollectionViewCell()
{
 }
@end
@implementation MHCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       

//        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselected"] forState:UIControlStateNormal];
//        [self.selectBtn setBackgroundImage:[UIImage imageNamed:kMHPhotoSrcName(@"btn_selected.png")] forState:UIControlStateSelected];
//        float x = self.bounds.size.width -5-25;
//        NSLog(@"%@---%.2f",NSStringFromCGRect(self.bounds),x);
//        self.selectBtn.frame = CGRectMake(x, 5, 25, 25);
    }
    return self;
}

 

//
-(UIImageView *)imageView
{
    if (!_imageView) {
        self.imageView = [[UIImageView alloc]init];
//        self.imageView.frame = self.frame;
//        self.imageView.image = [UIImage imageNamed:kMHPhotoSrcName(@"lock.png")];
        self.imageView.frame = self.bounds;
         self.imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
         self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

-(UIButton *)selectBtn
{
    if (!_selectBtn) {
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:kMHPhotoSrcName(@"btn_unselected")] forState:UIControlStateNormal];
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:kMHPhotoSrcName(@"btn_selected.png")] forState:UIControlStateSelected];

        
//        self.selectBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;

        
//        self.selectBtn.center =CGPointMake(x, y);
    }
    float x = self.bounds.size.width -5-22;

    _selectBtn.frame = CGRectMake(x, 5, 22, 22);
    return _selectBtn;
}

-(void)loadCellFrame
{
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.selectBtn];
}

@end
