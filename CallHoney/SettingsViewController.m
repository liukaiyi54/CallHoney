//
//  SettingsViewController.m
//  CallHoney
//
//  Created by Michael on 21/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "SettingsViewController.h"
#import "ImageCollectionViewCell.h"

#import <ChameleonFramework/Chameleon.h>

static NSString *const kImageCollectionViewCell = @"kImageCollectionViewCell";

@interface SettingsViewController () <
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSString *currentImageName;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    [self.collectionView addSubview:self.imageView];
    [self.collectionView addSubview:self.addButton];
    
    NSString *string = NSLocalizedString(@"Select Background", nil);
    self.title = string;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapCheck:)];
    [item setImageInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - UICollectionViewDelegate & etc
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self imageNames].count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    return CGSizeMake(screenWidth/4-10, screenWidth/4+30.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImageCollectionViewCell forIndexPath:indexPath];
    NSString *imageName = [[self imageNames] objectAtIndex:indexPath.row];
    cell.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.currentImageName = [self imageNames][indexPath.row];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private
- (void)configureCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    NSString *nibName = NSStringFromClass([ImageCollectionViewCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:kImageCollectionViewCell];
}

#pragma mark - event handler
- (IBAction)didTapClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapCheck:(id)sender {
    if (self.currentImageName) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageName" object:self.currentImageName];
        [[NSUserDefaults standardUserDefaults] setObject:self.currentImageName forKey:@"ImageName"];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapAdd:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - getters
- (NSArray *)imageNames {
    return @[@"mountain.jpeg", @"flower.jpeg", @"mosaic.jpeg", @"star.jpeg", @"fuji.jpeg", @"balloon.jpeg", @"cloud.jpg", @"sky.jpeg"];
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.bounds)/2-80, CGRectGetMaxY(self.imageView.frame)+10, 160, 60)];
        [_addButton setTitle:@"Select From Local" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor flatMintColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(didTapAdd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        CGFloat cellHeight = CGRectGetWidth(self.view.frame)/4 + 30;
        CGFloat cellWidth = CGRectGetWidth(self.view.frame)/4 - 10;
        _imageView.frame = CGRectMake((CGRectGetWidth(self.view.frame)-cellWidth)/2, (cellHeight+10)*2+10, cellWidth, cellHeight);
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

@end
