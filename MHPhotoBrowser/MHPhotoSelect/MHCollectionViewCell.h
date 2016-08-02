//
//  MHCollectionViewCell.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/28.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHCollectionViewCell : UICollectionViewCell
@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,retain)UIButton *selectBtn;

-(void)loadCellFrame;
@end
