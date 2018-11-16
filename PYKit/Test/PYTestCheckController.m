//
//  PYTestCheckController.m
//  PYKit
//
//  Created by wlpiaoyi on 2018/5/28.
//  Copyright © 2018年 wlpiaoyi. All rights reserved.
//

#import "PYTestCheckController.h"
#import "UITextField+PYCheck.h"

@interface PYTestCheckController ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldFloat;
@property (weak, nonatomic) IBOutlet UITextField *textFieldInt;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhone;
@property (weak, nonatomic) IBOutlet UITextField *textFieldIDCard;

@end

@implementation PYTestCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.textFieldFloat pyClearTextFieldCheck];
    [self.textFieldInt pyClearTextFieldCheck];
    [self.textFieldEmail pyClearTextFieldCheck];
    [self.textFieldPhone pyClearTextFieldCheck];
    [self.textFieldIDCard pyClearTextFieldCheck];
    
    [self.textFieldFloat pyCheckFloatForMax:999.99 min:0 precision:2];
    [self.textFieldInt pyCheckIntegerForMax:999 min:0];
    [self.textFieldEmail pyCheckEmail];
    [self.textFieldPhone pyCheckMobliePhone];
    [self.textFieldIDCard pyCheckIDCard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
