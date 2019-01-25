//
//  DetailsViewController.h
//  Cats
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import "ViewController.h"
#import "PhotoData.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : ViewController <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UINavigationItem *pageTitle;


@property (nonatomic,weak)PhotoData *photoData;

@end

NS_ASSUME_NONNULL_END
