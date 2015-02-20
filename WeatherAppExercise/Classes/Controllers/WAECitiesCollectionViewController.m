//
//  WAECitiesCollectionViewController.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/20/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAECitiesCollectionViewController.h"

#import "WAERequestsHelper.h"
#import "WAECityCollectionViewCell.h"

@interface WAECitiesCollectionViewController ()

@property (nonatomic) NSArray *cities;

@end

@implementation WAECitiesCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getCities];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.cities.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WAECityCollectionViewCell *cell = (WAECityCollectionViewCell *) [collectionView dequeueReusableCellWithReuseIdentifier:kWAECollectionCellCity forIndexPath:indexPath];
    
    NSDictionary *city = self.cities[indexPath.row];
    cell.cityNameLabel.text = [NSString stringWithFormat:@"%@, %@", city[@"city"], city[@"country"]];
    
    [WAERequestsHelper getExerciseCityPhotoWithImageURL:city[@"imageURL"] andBlock:^(BOOL succeeded, UIImage *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return;
        }
        
        if (result) {
            cell.cityImageView.image = result;
            [cell setNeedsLayout];
            [cell layoutIfNeeded];
        }
    }];
    
    return cell;
}

#pragma mark - Private

- (void)getCities
{
    [WAERequestsHelper getExerciseCitiesWithBlock:^(BOOL succeeded, NSDictionary *result, NSError *error) {
        if (error) {
            NSString *errorMessage = [NSString stringWithFormat:@"\n%@\n%@", [error localizedDescription], error.userInfo];
            NSLog(@"[ERROR] - %s: %@",
                  __PRETTY_FUNCTION__,
                  errorMessage);
            
            return;
        }
        
        if (result) {
            self.cities = (NSArray *) result[@"cities"];
            [self.collectionView reloadData];
        }
    }];
}

@end
