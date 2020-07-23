//
//  PYImagePickerReusableView.m
//  PYKit
//
//  Created by wlpiaoyi on 2020/7/21.
//  Copyright © 2020 wlpiaoyi. All rights reserved.
//

#import "PYImagePickerReusableView.h"

@implementation PYImagePickerReusableView{
    __weak IBOutlet UILabel *labelName;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void) setName:(NSString *)name{
    _name = name;
    labelName.text = name;
}

@end
