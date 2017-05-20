//
//  TemplatesViewController.m
//  CallHoney
//
//  Created by Michael on 09/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "TemplatesViewController.h"
#import <ChameleonFramework/Chameleon.h>

#import "DataModel.h"
#import "Template.h"

#import "CollectionViewCell.h"

static NSString *const kCollectionViewCell = @"kCollectionViewCell";

@interface TemplatesViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) BOOL showDeleteButton;

@end

@implementation TemplatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手势号码对照表";
    [self configureCollectionView];
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor flatWhiteColor]}];
    [self.navigationController setHidesNavigationBarHairline:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor flatMintColor];
    self.navigationController.navigationBar.tintColor = [UIColor flatWhiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.showDeleteButton = NO;
    if ([DataModel sharedInstance].templates.count == 0) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit"] style:UIBarButtonItemStylePlain target:self action:@selector(didTapEdit:)];
        [item setImageInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        self.navigationItem.rightBarButtonItem = item;
    }
    
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate & etc
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [DataModel sharedInstance].templates.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCell forIndexPath:indexPath];
    cell.delegate = self;
    
    NSDictionary *templates = [DataModel sharedInstance].templates;
    Template *template = templates.allValues[indexPath.row];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent: template.imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile: filePath];
    cell.image = image;
    cell.num = template.phoneNumber;
    cell.hideDeleteButton = !self.showDeleteButton;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = CGRectGetWidth(self.view.frame);
    return CGSizeMake(screenWidth/2-10, screenWidth/2+30.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

- (void)deleteCell:(CollectionViewCell *)cell {
    [self.collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSString *key = [DataModel sharedInstance].templates.allKeys[indexPath.row];
        [[DataModel sharedInstance].templates removeObjectForKey:key];
        [[DataModel sharedInstance] saveTemplates];
        
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.collectionView reloadData];
        if ([DataModel sharedInstance].templates.count == 0) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }];
}

#pragma mark -
- (void)configureCollectionView {
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    NSString *nibName = NSStringFromClass([CollectionViewCell class]);
    [self.collectionView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellWithReuseIdentifier:kCollectionViewCell];
}

- (void)didTapEdit:(UIBarButtonItem *)sender {
    self.showDeleteButton = !self.showDeleteButton;
    [sender setImage:[UIImage imageNamed:self.showDeleteButton ? @"checked" : @"edit"]];
    
    [self.collectionView reloadData];
}

@end
