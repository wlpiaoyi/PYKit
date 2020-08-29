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
    __weak IBOutlet UIButton *buttonExpand;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
- (IBAction)onclickExpand:(id)sender {
    if(_blockExpand && !_blockExpand(self)){
        return;
    }
}

-(void) setIsExpand:(BOOL)isExpand{
    _isExpand = isExpand;
    buttonExpand.selected = isExpand;
}

-(void) setName:(NSString *)name{
    _name = name;
    labelName.text = name;
}

@end
