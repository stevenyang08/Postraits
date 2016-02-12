//
//  CustomClass.h
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DataService.h"
#import "User.h"
#import "Comment.h"

@protocol PhotoDelegate <NSObject>

- (void) photoPropertyDidChange;

@end

@interface Photo : NSObject

@property id <PhotoDelegate> delegate;
@property NSString *key;
@property UIImage *image;
@property User *user;
@property NSMutableArray *comments;
@property NSMutableArray *likes;
@property NSUInteger likesCount;

- (void)setLike;
- (instancetype)initWithKey:(NSString *)key;
- (BOOL)userLiked:(NSString *)userId;
@end
