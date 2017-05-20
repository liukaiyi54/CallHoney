//
//  CollectionViewCell.m
//  CallHoney
//
//  Created by Michael on 12/05/2017.
//  Copyright © 2017 Michael. All rights reserved.
//

#import "CollectionViewCell.h"

#import <ChameleonFramework/Chameleon.h>

@interface CollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation CollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderColor = [UIColor flatMintColor].CGColor;
    self.layer.borderWidth = 1.0f;
    self.layer.cornerRadius = 4.0f;
    
    [self.deleteButton addTarget:self action:@selector(didTapDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didTapDeleteButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(deleteCell:)]) {
        [self.delegate deleteCell:self];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

- (void)setNum:(NSString *)num {
    _num = [num copy];
    self.numLabel.text = _num;
}

- (void)setHideDeleteButton:(BOOL)hideDeleteButton {
    _hideDeleteButton = hideDeleteButton;
    if (_hideDeleteButton) {
        self.deleteButton.hidden = YES;
    } else {
        self.deleteButton.hidden = NO;
    }
}

@end
