//
//  ViewController.m
//  Cats
//
//  Created by Spencer Symington on 2019-01-24.
//  Copyright © 2019 Spencer Symington. All rights reserved.
//

#import "ViewController.h"
#import "ImageCell.h"
#import "PhotoData.h"
#import "DetailsViewController.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (strong,nonatomic)NSMutableArray<PhotoData*> *photoDataArray;

@property (strong,nonatomic)UICollectionViewFlowLayout *myLayout;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self setUpLayout];
    self.collectionView.collectionViewLayout = self.myLayout;
    
    
    //get the url
    [self getImagesWithTag:@"dog"];
    
}
-(void)getImagesWithTag:(NSString*)tag{
    self.photoDataArray = [[NSMutableArray alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=93fd6c96963fd57630a83037c18d735e&tags=%@",tag ];
    NSURL *url = [NSURL URLWithString:urlString]; // 1
    
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
            
            PhotoData *photoData = [[PhotoData alloc]init];
            //
            NSString *urlString = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",photo[@"farm"],photo[@"server"],photo[@"id"],photo[@"secret"]];
            
            
            photoData.url = urlString;
            photoData.imageName = photo[@"title"];
            [self.photoDataArray addObject:photoData];
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
    self.myLayout.itemSize = CGSizeMake(190, 230);
    self.myLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.myLayout.minimumLineSpacing = 20;
    self.myLayout.minimumInteritemSpacing = 5;
    
    self.myLayout.headerReferenceSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), 80);
}
- (IBAction)pressedSearch:(UIButton*)sender {
    NSLog(@"pressed search");
    [self getImagesWithTag:self.searchField.text];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photoDataArray.count;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell was selected");
    [self performSegueWithIdentifier:@"toDetails" sender:self.photoDataArray[indexPath.row]];
    
    return YES;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //TODO make sure is the right class
    DetailsViewController *details = (DetailsViewController*)segue.destinationViewController;
    details.photoData = (PhotoData*)sender;
    
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView
                                   cellForItemAtIndexPath:(nonnull NSIndexPath*)indexPath{
    ImageCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    [cell prepareForReuse];
    PhotoData *photoData = self.photoDataArray[indexPath.row];
    cell.imageName.text = photoData.imageName;
    cell.photoData = photoData;
    if(photoData.image != nil){
        cell.image.image = photoData.image;
        return cell;
    }
    
    NSURL *url = [NSURL URLWithString:self.photoDataArray[indexPath.row].url]; // 1
    
    
    
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
        photoData.image = image;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // This will run on the main queue
            
            cell.image.image = image; // 4
        }];
    
    
    }];
    
    [downloadTask resume];
        
    return cell;

}
@end
