//
//  PYAssetPickerController.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYAssetPickerController.h"
#import "PYImagePickerCell.h"
#import "PYImagePickerReusableView.h"
#import "pyinterflowa.h"

@interface PYAssetPickerController (){
    NSBundle * bundle;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonConfirme;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
kPNSNA NSMutableArray<PHAsset *> * selectedAssets;
kPNSNA NSMutableArray<PHAsset *> * iCouldAssets;
kPNSNA NSMutableArray<PHAsset *> * loactionAssets;
kPNSNA NSMutableArray<NSDictionary *> * datas;
kPNA NSInteger expandSection;
kPNA CGSize cellSize;
kPNA UIEdgeInsets edgeInsets;
kPNSNA PHImageRequestOptions * requestOptionsNO;
kPNSNA PHImageRequestOptions * requestOptionsYES;

@end

@implementation PYAssetPickerController


+(instancetype) instanceVideos{
    PYAssetPickerController * vc = [PYAssetPickerController new];
    vc->_subtype = PHAssetCollectionSubtypeSmartAlbumVideos;
    return vc;
}
+(instancetype) instanceAny{
    PYAssetPickerController * vc = [PYAssetPickerController new];
    return vc;
    
}

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    bundle = [NSBundle bundleWithPath:kFORMAT(@"%@/PYKit.bundle", bundleDir)];
    self = [super initWithNibName:nibNameOrNil ? : @"PYAssetPickerController" bundle:bundle];
    self->_subtype = PHAssetCollectionSubtypeAny;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.selectedAssets = [NSMutableArray new];
    self.iCouldAssets = [NSMutableArray new];
    self.loactionAssets = [NSMutableArray new];
    self.maxSelected = self.maxSelected;
    self.expandSection = 0;
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        threadJoinMain(^{
            switch (status) {
                case PHAuthorizationStatusAuthorized:{
                    [self initImagePicker];
                }
                    break;
                case PHAuthorizationStatusDenied:{
                    UIView * alert = [UIView new];
                    [alert dialogShowWithTitle:nil message:@"没有权限读取相册,现在开启权限App可能会被强制重启,当前界面可能无法保持!" block:^(UIView * _Nonnull view, BOOL isConfirm) {
                        [view dialogHidden];
                        if(isConfirm){
                            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {}];
                            }
                        }
                        [self onclickDesmiss:nil];
                    } buttonConfirm:@"去设置" buttonCancel:@"退出"];
                    alert.dialogShowView.popupBlockTap = ^(UIView * _Nullable view) {};
                }
                    break;
                default:
                    break;
            }
        });
    }];
}

-(void) initImagePicker{
    
    // 获得所有的自定义相簿
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        options.networkAccessAllowed = NO;
        self.requestOptionsNO = options;
        options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        options.networkAccessAllowed = YES;
        self.requestOptionsYES = options;
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:_subtype options:nil];
        if(assetCollections == nil || assetCollections.count == 0){
            int count = 10;
            while (count -- > 0) {
                assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:_subtype options:nil];
                if(assetCollections && assetCollections.count > 0) break;
            }
        }
        // 遍历所有的自定义相簿
        self.datas = [NSMutableArray new];
        NSMutableDictionary * userAssetsDict;
        NSMutableDictionary * hiddenAssetsDict;
        for (PHAssetCollection *assetCollection in assetCollections) {
            // 获得某个相簿中的所有PHAsset对象
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            if(assets == nil || assets.count == 0) continue;
            NSMutableDictionary * assetsDict = [NSMutableDictionary new];
            assetsDict[@"name"] = assetCollection.localizedTitle;
            assetsDict[@"datas"] = assets;
            if(assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary){
                userAssetsDict = assetsDict;
                continue;
            }
            if(assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden){
                hiddenAssetsDict = assetsDict;
                continue;
            }
            for (PHAsset * asset in assets) {
                if(![self.iCouldAssets containsObject:asset] && ![self.loactionAssets containsObject:asset]){
                    [self.loactionAssets addObject:asset];
                }
            }
            [self.datas addObject:assetsDict];
            
        }
        if(userAssetsDict) [self.datas insertObject:userAssetsDict atIndex:0];
        if(hiddenAssetsDict) [self.datas addObject:hiddenAssetsDict];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
    [self.collectionView registerNib:[UINib nibWithNibName:@"PYImagePickerCell" bundle:bundle] forCellWithReuseIdentifier:@"PYImagePickerCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PYImagePickerReusableView" bundle:bundle] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PYImagePickerReusableView"];
    self.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    CGFloat w = boundsWidth() / 4. - 4;
    CGFloat h = w;
    self.cellSize = CGSizeMake(w, h);
    self.maxSelected = self.maxSelected;
}


-(void) viewWillDisappear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.modalPresentationStyle != UIModalPresentationPopover) return;
    [[PYUtile getCurrentController]  setNeedsStatusBarAppearanceUpdate];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(self.modalPresentationStyle != UIModalPresentationPopover) return;
    [[PYUtile getCurrentController]  setNeedsStatusBarAppearanceUpdate];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PYImagePickerCell * cell = (PYImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if([self.selectedAssets containsObject:cell.asset]){
        [self.selectedAssets removeObject:cell.asset];
        cell.isSelectedData = [self.selectedAssets containsObject:cell.asset];
        self.maxSelected = self.maxSelected;
        return;
    }
    if(self.maxSelected <= 1){
        [self.selectedAssets removeAllObjects];
        [collectionView reloadData];
    }
    if(self.selectedAssets.count >= self.maxSelected){
        [[UIView new] toastShow:3 message:kFORMAT(@"最多支持选择%ld张照片", self.maxSelected)];
        return;
    };
    [self.selectedAssets addObject:cell.asset];
    self.maxSelected = self.maxSelected;
    cell.isSelectedData = [self.selectedAssets containsObject:cell.asset];
    cell.isLoading = [self.iCouldAssets containsObject:cell.asset] && cell.isSelectedData;
    PHAsset * asset = cell.asset;
    CGSize size = CGSizeMake(boundsWidth(), boundsWidth()/asset.pixelWidth*asset.pixelHeight);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:self.requestOptionsNO resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        if(!result){
            [self.iCouldAssets addObject:asset];
        }
        cell.isSelectedData = [self.selectedAssets containsObject:cell.asset];
        cell.isLoading = [self.iCouldAssets containsObject:cell.asset] && cell.isSelectedData;
    }];
    if(self.maxSelected <= 1){
        [self onclickConfirm:nil];
    }
}


#pragma mark UICollectionViewDataSource
// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellSize;
}
 
// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.edgeInsets;
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 4;
}
 
// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return  4;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.datas.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section != self.expandSection) return 0;
    return ((PHFetchResult *)self.datas[section][@"datas"]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PYImagePickerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PYImagePickerCell" forIndexPath:indexPath];
    PHFetchResult<PHAsset *> * assets = (PHFetchResult<PHAsset *> *) self.datas[indexPath.section][@"datas"];
    cell.asset = [assets objectAtIndex:indexPath.row];
    cell.isSelectedData = [self.selectedAssets containsObject:cell.asset];
    cell.isLoading = [self.iCouldAssets containsObject:cell.asset] && cell.isSelectedData;
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind != UICollectionElementKindSectionHeader) return  nil;
    NSString * name = kFORMAT(@"%@(%ld)", self.datas[indexPath.section][@"name"], ((PHFetchResult *)self.datas[indexPath.section][@"datas"]).count);
    PYImagePickerReusableView * reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PYImagePickerReusableView" forIndexPath:indexPath];
    reusableview.name = name;
    reusableview.section = indexPath.section;
    kAssign(self);
    reusableview.blockExpand = ^BOOL(PYImagePickerReusableView * _Nonnull view) {
        kStrong(self);
        if(view.isExpand){
            self.expandSection = -1;
        }else{
            self.expandSection = view.section;
        }
        [self reloadData];
        return YES;
    };
    reusableview.isExpand = indexPath.section == self.expandSection;
    return reusableview;
}

-(void) reloadData{
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    NSArray *cells = [_collectionView.visibleCells sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        UIView * view1 = obj1;
        UIView * view2 = obj2;
        NSInteger y1 = view1.frameY;
        NSInteger y2 = view2.frameY;
        if(y1 > y2) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    CGFloat collectionHeight = _collectionView.bounds.size.height;
    NSInteger count = 0;
    NSInteger index = 0;
    for (UICollectionViewCell *cell in cells) {
        if(count == 4){
            count = 0;
            index ++;
        }
        count++;
        cell.alpha = 0.0f;
        cell.transform = CGAffineTransformMakeTranslation(0, collectionHeight);
        [UIView animateWithDuration:0.5f delay:0.06 * index usingSpringWithDamping:0.6f initialSpringVelocity:0 options:0 animations:^{
            cell.transform =  CGAffineTransformMakeTranslation(0, 0);
            cell.alpha = 1.0f;
        } completion:nil];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(collectionView.frameWidth, 34);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

-(void) setMaxSelected:(NSUInteger)maxSelected{
    _maxSelected = maxSelected;
    self.buttonConfirme.hidden = maxSelected <= 1;
    if(maxSelected > 1){
        self.labelTitle.text = kFORMAT(@"已选择(%ld/%ld)", self.selectedAssets.count, self.maxSelected);
    }else{
        self.labelTitle.text = @"请选择";
    }
}

- (IBAction)onclickDesmiss:(id)sender {
    if(self.navigationController){
        if(self.navigationController.viewControllers.firstObject == self)
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        else
            [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}
- (IBAction)onclickConfirm:(id)sender {
    BOOL hasiCloud = NO;
    if(self.iCouldAssets.count){
        for(id obj in self.selectedAssets){
            if([self.iCouldAssets containsObject:obj]){
                hasiCloud = YES;
                break;
            }
        }
    }
    kAssign(self);
    void (^blockDesmiss) (void) = ^(void){
        kStrong(self);
        [self onclickDesmiss:nil];
    };
    if(self.blockSelectedHasICloud){
         _blockSelectedHasICloud(self.selectedAssets, hasiCloud, blockDesmiss);
    }else if(self.blockSelected){
        _blockSelected(self.selectedAssets);
        blockDesmiss();
    }else{
        blockDesmiss();
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
