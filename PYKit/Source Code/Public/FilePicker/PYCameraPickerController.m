//
//  PYCameraPickerController.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/22.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYCameraPickerController.h"
#import "PYInterflowParams.h"
#import <AVFoundation/AVFoundation.h>
#import "pyinterflowa.h"

@interface PYCameraPickerController ()<AVCapturePhotoCaptureDelegate>{

    NSBundle * bundle;
}
@property (weak, nonatomic) IBOutlet UIView *viewOutput;
@property (weak, nonatomic) IBOutlet UIButton *buttonConfirm;
@property (weak, nonatomic) IBOutlet UIView *viewShow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lcH;
kPNSNA AVCaptureSession * session;
kPNSNA AVCapturePhotoOutput * photoOutput;
kPNSNA AVCaptureDeviceInput * deviceInput;
kPNSNA NSArray<AVCaptureDevice *> * cameras;
kPNSNA AVCaptureVideoPreviewLayer * preview;
kPNA AVCaptureDevicePosition position;
@end

@implementation PYCameraPickerController

-(instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    bundle = [NSBundle bundleWithPath:kFORMAT(@"%@/PYKit.bundle", bundleDir)];
    self = [super initWithNibName:nibNameOrNil ? : @"PYCameraPickerController" bundle:bundle];
    self.imageSize = CGSizeZero;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self.buttonConfirm setCornerRadiusAndBorder:25 borderWidth:0 borderColor:nil];
    self.photoOutput = [[AVCapturePhotoOutput alloc] init];
    NSDictionary * outputSettings;
    if (@available(iOS 11.0, *)) {
        outputSettings = @{AVVideoCodecKey:AVVideoCodecTypeJPEG};
    } else {
        outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    }
    [self.photoOutput setLivePhotoCaptureEnabled:NO];
    [self.photoOutput connectionWithMediaType:AVMediaTypeVideo];
    [self.photoOutput setPhotoSettingsForSceneMonitoring:[AVCapturePhotoSettings photoSettingsWithFormat:outputSettings]];
    
    NSMutableArray<AVCaptureDevice *> * cameras = [NSMutableArray new];
    AVCaptureDeviceDiscoverySession * devices = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    if(devices.devices && devices.devices.count) [cameras addObjectsFromArray:devices.devices];
    devices = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
    if(devices.devices && devices.devices.count) [cameras addObjectsFromArray:devices.devices];
    self.cameras = cameras;
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    [self.session addOutput:self.photoOutput];
    self.position = AVCaptureDevicePositionBack;
    if(self.position != AVCaptureDevicePositionBack) return;
    self.preview = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.preview setFrame:CGRectMake(0, 0, boundsWidth(), boundsHeight())];
    [self.viewOutput.layer addSublayer:self.preview];
    [self.session startRunning];
    self.imageSize = self.imageSize;
    
}

-(void) setImageSize:(CGSize)imageSize{
    _imageSize = imageSize;
    self.lcW.constant = imageSize.width <= 0 ? boundsWidth() : imageSize.width;
    self.lcH.constant = imageSize.height <= 0 ? boundsHeight() : imageSize.height;
}

-(void) setPosition:(AVCaptureDevicePosition)position{
    _position = position;
    if(self.cameras == nil || self.cameras.count == 0) return;
    AVCaptureDevice * curCamera;
    for (AVCaptureDevice * camera  in self.cameras) {
        if(position == camera.position){
            curCamera = camera;
            break;
        }
    }
    if(!curCamera){
        _position = AVCaptureDevicePositionUnspecified;
        return;
    }
    NSError *error;
    AVCaptureDeviceInput * input = [[AVCaptureDeviceInput alloc] initWithDevice:curCamera error:&error];
    if(error){
        _position = AVCaptureDevicePositionUnspecified;
        NSLog(@"%@", error);
        return;
    }
    if(self.deviceInput)[self.session removeInput:self.deviceInput];
    self.deviceInput = input;
    [self.session addInput:input];
}

-(BOOL) getCameraFront{
    for (AVCaptureDevice * camera  in self.cameras) {
        if(camera.position == AVCaptureDevicePositionFront){
            NSError *error;
            AVCaptureDeviceInput * input = [[AVCaptureDeviceInput alloc] initWithDevice:camera error:&error];
            if(error){
                UIView * alert = [UIView new];
                [alert dialogShowWithTitle:nil message:error.userInfo[@"NSLocalizedFailureReason"] block:^(UIView * _Nonnull view, BOOL isConfirm) {
                    [view dialogHidden];
                } buttonConfirm:@"确定" buttonCancel:nil];
                return NO;
            }
            printf("%s", kFORMAT(@"%@", error).UTF8String);
            [self.session addInput:input];
            return YES;
        }
    }
    return NO;
}


- (IBAction)onclickConfirm:(id)sender {
    [self.photoOutput capturePhotoWithSettings:[AVCapturePhotoSettings photoSettings] delegate:self];
}
- (IBAction)onclickCancel:(id)sender {
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

- (IBAction)onclickCheck:(id)sender {
    self.position = self.position == AVCaptureDevicePositionBack ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
    if(self.position != AVCaptureDevicePositionUnspecified) return;
    
}

- (void)captureOutput:(AVCapturePhotoOutput *)output didFinishProcessingPhoto:(AVCapturePhoto *)photo error:(nullable NSError *)error API_AVAILABLE(ios(11.0)){
    UIImage *image;
    NSData *data = [photo fileDataRepresentation];
    image = [UIImage imageWithData:data];
    [self handelImage:image];
}

- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error {
    if (@available(iOS 11.0, *)) {
        return;
   }
   NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
   UIImage *image = [UIImage imageWithData:data];
   [self handelImage:image];
}

-(void) handelImage:(nonnull UIImage *) image{
    if(!CGSizeEqualToSize(self.imageSize, CGSizeZero)){
        CGSize size = image.size;
        CGFloat v = boundsWidth() / boundsHeight();
        CGFloat sv = size.width / size.height;
        CGRect rect;
        if(sv > v){
            CGFloat wf = size.width  - size.height * v;
            rect = CGRectMake(wf / 2, 0, size.width - wf, size.height);
        }else{
            CGFloat hf = size.height  - size.width / v;
            rect = CGRectMake(0, hf / 2, size.width, size.height - hf);
        }
        image = [image cutImage:rect];
        size = image.size;
        v = size.width / boundsWidth();
        rect = self.viewShow.frame;
        rect.size.width *= v;
        rect.size.height *= v;
        rect.origin.x *= v;
        rect.origin.y *= v;
        image = [image cutImage:rect];
    }
    [self onclickCancel:nil];
    if(_blockCamera && _blockCamera(image) == false) return;
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


-(void) image:(UIImage *) image didFinishSavingWithError:(NSError *) error contextInfo:(id) contextInfo{
    
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
