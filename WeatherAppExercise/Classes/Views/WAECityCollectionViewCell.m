//
//  WAECityCollectionViewCell.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/20/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAECityCollectionViewCell.h"

@implementation WAECityCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.cityImageView.image = nil;
}

@end
