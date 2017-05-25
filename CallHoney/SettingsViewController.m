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

@interface SettingsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, copy) NSString *currentImageName;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView];
    
    self.title = @"选择背景";
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
    return CGSizeMake(screenWidth/2-10, screenWidth/2+30.0);
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

#pragma mark - getters
- (NSArray *)imageNames {
    return @[@"building.jpeg", @"mountain.jpeg", @"pink.jpg", @"flower.jpeg", @"mosaic.jpeg", @"star.jpeg", @"fuji.jpeg", @"balloon.jpeg"];
}

@end
