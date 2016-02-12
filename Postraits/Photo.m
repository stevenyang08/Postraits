//
//  CustomClass.m
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "Photo.h"

@interface Photo() <CommentDelegate, UserDelegate>
@end

@implementation Photo

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.comments = [NSMutableArray new];
    }
    
    return self;
}

- (instancetype)initWithKey:(NSString *)key{
    self = [super init];
    
    if (self) {
        self.key = key;
        [[[[DataService dataService] IMAGE_REF] childByAppendingPath:key] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            self.comments = [NSMutableArray new];
            self.likes = [NSMutableArray new];
            NSString *base64 = [snapshot.value objectForKey:@"string"];
            if (base64) {
                NSData *decodedString = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                UIImage *decodedImage = [[UIImage alloc] initWithData:decodedString];
                self.image = decodedImage;
            }
            
            NSString *userId = [snapshot.value objectForKey:@"user"];
            self.user = [[User alloc] initWithKey:userId];
            self.user.delegate = self;
            
            for (NSString *userId in [[snapshot.value objectForKey:@"likes"] allKeys]) {
                [self.likes addObject:userId];
            }
            
            for (NSString *commentId in [[snapshot.value objectForKey:@"comments"] allKeys]) {
                Comment *comment = [[Comment alloc] initWithKey:commentId];
                comment.delegate = self;
                [self.comments addObject:comment];
            }
            [self.delegate photoPropertyDidChange];
            
            NSNumber *likesCount = [snapshot.value objectForKey:@"likesCount"];
            
            if (likesCount == nil) {
                self.likesCount = 0;
            }else{
                self.likesCount = [likesCount intValue];
            }
            
        }];
    }
    
    return self;
}

- (void)setLike{
    NSString *currentUserId = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    Firebase *likesRef = [[[self photoRef] childByAppendingPath:@"likes"] childByAppendingPath:currentUserId];
    
    Firebase *likesCountRef = [[self photoRef] childByAppendingPath:@"likesCount"];
    
    [likesRef observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        if (snapshot.value == [NSNull new]) {
            [likesRef setValue: [NSNumber numberWithBool:true]];
            [likesCountRef runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
                NSNumber *value = currentData.value;
                if (currentData.value == [NSNull null]) {
                    value = 0;
                }
                [currentData setValue:[NSNumber numberWithInt:(1 + [value intValue])]];
                return [FTransactionResult successWithValue:currentData];
            }];
        }else{
            [likesRef removeValue];
            [likesCountRef runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
                NSNumber *value = currentData.value;
                if (currentData.value == [NSNull null]) {
                    value = 0;
                }
                [currentData setValue:[NSNumber numberWithInt:([value intValue] - 1)]];
                return [FTransactionResult successWithValue:currentData];
            }];
        }
    }];
}

- (Firebase *)photoRef {
    return [[[DataService dataService] IMAGE_REF] childByAppendingPath:self.key];
}

- (BOOL)userLiked:(NSString *)userId{
    return [self.likes containsObject:userId];
}

- (void)commentPropertyDidChange {
    [self.delegate photoPropertyDidChange];
}

- (void)userPropertyDidChange:(User *)user {
    [self.delegate photoPropertyDidChange];
}
@end
