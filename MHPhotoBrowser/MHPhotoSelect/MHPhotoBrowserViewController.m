//
//  MHPhotoBrowserViewController.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/29.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHPhotoBrowserViewController.h"
#import "MHPhotoBrowserImgCell.h"
#import <Photos/Photos.h>
#import "MHPhotoSelectConfig.h"
#import "MHPhotoSelectModel.h"
#import "MHPhotoTool.h"
#define kScreenWidth      [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight     [[UIScreen mainScreen] bounds].size.height

@interface MHPhotoBrowserViewController ()<UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSInteger _currentPage;
    NSMutableArray<PHAsset *> *_arrayDataSources;
    UIButton *_navRightBtn;
    
    UIView *bottomView;
  
    ///原图
    UIButton *originalPhotoBtn;
    ///图片大小
    UILabel *photosBytesLab;

    ///确定
     UIButton *doneBtn;

}
@property (nonatomic, retain)  UICollectionView *collectionView;


@end

@implementation MHPhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _arrayDataSources = [NSMutableArray array];
    
//    [_arrayDataSources addObjectsFromArray:self.assets];

    [self initNavBtns];
    [self initCollectionView];
    [self sortAsset];
    [self initBottomToolView];

    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_collectionView setContentOffset:CGPointMake(self.selectIndex*(kScreenWidth+30), 0)];

    if (self.shouldReverseAssets) {
        [_collectionView setContentOffset:CGPointMake((self.assets.count-self.selectIndex-1)*(kViewWidth+30), 0)];
    } else {
        [_collectionView setContentOffset:CGPointMake(self.selectIndex*(kScreenWidth+30), 0)];
    }
    [self changeNavRightBtnStatus];
    [self resetBottomBtnsStatus];
}
- (void)initNavBtns
{
    //left nav btn
    UIImage *navBackImg = [UIImage imageNamed:kMHPhotoSrcName(@"navBackBtn.png")];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(btnBackClick)];
    
    //right nav btn
    _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navRightBtn.frame = CGRectMake(0, 0, 25, 25);
    UIImage *normalImg = [UIImage imageNamed:kMHPhotoSrcName(@"btn_circle.png")];
    UIImage *selImg = [UIImage imageNamed:kMHPhotoSrcName(@"btn_selected.png")];
    [_navRightBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [_navRightBtn setBackgroundImage:selImg forState:UIControlStateSelected];
    [_navRightBtn addTarget:self action:@selector(navRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
}


-(void)initBottomToolView
{
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kViewHeight-44, kViewWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [bottomView addSubview:line];
    
    originalPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    originalPhotoBtn.frame = CGRectMake(10, 7, 55, 30);
    [originalPhotoBtn setTitle:@"原图" forState:UIControlStateNormal];
    originalPhotoBtn.enabled = NO;
    [originalPhotoBtn setImage:[UIImage imageNamed:kMHPhotoSrcName(@"btn_original_circle.png")] forState:UIControlStateNormal];
    [originalPhotoBtn setImage:[UIImage imageNamed:kMHPhotoSrcName(@"btn_original_circle.png")] forState:UIControlStateDisabled];
    
    [originalPhotoBtn setImage:[UIImage imageNamed:kMHPhotoSrcName(@"btn_selected.png")] forState:UIControlStateSelected];
    
    originalPhotoBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [originalPhotoBtn setTitleColor:[UIColor colorWithRed:0.2902 green:0.6431 blue:0.898 alpha:1.0] forState:UIControlStateNormal];
    [originalPhotoBtn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateDisabled];
    [originalPhotoBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [originalPhotoBtn addTarget:self action:@selector(originalPhotoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:originalPhotoBtn];
    
    photosBytesLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 7, 60, 30)];
    photosBytesLab.textColor = [UIColor colorWithRed:0.2902 green:0.6431 blue:0.898 alpha:1.0];
    photosBytesLab.textAlignment = NSTextAlignmentLeft;
    photosBytesLab.font = [UIFont systemFontOfSize:15.0];
    [bottomView addSubview:photosBytesLab];

    
    doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [doneBtn setTitleColor:[UIColor colorWithRed:0.2902 green:0.6431 blue:0.898 alpha:1.0] forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(kViewWidth-70-10, 7, 70, 30);
    [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    doneBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [doneBtn addTarget:self action:@selector(doneBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:doneBtn];
    
    [self.view addSubview:bottomView];
}

#pragma mark - 原图
- (void)originalPhotoBtnClick:(UIButton *)sender
{
    self.isSelectOriginalPhoto = !sender.selected;
    originalPhotoBtn.selected = !originalPhotoBtn.selected;
    [self getOriginalImageBytes];

}

- (void)doneBtnClick
{
    if (self.DoneBlock) {
        self.DoneBlock(self.arraySelectPhotos, self.isSelectOriginalPhoto);
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - 获取原图数据大小
- (void)getOriginalImageBytes
{
    
    NSMutableArray *photoBytesArray = [NSMutableArray array];
    [self.arraySelectPhotos enumerateObjectsUsingBlock:^(MHPhotoSelectModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.asset isKindOfClass:[PHAsset class]]) {
            [photoBytesArray addObject:obj.asset];
        }
    }];
    
    weakify(self);
    if (self.isSelectOriginalPhoto && self.arraySelectPhotos.count > 0) {
        
        [[MHPhotoTool shared] getPhotosBytesWithArray:photoBytesArray completion:^(NSString *photosBytes) {
            strongify(weakSelf);
            strongSelf->photosBytesLab.text = [NSString stringWithFormat:@"(%@)", photosBytes];
        }];
        originalPhotoBtn.selected = self.isSelectOriginalPhoto;
    } else {
        originalPhotoBtn.selected = NO;
        photosBytesLab.text = nil;
    }
}

- (void)btnBackClick
{
    if (self.backPhotos) {
        self.backPhotos(self.arraySelectPhotos, self.isSelectOriginalPhoto);
    }
    if (self.navigationController.viewControllers.count>1) {
        _collectionView.backgroundColor = [UIColor clearColor];
        [self.navigationController popViewControllerAnimated:YES];

    }else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
//
//    if (self.isPresent) {
//
//    } else {
//        //由于collectionView的frame的width是大于该界面的width，所以设置这个颜色是为了pop时候隐藏collectionView的黑色背景
//        _collectionView.backgroundColor = [UIColor clearColor];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}
- (void)navRightBtnClick:(UIButton *)btn
{
    if (_arraySelectPhotos.count >= self.maxSelectCount
        && btn.selected == NO) {
//        [self getPhotosBytes];
//        ShowToastLong(@"最多只能选择%ld张图片", self.maxSelectCount);
        return;
    }
    PHAsset *asset = _arrayDataSources[_currentPage-1];
    if (![self isHaveCurrentPageImage]) {
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        
        if (![[MHPhotoTool shared] judgeAssetisInLocalAblum:asset]) {
//            ShowToastLong(@"图片加载中，请稍后");
            return;
        }
        MHPhotoSelectModel *model = [[MHPhotoSelectModel alloc] init];
        model.asset = asset;
        model.localIdentifier = asset.localIdentifier;
        [_arraySelectPhotos addObject:model];
    } else {
        [self removeCurrentPageImage];
    }
    
    
    
    btn.selected = !btn.selected;
    [self getOriginalImageBytes];
    [self resetBottomBtnsStatus];
}

- (void)resetBottomBtnsStatus
{
    if (self.arraySelectPhotos.count > 0) {
        
        originalPhotoBtn.enabled = YES;
        //        originalPhotoBtn.selected = YES;
        doneBtn.enabled = YES;
        doneBtn.backgroundColor = [UIColor colorWithRed:0.2902 green:0.6431 blue:0.898 alpha:1.0];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [doneBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", self.arraySelectPhotos.count] forState:UIControlStateNormal];
        
    } else {
        originalPhotoBtn.enabled = NO;
        originalPhotoBtn.selected = NO;
        
        doneBtn.enabled = NO;
        doneBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [doneBtn setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];
        
    }
}

#pragma mark - 更新按钮、导航条等显示状态
- (void)changeNavRightBtnStatus
{
    if ([self isHaveCurrentPageImage]) {
        _navRightBtn.selected = YES;
    } else {
        _navRightBtn.selected = NO;
    }
}

#pragma mark - 图片是否已经选择
- (BOOL)isHaveCurrentPageImage
{
    PHAsset *asset = _arrayDataSources[_currentPage-1];
    for (MHPhotoSelectModel *model in _arraySelectPhotos) {
        if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - 移除选中的图片
- (void)removeCurrentPageImage
{
    PHAsset *asset = _arrayDataSources[_currentPage-1];
    for (MHPhotoSelectModel *model in _arraySelectPhotos) {
        if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
            [_arraySelectPhotos removeObject:model];
            break;
        }
    }
}



- (void)sortAsset
{
//    _currentPage = self.selectIndex + 1;

    __block __weak typeof(self) weakSelf = self;
    
    if (self.shouldReverseAssets) {
        NSEnumerator *enumerator = [self.assets reverseObjectEnumerator];
        id obj;
        while (obj = [enumerator nextObject]) {
            [_arrayDataSources addObject:obj];
        }
        //当前页
        _currentPage = _arrayDataSources.count-self.selectIndex;
    } else {
        [_arrayDataSources addObjectsFromArray:self.assets];
        _currentPage = self.selectIndex + 1;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block __strong typeof(weakSelf) strongSelf = weakSelf;

        
//        NSEnumerator *enumerator = [self.assets reverseObjectEnumerator];
//        id obj;
//        while (obj = [enumerator nextObject]) {
//            [_arrayDataSources addObject:obj];
//        }
//        _currentPage = _arrayDataSources.count-self.selectIndex;

        //当前页
        dispatch_async(dispatch_get_main_queue(), ^{
        
            strongSelf.title = [NSString stringWithFormat:@"%ld/%ld",strongSelf->_currentPage,strongSelf->_arrayDataSources.count];

            [self.collectionView reloadData];
        });
    });


}


#pragma mark - 初始化CollectionView
- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 30;
    layout.sectionInset = UIEdgeInsetsMake(0, 30/2, 0, 30/2);
    layout.itemSize = self.view.bounds.size;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-30/2, 0, kScreenWidth+30, kScreenHeight) collectionViewLayout:layout];
    [_collectionView registerClass:[MHPhotoBrowserImgCell class] forCellWithReuseIdentifier:@"MHPhotoBrowserImgCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
}

- (void)showNavBarAndBottomView
{
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    bottomView.hidden = NO;
}

- (void)hideNavBarAndBottomView
{
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    bottomView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrayDataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHPhotoBrowserImgCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHPhotoBrowserImgCell" forIndexPath:indexPath];
    PHAsset *asset = _arrayDataSources[indexPath.row];
    
    cell.asset = asset;
    __weak typeof(self) weakSelf = self;
    cell.singleTapCallBack = ^() {
        if (weakSelf.navigationController.navigationBar.isHidden) {
            [weakSelf showNavBarAndBottomView];
        } else {
            [weakSelf hideNavBarAndBottomView];
        }
    };
    
    return cell;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        //改变导航标题
        CGFloat page = scrollView.contentOffset.x/(kScreenWidth+30);
        NSString *str = [NSString stringWithFormat:@"%.0f", page];
        _currentPage = str.integerValue + 1;
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, _arrayDataSources.count];
        [self changeNavRightBtnStatus];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
