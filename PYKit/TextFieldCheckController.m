//
//  TextFieldCheckController.m
//  PYKit
//
//  Created by wlpiaoyi on 2017/7/3.
//  Copyright © 2017年 wlpiaoyi. All rights reserved.
//

#import "TextFieldCheckController.h"
#import "UITextField+PYCheck.h"
#import "PYViewAutolayoutCenter.h"

@interface PYTextField : UITextField

@end
@implementation PYTextField
-(BOOL) resignFirstResponder{
    return [super resignFirstResponder];
}
-(void) dealloc{
}

@end

@interface TextFieldCheckController ()
kPNSNN UITextField * texField;
kPNSNN UIButton * button;
@end

@implementation TextFieldCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setTitle:@"back" forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    [PYViewAutolayoutCenter persistConstraint:self.button size:CGSizeMake(100, 44)];
    [PYViewAutolayoutCenter persistConstraint:self.button relationmargins:UIEdgeInsetsMake(0, 0, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    self.texField = [PYTextField new];
    [self.view addSubview:self.texField];
    self.texField.backgroundColor = [UIColor redColor];
    [PYViewAutolayoutCenter persistConstraint:self.texField size:CGSizeMake(200, 44)];
    [PYViewAutolayoutCenter persistConstraint:self.texField relationmargins:UIEdgeInsetsMake(0, 100, 0, 0) relationToItems:PYEdgeInsetsItemNull()];
    [self.texField pyClearTextFieldCheck];
    [self.texField pyCheckFloatForMax:9999.99 min:0.00 precision:2];
}
-(void) back{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) dealloc{
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
