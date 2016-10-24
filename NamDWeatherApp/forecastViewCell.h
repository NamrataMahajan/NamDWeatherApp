//
//  forecastViewCell.h
//  NamDWeatherApp
//
//  Created by Namrata on 20/10/16.
//  Copyright © 2016 Namrata Mahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface forecastViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *MaximummTemp;
@property (strong, nonatomic) IBOutlet UILabel *minimumTemp;

@end
