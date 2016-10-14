//
//  XYJPersonTableViewCell.m
//  DatabaseDemo
//
//  Created by muhlenXi on 16/10/11.
//  Copyright © 2016年 XiYinjun. All rights reserved.
//

#import "XYJPersonTableViewCell.h"

@implementation XYJPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.cellHeadImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.cellHeadImageView.layer.cornerRadius = 7;
    self.cellHeadImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
