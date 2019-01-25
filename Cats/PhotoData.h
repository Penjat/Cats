//
//  PhotoData.h
//  Cats
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoData : NSObject

@property (strong,nonatomic)NSString *url;
@property (strong,nonatomic)NSString *imageName;
@property (strong,nonatomic)UIImage *image;

@end

NS_ASSUME_NONNULL_END
