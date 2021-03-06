//
//  PYImagePickerCell.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYImagePickerCell.h"
#import "pyutilea.h"

PHImageRequestOptions * xPYImagePickerCellOptions;
UIImage * PYDEFAULT_PICKER_IMAGE;

@implementation PYImagePickerCell{
    __weak IBOutlet UIImageView *imagePhoto;
    __weak IBOutlet UIButton *buttonSelected;
    __weak IBOutlet UIActivityIndicatorView *activityIndicatorView;
    
}

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        xPYImagePickerCellOptions = options;
        PYDEFAULT_PICKER_IMAGE = [UIImage imageNamed:@"PYKit.bundle/images/py-image-loading@3x.png"];
    });
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isLoading = NO;
    if (@available(iOS 13.0, *)) {
        [buttonSelected setShadowColor:[UIColor systemBackgroundColor].CGColor shadowRadius:4];
    } else {
        [buttonSelected setShadowColor:[UIColor whiteColor].CGColor shadowRadius:4];
    }
    [activityIndicatorView setShadowColor:[UIColor whiteColor].CGColor shadowRadius:0];
}
-(void) setIsLoading:(BOOL)isLoading{
    _isLoading = isLoading;
    if(isLoading){
        activityIndicatorView.hidden = NO;
        [activityIndicatorView startAnimating];
    }else{
        [activityIndicatorView stopAnimating];
        activityIndicatorView.hidden = YES;
    }
}

-(void) setImageData:(UIImage *)imageData{
    _imageData = imageData;
    imagePhoto.image = imageData;
}

-(void) setIsSelectedData:(BOOL)isSelectedData{
    _isSelectedData = isSelectedData;
    buttonSelected.hidden = !isSelectedData;
}

-(void) setAsset:(PHAsset *)asset{
    _asset = asset;
    CGFloat w = boundsWidth() / 2 - 4;
    CGSize size = CGSizeMake(w, w/asset.pixelWidth*asset.pixelHeight);
    self->imagePhoto.image = PYDEFAULT_PICKER_IMAGE;
    threadJoinGlobal(^{
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:xPYImagePickerCellOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            threadJoinMain(^{
                self->imagePhoto.image = result ? : PYDEFAULT_PICKER_IMAGE;
            });
        }];
    });
}

@end
