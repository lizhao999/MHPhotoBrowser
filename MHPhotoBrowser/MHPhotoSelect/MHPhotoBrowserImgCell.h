//
//  MHPhotoBrpwserImgCell.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/29.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PHAsset;

@interface MHPhotoBrowserImgCell : UICollectionViewCell

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy)   void (^singleTapCallBack)();

@end
