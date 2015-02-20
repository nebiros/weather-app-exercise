//
//  WAECityCollectionViewCell.m
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/20/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

#import "WAECityCollectionViewCell.h"

@implementation WAECityCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGRect tmp = CGRectMake(0,
                            0,
                            CGRectGetWidth([UIScreen mainScreen].bounds),
                            CGRectGetHeight(self.cityImageView.bounds));
    UICollectionViewLayoutAttributes *attrs = [layoutAttributes copy];
    attrs.frame = tmp;
#ifdef DEBUG
    NSLog(@"%s, NSStringFromCGRect(attrs.frame), %@", __PRETTY_FUNCTION__, NSStringFromCGRect(attrs.frame));
#endif
    return attrs;
}

@end
