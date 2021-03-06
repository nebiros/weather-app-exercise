//
//  WAESettingsViewController.h
//  WeatherAppExercise
//
//  Created by Juan Felipe Alvarez Saldarriaga on 2/21/15.
//  Copyright (c) 2015 Juan Felipe Alvarez Saldarriaga. All rights reserved.
//

@import UIKit;

@class WAESettingsViewController;

@protocol WAESettingsViewControllerDelegate <NSObject>

- (void)settingsViewController:(WAESettingsViewController *)settingsVC refreshAfterSettingsSaved:(BOOL)refresh;

@end

@interface WAESettingsViewController : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) NSObject <WAESettingsViewControllerDelegate> *delegate;

@end
