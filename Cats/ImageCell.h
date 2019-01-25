//
//  ImageCell.h
//  Cats
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *imageName;
@property (strong,nonatomic)PhotoData *photoData;

@end

NS_ASSUME_NONNULL_END
