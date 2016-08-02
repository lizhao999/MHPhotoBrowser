//
//  MHPhotoActionSheet.m
//  MHPhotoBrowser
//
//  Created by 李钊 on 16/7/27.
//  Copyright © 2016年 Mmt. All rights reserved.
//

#import "MHPhotoActionSheet.h"
#import <Photos/Photos.h>
#import "MHPhotoSelectConfig.h"
#import "MHCollectionViewCell.h"
#import "MHPhotoTool.h"
#import "MHPhotoAblumListViewController.h"
#import "MHPhotoBrowserViewController.h"
typedef void (^SelectPhotoHandler)(NSArray<UIImage *> *imageList, NSArray<MHPhotoSelectModel *> *selectPhotoModels);

@interface MHPhotoActionSheet () <UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>
{
    NSArray *itemArray;
    UIWindow *window;
}
@property (nonatomic, assign) BOOL animate;
/**
 *   @brief mode为 ImageList 时顶部展示图片数组
 */
@property (nonatomic, strong) NSMutableArray<PHAsset *> *arrayDataSources;

@property (nonatomic, strong) NSMutableArray<MHPhotoSelectModel *> *arraySelectPhotos;
@property (nonatomic, assign) MHPhotoActionSheetMode mode;
@property (nonatomic, copy)   SelectPhotoHandler handler;
@property (nonatomic, retain) UIView *sourceView;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UICollectionView *collectionView;
/**
 *   @brief 是否是原图 有可能不是原图iCloud
 */
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;

@end

@implementation MHPhotoActionSheet

-(void)viewDidLoad
{
    [super viewDidLoad];

}
- (void)dealloc
{
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        self.maxSelectCount = 10;
        self.maxPreviewCount = 20;
//        self.arrayDataSources  = [NSMutableArray array];
        self.arraySelectPhotos = [NSMutableArray array];
        //注册实施监听相册变化
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];

    }
    return self;
}
+ (MHPhotoActionSheet *)shared {
    static MHPhotoActionSheet *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc] init];
    });
    return share;
}

-(void)showInView:(UIView *)view animate:(BOOL)animate photoActionSheetMode:(MHPhotoActionSheetMode)mode selectedPhotoModels:(NSArray<MHPhotoSelectModel *> *)selectedPhotoModels completion:(void (^)(NSArray<UIImage *> * _Nonnull, NSArray<MHPhotoSelectModel *> * _Nonnull))completion
{
 
    self.handler = completion;
    self.sourceView = view;
    self.mode = mode;
    switch (self.mode) {
        case MHPhotoActionSheetModeNone: {
            {
                [self setupViewForModeNone];
            }
            break;
        }
        case MHPhotoActionSheetModeImageList: {
            {
                [self setupViewForModeImageList];
            }
            break;
        }
    }
    [self.arraySelectPhotos removeAllObjects];
    [self.arraySelectPhotos addObjectsFromArray:selectedPhotoModels];
}

#pragma mark - 相册变化回调
- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self loadPhotoFromAlbum];
    });
}

-(void)setupViewForModeNone
{
    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor clearColor];
//    _contentView.frame = CGRectMake(0, kViewHeight, kViewWidth, kViewHeight);
    _contentView.frame = [UIScreen mainScreen].bounds;

    [self.view addSubview:_contentView];
    
    window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];

//    [window addSubview:self.view];
//    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//        /**
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请为应用打开相机" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        */
//        itemArray = @[@"相册",@"取消"];
//
//    }else
//    {
//        
//        
//    }
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kViewHeight, kViewWidth, 150) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_contentView addSubview:self.tableView];
    
    itemArray = @[@"拍照",@"相册",@"取消"];
 

    [UIView animateWithDuration:0.35 animations:^{
        [self.tableView setFrame:CGRectMake(0, kViewHeight-150, kViewWidth, 150)];

     }];
}
-(void)setupViewForModeImageList
{


    _contentView = [[UIView alloc]init];
    _contentView.backgroundColor = [UIColor colorWithRed:0.8495 green:0.8454 blue:0.8536 alpha:0.2];
    //    _contentView.frame = CGRectMake(0, kViewHeight, kViewWidth, kViewHeight);
    _contentView.frame = [UIScreen mainScreen].bounds;
    
    [self.view addSubview:_contentView];
    
    window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    

    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 3;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kViewHeight, kViewWidth, 155) collectionViewLayout:layout];
//    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MHCollectionViewCell class] forCellWithReuseIdentifier:@"MHCollectionViewCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [_contentView addSubview:self.collectionView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kViewHeight+155, kViewWidth, 150) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [_contentView addSubview:self.tableView];
    
    itemArray = @[@"拍照",@"相册",@"取消"];
    
    [self loadPhotoFromAlbum];

    
    [UIView animateWithDuration:0.35 animations:^{
        [self.collectionView setFrame:CGRectMake(0, kViewHeight - 150-155, kViewWidth, 155)];
        [self.tableView setFrame:CGRectMake(0, kViewHeight-150, kViewWidth, 150)];
    }];
}

//-(NSMutableArray<PHAsset *> *)arrayDataSources
//{
//    if (!_arrayDataSources) {
//        self.arrayDataSources = [NSMutableArray array];
//    }
//    self.arrayDataSources =  [NSMutableArray arrayWithArray:[[MHPhotoTool shared] getAllAssetInPhotoAblumWithAscending:NO]];
//    return _arrayDataSources;
//}
- (void)loadPhotoFromAlbum
{
    [self.arrayDataSources removeAllObjects];
    
    self.arrayDataSources =  [NSMutableArray arrayWithArray:[[MHPhotoTool shared] getAllAssetInPhotoAblumWithAscending:NO]];
    [self.collectionView reloadData];
}

#pragma mark -dataSouce
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 190;
//}

#pragma mark -delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat{
    return 50;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor whiteColor];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UIView *line = [UIView new];
    line.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    line.frame = CGRectMake(0, 0, tableView.bounds.size.width, 1);
    [cell addSubview:line];
    
    cell.textLabel.text = itemArray[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    cell.textLabel.textColor = [UIColor colorWithRed:0.0839 green:0.0839 blue:0.0839 alpha:1.0];

    if (![cell.textLabel.text isEqualToString:@"拍照"]&& indexPath.row==0) {
        cell.textLabel.textColor = [UIColor colorWithRed:0.2684 green:0.6021 blue:0.8737 alpha:1.0];

    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"拍照"]) {
            [self cameraClick];
        }else
        {
            [self confirmSelectPhotos];
        }
        
//
//        if (_isChosePhotoFromHeaderScrollView) {
//            if ([self.delegate respondsToSelector:@selector(CocoaPickerViewSendBackWithImage:andString:)]) {
//                [self.delegate CocoaPickerViewSendBackWithImage:_imageArray andString:@"选择的照片"];
//            }
//            [self dismiss];
//            
//        }
//        else {
//            [self tackPhotoOrChoseFromLib:indexPath.row];
//        }
    }
    else if (indexPath.row == 1){
         [self photoLibraryClick];
    }
    else if (indexPath.row == 2){
        [self dismiss];
        [self.arraySelectPhotos removeAllObjects];

    }
}

- (void)confirmSelectPhotos
{
    weakify(self);
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:self.arraySelectPhotos.count];
    for (int i = 0; i < self.arraySelectPhotos.count; i++) {
        [photos addObject:@""];
    }
    
    CGFloat scale = self.isSelectOriginalPhoto?1:[UIScreen mainScreen].scale;
    for (int i = 0; i < self.arraySelectPhotos.count; i++) {
        MHPhotoSelectModel *model = self.arraySelectPhotos[i];
        [[MHPhotoTool shared] requestImageForAsset:model.asset scale:scale resizeMode:PHImageRequestOptionsResizeModeExact completion:^(UIImage *image) {
            strongify(weakSelf);
            if (image) [photos replaceObjectAtIndex:i withObject:[self scaleImage:image]];
            
            for (id obj in photos) {
                if ([obj isKindOfClass:[NSString class]])
                    return;
            }
            if (self.handler) {
                strongSelf.handler(photos, self.arraySelectPhotos.copy);
             }
            [strongSelf dismiss];
         }];
    }
}

- (void)cameraClick
{
    
    if (![MHPhotoTool judgeIsHaveCameraAuthority]) {
            [self showAlertWithTitle:@"无法使用相机" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];
        //            [self hide];
        return;
    }
    //拍照
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        picker.videoQuality = UIImagePickerControllerQualityTypeLow;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

         }];
    }
    
}

- (void)photoLibraryClick
{
    if (![MHPhotoTool judgeIsHavePhotoAblumAuthority]) {
        //无相册访问权限
        [self showAlertWithTitle:@"无相册访问权限" message:@"请在iPhone的\"设置-隐私-相机\"中允许访问相机"];

//        ZLNoAuthorityViewController *nvc = [[ZLNoAuthorityViewController alloc] initWithNibName:@"ZLNoAuthorityViewController" bundle:kZLPhotoBrowserBundle];
//        [self presentVC:nvc];
    } else {
        self.animate = NO;
        
        MHPhotoAblumListViewController *photoBrowser = [[MHPhotoAblumListViewController alloc] init];
        photoBrowser.maxSelectCount = self.maxSelectCount;
        photoBrowser.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:photoBrowser];
        weakify(self);
//        __weak typeof(photoBrowser) weakPB = photoBrowser;

        [photoBrowser setDoneBlock:^(NSArray<MHPhotoSelectModel *> *selPhotoModels, BOOL isSelectOriginalPhoto) {
            strongify(weakSelf);
//            __strong typeof(weakPB) strongPB = weakPB;
            strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
            [strongSelf.arraySelectPhotos removeAllObjects];
            [strongSelf.arraySelectPhotos addObjectsFromArray:selPhotoModels];
            strongSelf.arraySelectPhotos = [NSMutableArray arrayWithArray:selPhotoModels];
            [strongSelf confirmSelectPhotos];
        }];
        
        [photoBrowser setCancelBlock:^{
            strongify(weakSelf);
            [strongSelf dismiss];
        }];
        
//        nav.navigationBar.translucent = YES;
//
//        [nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
//        [nav.navigationBar setBackgroundImage:[self imageWithColor:kRGB(19, 153, 231)] forBarMetrics:UIBarMetricsDefault];
//        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        [self presentViewController:nav animated:YES completion:nil];
        
//        
//        ZLPhotoBrowser *photoBrowser = [[ZLPhotoBrowser alloc] initWithStyle:UITableViewStylePlain];
//        photoBrowser.maxSelectCount = self.maxSelectCount;
//        photoBrowser.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
//        
//        weakify(self);
//        __weak typeof(photoBrowser) weakPB = photoBrowser;
//        [photoBrowser setDoneBlock:^(NSArray<ZLSelectPhotoModel *> *selPhotoModels, BOOL isSelectOriginalPhoto) {
//            strongify(weakSelf);
//            __strong typeof(weakPB) strongPB = weakPB;
//            strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
//            [strongSelf.arraySelectPhotos removeAllObjects];
//            [strongSelf.arraySelectPhotos addObjectsFromArray:selPhotoModels];
//            [strongSelf requestSelPhotos:strongPB];
//        }];
//        
//        [photoBrowser setCancelBlock:^{
//            strongify(weakSelf);
//            [strongSelf hide];
//        }];
//        
//        [self presentVC:photoBrowser];
    }
}




#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.maxPreviewCount>_arrayDataSources.count?_arrayDataSources.count:self.maxPreviewCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MHCollectionViewCell" forIndexPath:indexPath];
    
    PHAsset *asset = _arrayDataSources[indexPath.row];
    weakify(self);
    cell.selectBtn.selected = NO;

    [self getImageWithAsset:asset completion:^(UIImage *image, NSDictionary *info) {
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
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.arrayDataSources[indexPath.row];
    return [self getSizeWithAsset:asset];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MHCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    MHPhotoBrowserViewController *svc = [[MHPhotoBrowserViewController alloc] init];
    svc.assets         =  _arrayDataSources;
    svc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
    svc.selectIndex    = indexPath.row;
    svc.maxSelectCount = _maxSelectCount;
    svc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
    //    svc.isPresent = NO;
    svc.shouldReverseAssets = YES;
    
    weakify(self);
     __weak typeof(svc) weakSvc  = svc;

    [svc setBackPhotos:^(NSArray<MHPhotoSelectModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf changeTableViewTitle];
        [strongSelf.collectionView reloadData];
        
    }];
    [svc setDoneBlock:^(NSArray<MHPhotoSelectModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
//        __strong typeof(weakSvc) strongSvc = weakSvc;
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf confirmSelectPhotos];
        
    }];
  
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:svc];
        nav.navigationBar.translucent = YES;
        [self presentViewController:nav animated:YES completion:nil];
    
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

        strongify(weakSelf);
        if (strongSelf.handler) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
//            ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
//            [hud show];
            
            [[MHPhotoTool shared] saveImageToAblum:image completion:^(BOOL suc, PHAsset *asset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (suc) {
                        MHPhotoSelectModel *model = [[MHPhotoSelectModel alloc] init];
                        model.asset = asset;
                        model.localIdentifier = asset.localIdentifier;
                        strongSelf.handler(@[[strongSelf scaleImage:image]], @[model]);
                    } else {
//                        ShowToastLong(@"保存图片到相册失败");
                    }
                    
//                    [hud hide];
                    [strongSelf dismiss];
                });
            }];
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
//    weakify(self);
    [picker dismissViewControllerAnimated:YES completion:^{
//        strongify(weakSelf);
//        [strongSelf hide];
    }];
}


#pragma mark - 这里对拿到的图片进行缩放，不然原图直接返回的话会造成内存暴涨
 
- (UIImage *)scaleImage:(UIImage *)image
{
    CGSize size = CGSizeMake(1000, 1000 * image.size.height / image.size.width);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    
    btn.selected = !btn.selected;
    [self changeTableViewTitle];
 }

- (void)changeTableViewTitle
{
    if (self.arraySelectPhotos.count > 0) {
        itemArray = @[[NSString stringWithFormat:@"确定(%ld)", self.arraySelectPhotos.count],@"相册",@"取消"];

     } else {
        itemArray = @[@"拍照",@"相册",@"取消"];
     }
    [self.tableView reloadData];
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
    size.width  *= 1.5;
    size.height *= 1.5;
    [[MHPhotoTool shared] requestImageForAsset:asset size:size resizeMode:PHImageRequestOptionsResizeModeFast completion:completion];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self dismiss];
}

-(void)dismiss
{
//    weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
//        [weakSelf dismissViewControllerAnimated:YES completion:^{
//            
//        }];
        [UIView animateWithDuration:0.15 animations:^{
            [self.tableView setFrame:CGRectMake(0, kViewHeight+155, kViewWidth, 150)];
            [self.collectionView setFrame:CGRectMake(0, kViewHeight, kViewHeight, 155)];
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            [self.contentView removeFromSuperview];
            [self.tableView removeFromSuperview];
            [self.collectionView removeFromSuperview];
        }];
     
    });
}

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
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
     }];
    [svc setDoneBlock:^(NSArray<MHPhotoSelectModel *> *selectedPhotos, BOOL isSelectOriginalPhoto) {
        strongify(weakSelf);
        strongSelf.isSelectOriginalPhoto = isSelectOriginalPhoto;
        [strongSelf.arraySelectPhotos removeAllObjects];
        [strongSelf.arraySelectPhotos addObjectsFromArray:selectedPhotos];
        [strongSelf.collectionView reloadData];

    }];
    
    [self.navigationController pushViewController:svc animated:YES];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)prefersStatusBarHidden
{
    return true;
}
@end
