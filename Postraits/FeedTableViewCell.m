//
//  FeedTableViewCell.m
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "FeedViewController.h"
#import "CommentViewController.h"

@implementation FeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonTapped:(UIButton *)sender {
    UIButton *button = (UIButton *)sender;
    if (button.currentImage == [UIImage imageNamed:@"white_like"]) {
        self.didLike = YES;
    }
    if (button.currentImage == [UIImage imageNamed:@"red_like"]) {
        self.didLike = NO;
    }
    if (!self.didLike) {
        [button setImage:[UIImage imageNamed:@"red_like"] forState:UIControlStateNormal];
        self.num = 0;
        self.num += 1;
        if (self.num <= 1) {
            self.likesLabel.text = [NSString stringWithFormat:@"%li like", (long)self.num];
        }
        else {
            self.likesLabel.text = [NSString stringWithFormat:@"%li likes", (long)self.num];
        }
        self.didLike = YES;
        
    } else {
        [button setImage:[UIImage imageNamed:@"white_like"] forState:UIControlStateNormal];
        self.num = 0;
        self.num += 0;
        if (self.num <= 1) {
            self.likesLabel.text = [NSString stringWithFormat:@"%li like", (long)self.num];
        }
        else {
           self.likesLabel.text = [NSString stringWithFormat:@"%li likes", (long)self.num];
        }
        self.didLike = NO;
    }

}


@end
