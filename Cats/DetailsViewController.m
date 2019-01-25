//
//  DetailsViewController.m
//  Cats
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imageView.image = self.photoData.image;
    self.scrollView.delegate = self;
    self.pageTitle.title = self.photoData.imageName;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    //check to see if we need to show the hud
    
    return self.imageView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
