//
//  FeedTableViewCell.h
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataService.h"
#import "Photo.h"

@interface FeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property NSInteger num;
@property (nonatomic)BOOL didLike;
@property (weak, nonatomic) IBOutlet UITextView *userCommentText;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property Photo *photo;

@end
