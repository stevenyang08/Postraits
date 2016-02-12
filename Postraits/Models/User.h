//
//  User.h
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataService.h"
@class User;

@protocol UserDelegate <NSObject>

- (void)userPropertyDidChange:(User *)user;

@end

@interface User : NSObject

@property id <UserDelegate> delegate;
@property NSString *username;
@property NSString *email;
@property NSString *key;
@property NSMutableArray *followings;
@property NSMutableArray *photoIds;

+ (NSString *)currentUserId;
- (instancetype)initWithKey:(NSString *)key;

@end
