//
//  CollectionViewCell.h
//  CallHoney
//
//  Created by Michael on 12/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewCell;
@protocol CellDelegate <NSObject>

-(void)deleteCell:(CollectionViewCell *)cell;

@end

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <CellDelegate>delegate;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *num;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL hideDeleteButton;

@end
