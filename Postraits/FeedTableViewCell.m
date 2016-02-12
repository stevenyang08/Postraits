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
    
    [self.photo setLike];
    
    if ([self.photo userLiked:[[NSUserDefaults standardUserDefaults] stringForKey:@"uid"]]) {
        [self.likeButton setImage:[UIImage imageNamed:@"red_like"] forState:UIControlStateNormal];
    }else{
        [self.likeButton setImage:[UIImage imageNamed:@"white_like"] forState:UIControlStateNormal];
    }
}


@end
