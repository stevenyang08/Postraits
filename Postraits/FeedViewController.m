//
//  FeedViewController.m
//  Postraits
//
//  Created by Steven Yang on 2/8/16.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "FeedViewController.h"
#import "TGCamera.h"
#import "TGCameraViewController.h"
#import "TGCameraColor.h"
#import "FeedTableViewCell.h"
#import "CustomClass.h"

@interface FeedViewController () <TGCameraDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)takePhotoTapped;

- (IBAction)chooseExistingPhotoTapped;

//- (void)clearTapped;

@property NSMutableArray *pictureArray;
@property CustomClass *photo;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // save image at album
    self.photo = [CustomClass new];
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
    self.pictureArray = [NSMutableArray new];
    
    for (int i = 0; i < 20; i++) {
        CustomClass *post = [CustomClass new];
        post.user = [NSString stringWithFormat:@"User %i", i];
        post.image = [UIImage imageNamed:@"empty"];
        [self.pictureArray addObject:post];
    }
    
    self.tableView.rowHeight = 320;
    [TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:[NSNumber numberWithBool:YES]];
    
    // hidden toggle button
    //[TGCamera setOption:kTGCameraOptionHiddenToggleButton value:[NSNumber numberWithBool:YES]];
    //[TGCameraColor setTintColor: [UIColor greenColor]];
    
    // hidden album button
    //[TGCamera setOption:kTGCameraOptionHiddenAlbumButton value:[NSNumber numberWithBool:YES]];
    
    // hide filter button
    //[TGCamera setOption:kTGCameraOptionHiddenFilterButton value:[NSNumber numberWithBool:YES]];
    
    
    self.photoView.clipsToBounds = YES;
    
//    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
//                                                                                 target:self
//                                                                                 action:@selector(clearTapped)];
//    
//    self.navigationItem.rightBarButtonItem = clearButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    self.photo.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    self.photo.image = image;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TGCameraDelegate optional

- (void)cameraWillTakePhoto
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)cameraDidSavePhotoAtPath:(NSURL *)assetURL
{
    NSLog(@"%s album path: %@", __PRETTY_FUNCTION__, assetURL);
}

- (void)cameraDidSavePhotoWithError:(NSError *)error
{
    NSLog(@"%s error: %@", __PRETTY_FUNCTION__, error);
}

#pragma mark -
#pragma mark - Actions

- (IBAction)takePhotoTapped
{
    TGCameraNavigationController *navigationController = [TGCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private methods

- (void)clearTapped
{
    //_photoView.image = nil;
}

#pragma mark - Upload Photo

- (IBAction)chooseExistingPhotoTapped
{
    UIImagePickerController *pickerController =
    [TGAlbum imagePickerControllerWithDelegate:self];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.photo.image = [TGAlbum imageWithMediaInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.tableView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TableView
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.photoImage.image = self.photo.image;
    //cell.usernameLabel.text = self.photo.user;
    cell.usernameLabel.text = @"myself123";
    return cell;
}

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return 2;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.pictureArray.count;
    return self.pictureArray.count;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
