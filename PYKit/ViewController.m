//
//  ViewController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/4/19.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "ViewController.h"
#import "PYDisplayImageView.h"
#import "UITextField+Check.h"
#import "TextFieldCheckController.h"
#import "PYAudioRecord.h"
#import "PYAudioPlayer.h"



@interface ViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet PYDisplayImageView *viewImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic,strong) PYAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textField clearTextFieldCheck];
    self.textField.delegate = self;
    [self.textField checkFloatForMax:9999.99 min:0.00 precision:2];
//    [self.textField checkIntegerForMax:8888 min:-9999];
//    [self.textField checkEmail];
//    [self.textField checkMobliePhone];
//    [self.textField checkIDCard];
    @unsafeify(self);
    [self.textField setBlockInputEndMatch:^(NSString * _Nonnull identify, BOOL * _Nonnull checkResult){
        @strongify(self);
        NSLog(@"");
    }];
    ((PYDisplayImageView*)self.viewImage).imgUrl = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1494325479616&di=12bf378980ba10da9c81426c753c952c&imgtype=0&src=http%3A%2F%2Fimg2.niutuku.com%2F1312%2F0850%2F0850-niutuku.com-30110.jpg";//@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1492615837709&di=d1557b3e4bc4106d8969cc023f29a3c6&imgtype=0&src=http%3A%2F%2Fc.hiphotos.baidu.com%2Fzhidao%2Fpic%2Fitem%2F8601a18b87d6277fc422bbe028381f30e924fc32.jpg";
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
//    [self presentViewController:[TextFieldCheckController new] animated:YES completion:^{
//        
//    }];
    return YES;
}
- (IBAction)start:(id)sender {
    NSURL * url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/record.mp3",documentDir]];
    [[PYAudioRecord getSingleInstance] start:url settings:@{AVFormatIDKey:@(kAudioFormatMPEGLayer3)}];
}
- (IBAction)stop:(id)sender {
    [[PYAudioRecord getSingleInstance] stop];
    NSFileManager *fm = [NSFileManager defaultManager];
//    [fm removeItemAtPath:[pathWav relativePath] error:&erro];
    
    self.player = [PYAudioPlayer new];
    NSError *error;
    NSArray<NSString *> * array =  [fm subpathsOfDirectoryAtPath:documentDir error:&error];
    if (!error) {
        for (NSString * path in array) {
            [self.player addAudioUrl:[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", documentDir, path]]];
        }
        [self.player play];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
