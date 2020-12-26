//
//  PYMetadataQRController.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/12/18.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYMetadataQRController.h"
#import <AVFoundation/AVFoundation.h>


@interface PYMetadataQRController ()<AVCaptureMetadataOutputObjectsDelegate>{
    NSBundle * bundle;
}

@property (weak, nonatomic) IBOutlet UIView *viewOutput;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (weak, nonatomic) IBOutlet UIView *viewShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcH;


kPNSNA AVCaptureSession * session;
kPNSNA AVCaptureOutput * output;//
kPNSNA AVCaptureDeviceInput * deviceInput;
kPNSNA NSArray<AVCaptureDevice *> * cameras;
kPNSNA AVCaptureVideoPreviewLayer * preview;
kPNA AVCaptureDevicePosition position;

@end

@implementation PYMetadataQRController

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    if([kAppBundleIdentifier isEqual:@"wlpiaoyi.PYKit"])
        bundle =  [NSBundle mainBundle];
    else
        bundle =  [NSBundle bundleWithPath:kFORMAT(@"%@/PYKit.bundle", bundleDir)];

    self = [super initWithNibName:nibNameOrNil ? : @"PYCameraPickerController" bundle:bundle];
    self.QRSize = CGSizeZero;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
