//
//  MHPhotoView.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/26.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MHPhotoDisplayDirectionVertical, //垂直展示  所有图片全部展示
    MHPhotoDisplayDirectionHorizontal //水平展示  滚动展示
} MHPhotoDisplayDirection;

#define MHPhotoImageRowNumber 3.0  //一行显示数量

//#define MHPhotoImageSize CGSizeMake(100, 100) //显示图片大小
@class MHPhotoModel;
@interface MHPhotoView : UIView

@property (nonatomic,assign)CGSize imgSize;

@property (nonatomic,assign)MHPhotoDisplayDirection photoDisplayDirection;  //default MHPhotoDisplayDirectionVertical

@property (nonatomic,retain)NSArray <MHPhotoModel *> *photoArray;

@end
