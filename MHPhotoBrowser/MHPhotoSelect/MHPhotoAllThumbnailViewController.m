//
//  MHPhotoAllThumbnailViewController.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/29.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHPhotoAllThumbnailViewController.h"
#import "MHPhotoSelectConfig.h"
#import "MHCollectionViewCell.h"
#import "MHPhotoSelectModel.h"
#import "MHPhotoTool.h"
#import <Photos/Photos.h>
#import "MHPhotoBrowserViewController.h"

@interface MHPhotoAllThumbnailViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSMutableArray<PHAsset *> *_arrayDataSources;
    UIView *bottomView;
    ///预览
    UIButton *preViewBtn;
    ///原图
    UIButton *originalPhotoBtn;
    ///图片大小
    UILabel *photosBytesLab;
    ///确定
    
    UIButton *doneBtn;
    BOOL _isLayoutOK;

}

@end

@implementation MHPhotoAllThumbnailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _arrayDataSources = [NSMutableArray arrayWithArray:[[MHPhotoTool shared] getAssetsInAssetCollection:self.photoAblumList.assetCollection ascending:YES]];
    self.title = self.photoAblumList.title;
    [self setupCollection];
    [self initNavBtn];
    [self initBottomToolView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
//    [self.arraySelectPhotos removeAllObjects];
//    [self.arraySelectPhotos addObjectsFromArray:selectedPhotos];
    [self.collectionView reloadData];
    [self resetBottomBtnsStatus];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _isLayoutOK = YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (!_isLayoutOK) {
        if (self.collectionView.contentSize.height > self.collectionView.frame.size.height) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height-self.collectionView.frame.size.height)];
        }
    }
}
- (void)initNavBtn
{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 40, 44);
//    btn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [btn setTitle:@"取消" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    self.navigationItem.hidesBackButton = YES;
//    
//    UIImage *navBackImg = [UIImage imageNamed:kZLPhotoBrowserSrcName(@"navBackBtn.png")]?:[UIImage imageNamed:kZLPhotoBrowserFrameworkSrcName(@"navBackBtn.png")];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtn_Click)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UIImage *navBackImg = [UIImage imageNamed:kMHPhotoSrcName(@"navBackBtn.png")];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navLeftBtnClick)];
}

-(void)initBottomToolView
{
    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kViewHeight-44, kViewWidth, 44)];
    bottomView.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, 1)];
    line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [bottomView addSubview:line];
    
    preViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [preViewBtn setTitle:@"预览" forState:UIControlStateNormal];
    preViewBtn.enabled = NO;
    preViewBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [preViewBtn setTitleColor:[UIColor colorWithRed:0.2902 green:0.6431 blue:0.898 alpha:1.0] forState:UIControlStateNormal];
    preViewBtn.frame = CGRectMake(10, 7, 45, 30);
    [preViewBtn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateDisabled];
    [preViewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:preViewBtn];

    originalPhotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    originalPhotoBtn.frame = CGRectMake(60, 7, 55, 30);
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
    
    photosBytesLab = [[UILabel alloc]initWithFrame:CGRectMake(115, 7, 60, 30)];
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

- (void)resetBottomBtnsStatus
{
    if (self.arraySelectPhotos.count > 0) {
        
        preViewBtn.enabled = YES;
        originalPhotoBtn.enabled = YES;
//        originalPhotoBtn.selected = YES;
        doneBtn.enabled = YES;
        doneBtn.backgroundColor = [UIColor colorWithRed:0.2902 green:0.6431 blue:0.898 alpha:1.0];
        [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [doneBtn setTitle:[NSString stringWithFormat:@"确定(%ld)", self.arraySelectPhotos.count] forState:UIControlStateNormal];

    } else {
        preViewBtn.enabled = NO;
        originalPhotoBtn.enabled = NO;
        originalPhotoBtn.selected = NO;

        doneBtn.enabled = NO;
        doneBtn.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [doneBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [doneBtn setTitle:[NSString stringWithFormat:@"确定"] forState:UIControlStateNormal];

    }
}
#pragma mark - 预览
- (void)previewBtnClick:(UIButton *)sender
{
    NSMutableArray<PHAsset *> *arrSel = [NSMutableArray array];
    for (MHPhotoSelectModel *model in self.arraySelectPhotos) {
        [arrSel addObject:model.asset];
    }
    [self pushPhotoBrowerViewControllerWithArray:arrSel withIndex:arrSel.count-1 ];
}

#pragma mark - 原图
- (void)originalPhotoBtnClick:(UIButton *)sender
{
    self.isSelectOriginalPhoto = !sender.selected;
    [self getOriginalImageBytes];
}

- (void)doneBtnClick
{
    if (self.DoneBlock) {
        self.DoneBlock(self.arraySelectPhotos, self.isSelectOriginalPhoto);
    }
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
 }

- (void)navRightBtnClick
{
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)navLeftBtnClick
{
//    self.sender.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
//    self.sender.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupCollection
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 1.5;
    layout.minimumLineSpacing = 1.5;
    layout.itemSize = CGSizeMake((kViewWidth-15)/4, (kViewWidth-15)/4);
    layout.sectionInset = UIEdgeInsetsMake(3, 3, 3, 3);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kViewWidth, kViewHeight-44
                                                                            ) collectionViewLayout:layout];
    //    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MHCollectionViewCell class] forCellWithReuseIdentifier:@"MHCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
 
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
    MHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHCollectionViewCell" forIndexPath:indexPath];
    
    PHAsset *asset = _arrayDataSources[indexPath.row];
    weakify(self);
    cell.selectBtn.selected = NO;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
//    [self getImageWithAsset:asset completion:^(UIImage *image, NSDictionary *info) {
//        strongify(weakSelf);
//        cell.imageView.image = image;
//        for (MHPhotoSelectModel *model in strongSelf.arraySelectPhotos) {
//            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
//                cell.selectBtn.selected = YES;
//                break;
//            }
//        }
//    }];
    

    
    CGSize size = cell.frame.size;
    size.width *= 3;
    size.height *= 3;
     [[MHPhotoTool shared] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image, NSDictionary *info) {
        strongify(weakSelf);
        cell.imageView.image = image;
        for (MHPhotoSelectModel *model in strongSelf.arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                cell.selectBtn.selected = YES;
                break;
            }
        }
    }];
    
    cell.selectBtn.tag = indexPath.row;
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell loadCellFrame];
    return cell;
}


#pragma mark - UICollectionViewDelegate

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    PHAsset *asset = self.arrayDataSources[indexPath.row];
//    return [self getSizeWithAsset:asset];
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushPhotoBrowerViewControllerWithArray:_arrayDataSources withIndex:indexPath.row];
    
}

 - (void)pushPhotoBrowerViewControllerWithArray:(NSArray *)dataArray withIndex:(NSInteger)selectIndex
{
    MHPhotoBrowserViewController *svc = [[MHPhotoBrowserViewController alloc] init];
    svc.assets         =  dataArray;
    svc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
    svc.selectIndex    = selectIndex;
    svc.maxSelectCount = _maxSelectCount;
    svc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    //    svc.isPresent = NO;
    //    svc.shouldReverseAssets = NO;
    
        weakify(self);
        [svc setBackPhotos:^(NSArray<MHPhotoSelectModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
            strongify(weakSelf);
            strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
            [strongSelf.arraySelectPhotos removeAllObjects];
            [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
            [strongSelf.collectionView reloadData];
            [strongSelf getOriginalImageBytes];
            [strongSelf resetBottomBtnsStatus];
        }];
        [svc setDoneBlock:^(NSArray<MHPhotoSelectModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
            strongify(weakSelf);
            strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
            [strongSelf.arraySelectPhotos removeAllObjects];
            [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
            [strongSelf doneBtnClick];
        }];
    
    [self.navigationController pushViewController:svc animated:YES];
}


#pragma mark - 选择按钮点击方法

- (void)selectBtnClick:(UIButton *)btn
{
    if (_arraySelectPhotos.count >= self.maxSelectCount
        && btn.selected == NO) {
        //        ShowToastLong(@"最多只能选择%ld张图片", self.maxSelectCount);
        return;
    }
    
    PHAsset *asset = _arrayDataSources[btn.tag];
    
    if (!btn.selected) {
        //添加图片到选中数组
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        if (![[MHPhotoTool shared] judgeAssetisInLocalAblum:asset]) {
            //            ShowToastLong(@"该图片尚未从iCloud下载，请在系统相册中下载到本地后重新尝试，或在预览大图中加载完毕后选择");
            return;
        }
        MHPhotoSelectModel *photoModel = [[MHPhotoSelectModel alloc] init];
        photoModel.asset = asset;
        photoModel.localIdentifier = asset.localIdentifier;
        [_arraySelectPhotos addObject:photoModel];
    } else {
        for (MHPhotoSelectModel *model in _arraySelectPhotos) {
            if ([model.localIdentifier isEqualToString:asset.localIdentifier]) {
                [_arraySelectPhotos removeObject:model];
                break;
            }
        }
    }
    
    [self resetBottomBtnsStatus];
    [self getOriginalImageBytes];

    btn.selected = !btn.selected;
}

#pragma mark - 获取图片及图片尺寸的相关方法
- (CGSize)getSizeWithAsset:(PHAsset *)asset
{
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    CGFloat scale = width/height;
    
    return CGSizeMake(150*scale, 150);
}

- (void)getImageWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info))completion
{
    CGSize size = [self getSizeWithAsset:asset];
    size.width  *= 3;
    size.height *= 3;
    [[MHPhotoTool shared] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
