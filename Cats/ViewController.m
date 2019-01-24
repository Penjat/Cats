//
//  ViewController.m
//  Cats
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic)NSMutableArray<NSString*> *urlArray;//an array of all the url data

@property (strong,nonatomic)UICollectionViewFlowLayout *myLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.urlArray = [[NSMutableArray alloc]init];
    [self setUpLayout];
    self.collectionView.collectionViewLayout = self.myLayout;
    
    
    //get the url
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=93fd6c96963fd57630a83037c18d735e&tags=cat"]; // 1
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        NSDictionary *allCatData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError]; // 2
        
        if (jsonError) { // 3
            // Handle the error
            NSLog(@"jsonError: %@", jsonError.localizedDescription);
            return;
        }
        
        
        //create 1 url
        NSDictionary *catDictionary =  allCatData[@"photos"][@"photo"];
        NSLog(@"cat dictionary = %@",catDictionary);
        
        for(NSDictionary *photo in catDictionary){
            
            //
            NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",photo[@"farm"],photo[@"server"],photo[@"id"],photo[@"secret"]];
            [self.urlArray addObject:urlString];
        }
        

        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            // This will run on the main queue
                            [self.collectionView reloadData];
                        }];
    }];
    
    [dataTask resume]; // 6
    
}
-(void)setUpLayout{
    self.myLayout = [[UICollectionViewFlowLayout alloc] init];
    self.myLayout.itemSize = CGSizeMake(190, 190);
    self.myLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.myLayout.minimumLineSpacing = 20;
    self.myLayout.minimumInteritemSpacing = 5;
    
    self.myLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 80);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.urlArray.count;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath*)indexPath{
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    
    NSURL *url = [NSURL URLWithString:self.urlArray[indexPath.row]]; // 1
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url]; // 2
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration]; // 3
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration]; // 4
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) { // 1
            // Handle the error
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSData *data = [NSData dataWithContentsOfURL:location];
        UIImage *image = [UIImage imageWithData:data]; // 2
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            
            cell.image.image = image; // 4
        }];
    
    
    }];
    
    [downloadTask resume];
        
    return cell;

}
@end
