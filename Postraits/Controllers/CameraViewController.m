//
//  CameraViewController.m
//  Postraits
//
//  Created by Wong You Jing on 09/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "CameraViewController.h"
#import "TGCameraViewController.h"
#import "DataService.h"
#import "Photo.h"



@interface CameraViewController () <TGCameraDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;

@property Photo *photo;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.takePhoto.backgroundColor = [UIColor colorWithRed:0/255.0 green:100/255.0 blue:200/255.0  alpha:1.0];

    [TGCamera setOption:kTGCameraOptionSaveImageToAlbum value:[NSNumber numberWithBool:YES]];
}

- (IBAction)takePhotoTapped:(id)sender {
    
    TGCameraNavigationController *navigationController =
    [TGCameraNavigationController newWithCameraDelegate:self];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (IBAction)chooseExistingPhotoTapped:(id)sender {
    
    UIImagePickerController *pickerController =
    [TGAlbum imagePickerControllerWithDelegate:self];
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - TGCameraDelegate required

- (void)cameraDidCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidTakePhoto:(UIImage *)image
{
    [[DataService dataService] uploadImageToFireBase:image];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidSelectAlbumPhoto:(UIImage *)image
{
    self.photo.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

# pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [TGAlbum imageWithMediaInfo:info];
    [[DataService dataService] uploadImageToFireBase:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
