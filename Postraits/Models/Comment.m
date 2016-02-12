//
//  Comment.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "Comment.h"
@interface Comment () <UserDelegate>
@end

@implementation Comment

- (instancetype)initWithKey:(NSString *)key{
    self = [super init];
    if (self) {
        self.key = key;
        [[[[DataService dataService] COMMENT_REF] childByAppendingPath:key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            if (snapshot.value != [NSNull new]) {
                self.body = [snapshot.value objectForKey:@"body"];
            }else{
                self.body = @"";
            }
            
            self.user = [[User alloc] initWithKey:[snapshot.value objectForKey:@"author"]];
            self.user.delegate = self;
            [self.delegate commentPropertyDidChange];
            
            
        }];
    }
    return self;
}

- (void)userPropertyDidChange:(User *)user{
    [self.delegate commentPropertyDidChange];
}

- (NSString *)bodyWithAuthor{
    NSString *username;
    if (self.user) {
        username = self.user.username;
    }
    
    if (username) {
        return [NSString stringWithFormat:@"%@: %@", username, self.body];
    }else{
        return self.body;
    }
    
}
@end
