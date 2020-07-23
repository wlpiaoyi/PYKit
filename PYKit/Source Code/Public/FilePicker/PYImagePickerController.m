//
//  PYImagePickerController.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYImagePickerController.h"
#import "PYImagePickerCell.h"
#import "PYImagePickerReusableView.h"
#import "pyinterflowa.h"

@interface PYImagePickerController (){
    NSBundle * bundle;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonConfirme;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
kPNSNA NSMutableArray<PHAsset *> * selectedAssets;
kPNSNA NSMutableArray<NSDictionary *> * datas;
kPNA CGSize cellSize;
kPNA UIEdgeInsets edgeInsets;

@end

@implementation PYImagePickerController

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    bundle = [NSBundle bundleWithPath:kFORMAT(@"%@/PYKit.bundle", bundleDir)];
    bundle = [NSBundle mainBundle];
    self = [super initWithNibName:nibNameOrNil ? : @"PYImagePickerController" bundle:bundle];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.selectedAssets = [NSMutableArray new];
    self.maxSelected = self.maxSelected;
    // 获得所有的自定义相簿
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
        if(assetCollections == nil || assetCollections.count == 0){
            int count = 10;
            while (count -- > 0) {
                [NSThread sleepForTimeInterval:.5];
                assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:nil];
                if(assetCollections && assetCollections.count > 0) break;
            }
        }
        // 遍历所有的自定义相簿
        self.datas = [NSMutableArray new];
        NSMutableDictionary * recentAssetsDict;
        for (PHAssetCollection *assetCollection in assetCollections) {
            // 获得某个相簿中的所有PHAsset对象
            PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            if(assets == nil || assets.count == 0) continue;
            NSMutableDictionary * assetsDict = [NSMutableDictionary new];
            assetsDict[@"name"] = assetCollection.localizedTitle;
            assetsDict[@"datas"] = assets;
            if([assetCollection.localizedTitle isEqual:@"最近项目"]){
                recentAssetsDict = assetsDict;
                continue;
            }
            [self.datas addObject:assetsDict];
            
        }
        if(recentAssetsDict) [self.datas insertObject:recentAssetsDict atIndex:0];
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

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PYImagePickerCell * cell = (PYImagePickerCell *)[collectionView cellForItemAtIndexPath:indexPath];

    if([self.selectedAssets containsObject:cell.asset]){
        [self.selectedAssets removeObject:cell.asset];
        cell.isSelectedData = [self.selectedAssets containsObject:cell.asset];
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
    if(self.maxSelected <= 1 && self.blockSelected){
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
    return ((PHFetchResult *)self.datas[section][@"datas"]).count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PYImagePickerCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PYImagePickerCell" forIndexPath:indexPath];
    PHFetchResult<PHAsset *> * assets = (PHFetchResult<PHAsset *> *) self.datas[indexPath.section][@"datas"];
    cell.asset = [assets objectAtIndex:indexPath.row];
    cell.isSelectedData = [self.selectedAssets containsObject:cell.asset];
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind != UICollectionElementKindSectionHeader) return  nil;
    NSString * name = self.datas[indexPath.section][@"name"];
    PYImagePickerReusableView * reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PYImagePickerReusableView" forIndexPath:indexPath];
    reusableview.name = name;
    return reusableview;
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
    if(self.blockSelected) _blockSelected(self.selectedAssets);
    [self onclickDesmiss:nil];
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
