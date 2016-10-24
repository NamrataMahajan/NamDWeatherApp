//
//  ViewController.h
//  NamDWeatherApp
//
//  Created by Namrata on 18/10/16.
//  Copyright © 2016 Namrata Mahajan. All rights reserved.
//
#define kweatherApiKey @"260cfdf224bce79e0ab735fab0666c50"
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    CLLocationManager *locationManager;
    NSString *kLatitude;
    NSString *kLongitude;
    NSMutableArray *forecast;
//     NSString *data;
}
@property (strong, nonatomic) IBOutlet UILabel *City;

@property (strong, nonatomic) IBOutlet UILabel *Temperature;

@property (strong, nonatomic) IBOutlet UILabel *Condition;
- (IBAction)StartAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@end

