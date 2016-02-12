//
//  Comment.m
//  Postraits
//
//  Created by Wong You Jing on 10/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "Comment.h"


@implementation Comment

- (instancetype)initWithKey:(NSString *)key{
    self = [super init];
    if (self) {
        [[[[DataService dataService] COMMENT_REF] childByAppendingPath:key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            self.body = [snapshot.value objectForKey:@"body"];
            [self.delegate commentPropertyDidChange];
        }];
    }
    return self;
}

@end
