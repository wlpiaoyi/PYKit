//
//  PYItemTapView.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/12/1.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYLongpressMoveItemView.h"
#import "PYLongpressMoveItemCell.h"
#import "pyinterflowa.h"

@interface PYItemTapTailCell : UICollectionViewCell

kPNSNA UIView * viewTail;

@end

@implementation PYItemTapTailCell


-(void) setViewTail:(UIView *)viewTail{
    if(_viewTail){
        if(_viewTail == viewTail) return;
        [_viewTail py_removeAllLayoutContarint];
        [_viewTail removeFromSuperview];
    }
    _viewTail = viewTail;
    [self.contentView addSubview:_viewTail];
    [_viewTail py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.top.left.bottom.right.py_constant(0);
    }];
}

@end


@interface PYLongpressMoveItemView()<UICollectionViewDelegate, UICollectionViewDataSource>

kPNSNA UIImageView * snapImageView;
kPNSNA id snapData;

kPNSNA UILongPressGestureRecognizer * longPress;
kPNSNA NSTimer * tapingTimer;

@end


@implementation PYLongpressMoveItemView{
    UICollectionView * collectionView;
}

kINITPARAMSForType(PYItemTapView){
    self.isCanDelCtx = YES;
    NSBundle * boundle;
    if([kAppBundleIdentifier isEqual:@"wlpiaoyi.PYKit"])
        boundle =  [NSBundle mainBundle];
    else
        boundle =  [NSBundle bundleWithPath:kFORMAT(@"%@/PYKit.bundle", bundleDir)];
    
    self.maxCount = 5;
    self.itemSize = CGSizeMake(105, 105);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self addSubview:collectionView];
    
    [collectionView registerNib:[UINib nibWithNibName:@"PYLongpressMoveItemCell" bundle:boundle] forCellWithReuseIdentifier:@"PYLongpressMoveItemCell"];
    [collectionView registerClass:[PYItemTapTailCell class] forCellWithReuseIdentifier:@"PYItemTapTailCell"];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.clipsToBounds = YES;
    [collectionView reloadData];
    [collectionView py_makeConstraints:^(PYConstraintMaker * _Nonnull make) {
        make.left.right.top.bottom.py_constant(0);
    }];
    
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tapLongPress:)];
    [collectionView addGestureRecognizer:longPress];
    self.longPress = longPress;
    self.hasAnimation = YES;

}

-(void) setDatas:(NSMutableArray *)datas{
    _datas = datas;
    [collectionView reloadData];
}

-(void) addData:(id) data animations:(BOOL) animations{
    if(self.datas == nil) _datas = [NSMutableArray new];
    [self.datas addObject:data];
    if(!animations){
        self.datas = self.datas;
        return;
    }
    [self->collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datas.count - 1 inSection:0]]];
}

-(void) setSnapImagePointer:(CGPoint) point{
    if(!_snapImageView) return;
    CGFloat pointX = point.x - collectionView.contentOffset.x;
    CGFloat pointY = point.y - collectionView.contentOffset.y;
    if(pointX < self.itemSize.width / 2) pointX = self.itemSize.width / 2;
    else if(pointX > self->collectionView.frameWidth - self.itemSize.width/2) pointX = self->collectionView.frameWidth - self.itemSize.width/2;
    if(pointY < self.itemSize.height / 2) pointY = self.itemSize.height / 2;
    else if(pointY > self->collectionView.frameHeight - self.itemSize.height/2) pointY = self->collectionView.frameHeight - self.itemSize.height/2;
    self.snapImageView.center = CGPointMake(pointX, pointY);
}

-(void) tapLongPress:(UILongPressGestureRecognizer *) longPress{
    if(self.isCanDelCtx == NO) return;
    if(self.longPress.state == UIGestureRecognizerStatePossible) return;
    CGPoint point = [longPress locationOfTouch:0 inView:longPress.view];
    [self setSnapImagePointer:point];
    NSIndexPath * indexPath = [collectionView indexPathForItemAtPoint:CGPointMake(point.x, collectionView.frameHeight / 2 + collectionView.frameY)];
    if(indexPath == nil) return;
    if(self.viewTail && indexPath.row >= self.datas.count) return;;
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(self.viewTail && indexPath.row >= self.datas.count) return;
        if(self.isShowDelCtx == NO){
            if(_blockBeforeEdit && !_blockBeforeEdit(self)) return;
        }
        self.snapData = self.datas[indexPath.row];
        PYLongpressMoveItemCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
        if(![cell isKindOfClass:[PYLongpressMoveItemCell class]]) return;
        UIImage * snapImage = cell.snapImage;
        UIImageView * imageView = [UIImageView new];
        imageView.image = snapImage;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frameSize = self.itemSize;
        self.snapImageView = imageView;
        self.snapImageView.alpha = .7;
        [self addSubview:self.snapImageView];
        [self setSnapImagePointer:point];
        self.isShowDelCtx = YES;
        return;
    }
    if (longPress.state == UIGestureRecognizerStateChanged){
        if(self.tapingTimer == nil){
            kAssign(self);
            self.tapingTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 repeats:YES block:^(NSTimer * _Nonnull timer) {
                kStrong(self);
                [self tapingOpt];
            }];
            [self.tapingTimer fire];
        }
        return;
    }

    [self longPressEnd];

}

-(void) longPressEnd{
    if(self.tapingTimer == nil){
        [self.snapImageView removeFromSuperview];
        [self->collectionView reloadData];
        self.snapImageView = nil;
        return;
    }
    [self.tapingTimer invalidate];
    self.tapingTimer = nil;
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.datas indexOfObject:self.snapData] inSection:0];
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    CGPoint point = [cell getAbsoluteOrigin:self.snapImageView.superview];
    [UIView animateWithDuration:.25f animations:^{
        self.snapImageView.frameOrigin = point;
        self.snapImageView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.snapImageView removeFromSuperview];
        self.snapImageView = nil;
        [self->collectionView reloadData];
        threadJoinGlobal(^{
            [NSThread sleepForTimeInterval:.3];
            threadJoinMain(^{
                [self->collectionView reloadData];
            });
        });
    }];
}

-(void) tapingOpt{
    if(self.longPress.state != UIGestureRecognizerStateChanged){
        [self longPressEnd];
        return;
    }
    CGPoint point = [self.longPress locationOfTouch:0 inView:self.longPress.view];
    NSIndexPath * indexPath = [collectionView indexPathForItemAtPoint:CGPointMake(point.x, collectionView.frameHeight / 2 + collectionView.frameY)];
//    NSIndexPath * indexPath = [collectionView indexPathForItemAtPoint:CGPointMake(MIN(self->collectionView.frameWidth - self.itemSize.width / 2, MAX(self.itemSize.width / 2, point.x)), MIN(self->collectionView.frameHeight - self.itemSize.height / 2, MAX(self.itemSize.height / 2, point.y)))];
    if(indexPath == nil) return;
    
    id data;
    PYLongpressMoveItemCell * cell;
    if(self.viewTail && indexPath.row < self.datas.count){
        data = self.datas[indexPath.row];
        cell = [collectionView cellForItemAtIndexPath:indexPath];
    }
    if(data && cell && data != self.snapData){
        NSIndexPath * snapIndexPath = [NSIndexPath indexPathForRow:[self.datas indexOfObject:self.snapData] inSection:0];
        id data = self.datas[indexPath.row];
        if(_blockBeforeMove && !_blockBeforeMove(self.snapData, data)) return;
        if(self.hasAnimation)
            [collectionView moveItemAtIndexPath:indexPath toIndexPath:snapIndexPath];
        self.datas[indexPath.row] = self.snapData;
        self.datas[snapIndexPath.row] = data;
        for (UICollectionViewCell * cell in collectionView.visibleCells) {
            if(![cell isKindOfClass:[PYLongpressMoveItemCell class]]) continue;
            NSIndexPath * indexPath = [collectionView indexPathForCell:cell];
            [self synCell:cell indexPath:indexPath];
        }
        
        if(self.hasAnimation == NO)
            [collectionView reloadData];
        if(_blockAfterMove) _blockAfterMove(self.snapData, data);
        
    }
    point.x -= collectionView.contentOffset.x;
    point.y -= collectionView.contentOffset.y;
    CGFloat xOffset = point.x - self.itemSize.width / 2;
    CGPoint contentOffset = collectionView.contentOffset;
    if(xOffset < 0){
        CGPoint contentOffset = collectionView.contentOffset;
        contentOffset.x += MIN(5, xOffset / collectionView.frameWidth * 100);
        if(contentOffset.x <= 0) contentOffset.x = 0;
        [self setItemViewContentOffset:contentOffset];
        return;
    }

    xOffset = point.x + self.itemSize.width / 2;
    if(xOffset > collectionView.frameWidth){
        contentOffset.x += MIN(5, ABS(xOffset - collectionView.frameWidth) / collectionView.contentSize.width * 100);
        if(contentOffset.x >= collectionView.contentSize.width - collectionView.frameWidth) contentOffset.x = collectionView.contentSize.width - collectionView.frameWidth;
        [self setItemViewContentOffset:contentOffset];

    }
}

-(void) setItemViewContentOffset:(CGPoint) contentOffset{
    CGFloat x = 0;
    if(self->collectionView.contentSize.width > self->collectionView.frameWidth){
        x = MAX(0, MIN(self->collectionView.contentSize.width - self->collectionView.frameWidth, contentOffset.x));
    }
    CGFloat y = 0;
    if(self->collectionView.contentSize.height > self->collectionView.frameHeight){
        y = MAX(0, MIN(self->collectionView.contentSize.height - self->collectionView.frameHeight, contentOffset.y));
    }
    [self->collectionView setContentOffset:CGPointMake(x, y)];
}

-(void) setIsShowDelCtx:(BOOL)isDelCtx{
    if(_isShowDelCtx == NO && isDelCtx != _isShowDelCtx && _blockAfterEdit){
        _blockAfterEdit(self);
    }
    _isShowDelCtx = isDelCtx;
    [collectionView reloadData];
    if(!_isShowDelCtx && self.snapImageView){
        [self.snapImageView removeFromSuperview];
        self.snapImageView = nil;
    }
}

-(void) setSnapImageView:(UIImageView *)snapImageView{
    _snapImageView = snapImageView;
    if(!snapImageView) self.snapData = nil;
}


#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}


#pragma mark UICollectionViewDataSource
// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemSize;
}

// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger count =MIN(self.maxCount, self.datas.count + (self.viewTail ? 1 : 0));
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >= self.datas.count){
        PYItemTapTailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PYItemTapTailCell" forIndexPath:indexPath];
        cell.viewTail = self.viewTail;
        CGPoint point = cell.frameOrigin;
        point.x = indexPath.row * (self.itemSize.width);
        cell.frameOrigin = point;
        return cell;
    }
    PYLongpressMoveItemCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PYLongpressMoveItemCell" forIndexPath:indexPath];
    [self synCell:cell indexPath:indexPath];
    CGPoint point = cell.frameOrigin;
    point.x = indexPath.row * (self.itemSize.width);
    cell.frameOrigin = point;
    if(self.blockAfterSetItem) self.blockAfterSetItem(self, cell.imageShowView, indexPath);
    return cell;
    
}

-(void) synCell:(PYLongpressMoveItemCell *) cell indexPath:(NSIndexPath *) indexPath{
    id data = self.datas[indexPath.row];
    cell.blockCheckData = self.blockCheckData;
    if([data isKindOfClass:[NSString class]]){
        cell.imgUrl = data;
    }else if([data isKindOfClass:[UIImage class]]){
        cell.imgData = data;
    }
    if(self.snapData){
        cell.isOnTap = cell.imgData == self.snapData || cell.imgUrl == self.snapData;
    }else{
        cell.isOnTap = NO;
    }
    if(cell.blockDel == nil){
        kAssign(self);
        cell.blockDel = ^(PYLongpressMoveItemCell * _Nonnull cell) {
            kStrong(self);
            id data = cell.imgUrl;
            if(!data) data = cell.imgData;
            if(self.blockBeforeDel && self.blockBeforeDel(data) == NO) return;
            if(self.hasAnimation && kSystemVersion.floatValue >= 13){
                kAssign(self);
                [self->collectionView performBatchUpdates:^{
                    kStrong(self);
                    NSInteger index = [self.datas indexOfObject:data];
                    [self->collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]];
                    [self.datas removeObject:data];
                } completion:^(BOOL finished) {
                    kStrong(self);
                    if(self.blockAfterDel) self.blockAfterDel(data);
                    [self->collectionView reloadData];
                }];
            }else{
                [self.datas removeObject:data];
                if(self.blockAfterDel) self.blockAfterDel(data);
                [self->collectionView reloadData];
            }
        };
    }
    cell.isDelCtx = self.isShowDelCtx;
}

@end
