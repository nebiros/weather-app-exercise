//
//  WAECityCollectionViewCell.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/20/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAECityCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cityImageView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@end
