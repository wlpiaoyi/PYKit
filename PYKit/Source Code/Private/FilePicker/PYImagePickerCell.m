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

@implementation PYImagePickerCell{
    __weak IBOutlet UIImageView *imagePhoto;
    __weak IBOutlet UIButton *buttonSelected;

}

+(void) initialize{
    static dispatch_once_t onceToken; dispatch_once(&onceToken, ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeFast;
        options.synchronous = YES;
        xPYImagePickerCellOptions = options;
    });
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (@available(iOS 13.0, *)) {
        [buttonSelected setShadowColor:[UIColor systemBackgroundColor].CGColor shadowRadius:4];
    } else {
        [buttonSelected setShadowColor:[UIColor whiteColor].CGColor shadowRadius:4];
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
    CGSize size = CGSizeMake(200, 200./asset.pixelWidth*asset.pixelHeight);
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:xPYImagePickerCellOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self->imagePhoto.image = result;
    }];
}

@end
