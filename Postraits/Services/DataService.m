//
//  DataService.m
//  Postraits
//
//  Created by Wong You Jing on 09/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "DataService.h"
#import "Constants.h"
#import <Firebase/Firebase.h>

@interface DataService ()

@end


@implementation DataService

+ (instancetype) dataService {
    return [[DataService alloc] init];
}


- (Firebase *) BASE_REF {
    Firebase *ref = [[Firebase alloc] initWithUrl:BASE_URL];
    return ref;
}

- (Firebase *) USER_REF {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, @"/users"]];
    return ref;
}

- (Firebase *) IMAGE_REF {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, @"/images"]];
    return ref;
}

- (Firebase *) COMMENT_REF {
    Firebase *ref = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@%@", BASE_URL, @"/comments"]];
    return ref;
}

- (Firebase *) CURRENT_USER_REF {
    NSString *userId = [[NSUserDefaults standardUserDefaults] valueForKey:@"uid"];
    
    Firebase *ref = [[[self BASE_REF] childByAppendingPath:@"users"] childByAppendingPath:userId];
    
    return ref;
}

- (void) createNewAccount:(NSString *)uid user:(NSDictionary *)user{
    [[[self USER_REF] childByAppendingPath:uid] setValue:user];
}

- (void) uploadImageToFireBase:(UIImage *)image {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSString *base64String = [imageData base64EncodedStringWithOptions:0];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    NSDictionary *quoteString = [[NSDictionary alloc] initWithObjects:@[base64String, userId] forKeys:@[@"string", @"user"]];
    
    Firebase *newImageRef = [[self IMAGE_REF] childByAutoId];
    
    [newImageRef setValue:quoteString withCompletionBlock:^(NSError *error, Firebase *ref) {
        if(!error){
            NSDictionary *updatedImages = @{ref.key: [NSNumber numberWithBool:true]};
            [[[self CURRENT_USER_REF] childByAppendingPath:@"images"] updateChildValues:updatedImages];
        }
    }];
}

- (void) createNewComment:(NSString *)commentString photoKey:(NSString *)photoKey{
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    
    Firebase *newCommentRef = [[self COMMENT_REF] childByAutoId];
    
    NSDictionary *commentDict = @{ @"body": commentString,
                                   @"image": photoKey,
                                   @"author": userId
                                   };
    
    [newCommentRef setValue:commentDict withCompletionBlock:^(NSError *error, Firebase *ref) {
        
        [[[self CURRENT_USER_REF] childByAppendingPath:@"authoredComments"] updateChildValues:@{ ref.key: [NSNumber numberWithBool:true] }];
        [[[self IMAGE_REF] childByAppendingPath:[NSString stringWithFormat: @"/%@/comments", photoKey]] updateChildValues:@{ ref.key: [NSNumber numberWithBool:true] }];
        
    }];
}


@end
