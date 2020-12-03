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
    __weak IBOutlet UIView *viewDelCtx;
    __weak IBOutlet UIView *viewCtx;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isDelCtx = NO;
    self.isOnTap = NO;
}

-(void) setImgUrl:(NSString *)imgUrl{
    _imgUrl = imgUrl;
    imageCtxView.imgUrl = imgUrl;
}

-(void) setImgData:(UIImage *)imgData{
    _imgData = imgData;
    imageCtxView.image = imgData;
}

-(void) setIsDelCtx:(BOOL)isDelCtx{
    _isDelCtx = isDelCtx;
    viewDelCtx.hidden = !isDelCtx;
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
