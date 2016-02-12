//
//  User.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithKey:(NSString *)key{
    self = [super init];
    
    if (self) {
        self.key = key;
        [[[[DataService dataService] USER_REF] childByAppendingPath:key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            if (snapshot.value == [NSNull new]) {
                return;
            }
            self.username = [snapshot.value objectForKey:@"username"];
            self.email = [snapshot.value objectForKey:@"email"];
            NSDictionary *followings = [snapshot.value objectForKey:@"followings"];
            if (followings != nil) {
                self.followings = [[followings allKeys] mutableCopy];
            }
            NSDictionary *photoIds = [snapshot.value objectForKey:@"images"];
            if (photoIds != nil) {
                self.photoIds = [[photoIds allKeys] mutableCopy];
            }
            
            [self.delegate userPropertyDidChange:self];
        }];
    }
    
    return self;
}

+ (NSString *)currentUserId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
}
@end
