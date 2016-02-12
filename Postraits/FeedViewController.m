//
//  FeedViewController.m
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "CommentTableViewCell.h"
#import "Photo.h"
#import "Comment.h"
#import "CommentViewController.h"
#import "PhotoViewController.h"

@interface FeedViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *pictureArray;
@property NSString *comment1;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pictureArray = [NSMutableArray new];
    self.tableView.estimatedRowHeight = 40.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self loadPhotos];
    
    self.comment1 = @"I had the best time ever!!!";
    self.photoView.clipsToBounds = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - Helper Methods

- (void) loadPhotos {
    FQuery *queryRef = [[[[DataService dataService] IMAGE_REF] queryOrderedByKey] queryLimitedToFirst:20];
    [queryRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        
        for (FDataSnapshot *child in snapshot.children) {
            Photo *photo = [Photo new];
            NSString *base64 = [child.value objectForKey:@"string"];
            
            if (base64) {
                NSData *decodedString = [[NSData alloc] initWithBase64EncodedString:base64 options:0];
                UIImage *decodedImage = [[UIImage alloc] initWithData:decodedString];
                
                photo.image = decodedImage;
                photo.key = child.ref.key;
                
                [self.pictureArray insertObject:photo atIndex:0];
                
            }else{ return; }
            
            // load user
            NSString *userId = [child.value objectForKey:@"user"];
            if (userId) {
                [[[[DataService dataService] USER_REF] childByAppendingPath:userId] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                    if(snapshot.value != [NSNull new]){
                        User *user = [User new];
                        
                        NSString *username = [snapshot.value objectForKey:@"username"];
                        user.username = username;
                        photo.user = user;
                        [self.tableView reloadData];
                    }else{
                        [self.pictureArray removeObject:photo];
                    }
                }];
            }else {
                return;
            }
            
            //load comments
            NSDictionary *comments = [child.value objectForKey:@"comments"];
            if (comments != nil) {
                for (NSString *comment in comments) {
                    [[[[DataService dataService] COMMENT_REF] childByAppendingPath:comment] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                        if(snapshot.value != [NSNull new]){
                            Comment *comment = [Comment new];
                            
                            NSString *username = [snapshot.value objectForKey:@"body"];
                            comment.body = username;
                            [photo.comments addObject:comment];
                            
                            [self.tableView reloadData];
                        }
                    }];
                }
            }
        };
        
    }];
}

#pragma mark - TableView


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Photo *photo = [self.pictureArray objectAtIndex:indexPath.section];
    
    if (indexPath.row == 0) {
        FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.photoImage.image = photo.image;
        return cell;
    }
    else {
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
        Comment *comment = [photo.comments objectAtIndex:(indexPath.row - 1)];
        cell.textLabel.text = comment.body;
        cell.textLabel.numberOfLines = 0;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    Photo *photo = [self.pictureArray objectAtIndex:section];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    NSString *string = photo.user.username;
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    Photo *photo = [self.pictureArray objectAtIndex:section];
    NSUInteger count = photo.comments.count > 2 ? 2 : photo.comments.count;
    return 1 + count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.pictureArray.count;
}



 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"PhotoShowSegue"]) {
         PhotoViewController *destination = segue.destinationViewController;
         FeedTableViewCell *cell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
         Photo *photo = self.pictureArray[indexPath.section];
         destination.photo = photo;
     }else if ([segue.identifier isEqualToString:@"CommentIndexSegue"]){
         CommentViewController *destination = segue.destinationViewController;
         UITableViewCell *cell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
         Photo *photo = self.pictureArray[indexPath.section];
         destination.photo = photo;
     }
 }
 

@end
