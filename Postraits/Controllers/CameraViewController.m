//
//  CameraViewController.m
//  Postraits
//
//  Created by Wong You Jing on 09/02/2016.
//  Copyright © 2016 Le Mont. All rights reserved.
//

#import "CameraViewController.h"
#import "TGCameraViewController.h"
#import "CustomClass.h"



@interface CameraViewController () <TGCameraDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property CustomClass *photo;

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.photo.image = image;
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
    self.photo.image = [TGAlbum imageWithMediaInfo:info];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
