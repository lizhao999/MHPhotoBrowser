//
//  MHPhotoSelectModel.h
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/27.
//  Copyright © 2016年 Mmt. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
@interface MHPhotoSelectModel : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, copy) NSString *localIdentifier;

@end
