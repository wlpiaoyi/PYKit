//
//  PYLongpressMoveItemCell.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/12/1.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYLongpressMoveItemCell.h"
#import "PYAsyImageView.h"

@implementation PYLongpressMoveItemCell{
    __weak IBOutlet PYAsyImageView *imageCtxView;
    __weak IBOutlet UIButton *buttonDel;
    __weak IBOutlet UIView *viewDelCtx;
    __weak IBOutlet UIView *viewCtx;
    NSTimer * timerRatation;
}
-(UIImageView *) imageShowView{
    return imageCtxView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isDelCtx = NO;
    self.isOnTap = NO;
    [imageCtxView.superview setCornerRadiusAndBorder:4 borderWidth:0 borderColor:nil];
    NSString * imagePath;
#ifdef DEBUG
    imagePath = @"PYKit.bundle/images/pykit-press-del.png";
#else
    imagePath = @"PYKit.bundle/images/pykit-press-del.png";
#endif
    UIImage * image = [UIImage imageNamed:imagePath];
    kPrintLogln("=====>%s : %s", imagePath.UTF8String, [image description].UTF8String);
    [buttonDel setImage:image forState:UIControlStateNormal];
}


-(void) setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    _imgData = nil;
    imageCtxView.imgUrl = _blockCheckData ? _blockCheckData(_imgUrl) : _imgUrl;
}

-(void) setImgData:(UIImage *)imgData{
    _imgData = imgData;
    _imgUrl = nil;
    imageCtxView.image = imgData;
    imageCtxView.image = _blockCheckData ? _blockCheckData(_imgData) : _imgData;
}

-(void) setIsDelCtx:(BOOL)isDelCtx{
    _isDelCtx = isDelCtx;
    viewDelCtx.hidden = !isDelCtx;
//    if(_isDelCtx){
//        if(!timerRatation){
//            timerRatation = [NSTimer scheduledTimerWithTimeInterval:.21 repeats:YES block:^(NSTimer * _Nonnull timer) {
//                [UIView animateWithDuration:.1 animations:^{
//                    viewCtx.transform = CGAffineTransformMakeRotation (M_PI_2 / 16);
//                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:.1 animations:^{
//                        viewCtx.transform = CGAffineTransformMakeRotation(-M_PI_2 / 16);
//                    } completion:^(BOOL finished) {
//                    }];
//                }];
//            }];
//            [timerRatation fire];
//        }
//    }else{
//        if(timerRatation){
//            [timerRatation invalidate];
//            timerRatation = nil;
//        }
//    }
}

-(UIImage *) snapImage{
    UIImage *snap;
    UIGraphicsBeginImageContextWithOptions(imageCtxView.bounds.size, YES, 0);
    [imageCtxView.layer renderInContext:UIGraphicsGetCurrentContext()];
    snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return snap;
}

-(void) setIsOnTap:(BOOL)isOnTap{
    _isOnTap = isOnTap;
    viewCtx.hidden = isOnTap;
}


- (IBAction)onclickDel:(id)sender {
    if(_blockDel) _blockDel(self);
}

@end
