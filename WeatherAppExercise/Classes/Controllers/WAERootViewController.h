//
//  RootViewController.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/16/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import UIKit;
@import MapKit;

#import "WAESettingsViewController.h"

@interface WAERootViewController : UIViewController <CLLocationManagerDelegate, UIViewControllerTransitioningDelegate, WAESettingsViewControllerDelegate>

@property (nonatomic) NSString *query;

@end

