//
//  PhotoShowTableViewCell.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "PhotoShowTableViewCell.h"

@interface PhotoShowTableViewCell()


@end

@implementation PhotoShowTableViewCell

- (void)awakeFromNib {
    CGFloat width = self.contentView.bounds.size.width;
    self.photoView.frame = CGRectMake(0, 0, width, width);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
