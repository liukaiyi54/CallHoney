//
//  ImageCollectionViewCell.m
//  CallHoney
//
//  Created by Michael on 23/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "ImageCollectionViewCell.h"

#import <ChameleonFramework/Chameleon.h>

@interface ImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 4.0f;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderWidth = 2.0f;
        self.layer.borderColor = [UIColor flatMintColor].CGColor;
    } else {
        self.layer.borderWidth = 0.0f;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

@end
