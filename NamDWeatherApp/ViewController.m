//
//  ViewController.m
//  NamDWeatherApp
//
//  Created by Namrata on 18/10/16.
//  Copyright © 2016 Namrata Mahajan. All rights reserved.
//

#import "ViewController.h"
#import "forecastViewCell.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   // day=@[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    forecast = [[NSMutableArray alloc]init];
    self.myTableView.separatorColor = [UIColor clearColor];
    
//[self startlocating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startlocating {
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
    
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currentlocation = [locations lastObject];
    
    NSLog(@"Latitude : %f",currentlocation.coordinate.latitude);
    NSLog(@"Longitude : %f",currentlocation.coordinate.longitude);
    
    kLatitude = [NSString stringWithFormat:@"%f",currentlocation.coordinate.latitude];
    kLongitude = [NSString stringWithFormat:@"%f",currentlocation.coordinate.longitude];
    [self getcurrentWeatherDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kweatherApiKey];
    if (currentlocation != nil) {
        [locationManager stopUpdatingLocation];
    }
    [self getcurrentWeatherDataWithLatitude:kLatitude.intValue longitude:kLongitude.intValue APIKey:kweatherApiKey];
    
    
    [self getForecastDataWithLatitude:kLatitude.doubleValue longitude:kLongitude.doubleValue APIKey:kweatherApiKey];
}

-(void)getForecastDataWithLatitude:(double)latitude
                         longitude:(double)longitude
                            APIKey:(NSString *)key {
    NSString *urlString =[NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&cnt=7&mode=json&appid=%@",latitude,longitude,key];
    NSLog(@"%@",urlString);
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession =[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    
    
    
    
    
    
    
    
    
    
    
    
    NSURLSessionDataTask *task = [mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            
        }
        else{
            if(response){
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if(httpResponse.statusCode == 200)
                {
                    if (data) {
                        NSError *error;
                        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if(error){
                            
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUIWithForecastDictionary:) withObject:jsonDictionary waitUntilDone:NO];
                        }
                    }
                }
            }
        }
    }];
    [task resume];
}

    
    
    
    
    
    

-(void)updateUIWithForecastDictionary: (NSDictionary *)forecastDictionary
{
    NSArray *list = [forecastDictionary valueForKey:@"list"];
    
    NSLog(@"%@",list);
    for (NSDictionary *weatherDetail in list) {
        NSString *dt =[NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"dt"]];
        NSString *maximum = [NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.max"]];
        maximum = [NSString stringWithFormat:@"maximum : %d °C",maximum.intValue];
        
        
        NSString *minimum =[NSString stringWithFormat:@"%@",[weatherDetail valueForKeyPath:@"temp.min"]];
        minimum= [NSString stringWithFormat:@"minimum : %d °C",minimum.intValue];
        NSDictionary *tempDic = @{
                                  @"maximum" : maximum,
                                  @"minimum" : minimum,
                                  @"dt"  : dt
                                  };
        NSLog(@"%@",tempDic);
        [forecast addObject:tempDic];
        
    }
    if (forecast.count > 0) {
        [self.myTableView reloadData];
    }
}



//-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
//    NSLog(@"%@",error.localizedDescription);
//    
//}
-(void)getcurrentWeatherDataWithLatitude:(double) latitude
                               longitude:(double) longitude
                                  APIKey:(NSString *)key {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@",latitude,longitude,key];
    
    NSLog(@"%@",urlString);
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLSession *mySession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task =[mySession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //alert
        }
        else{
            if (response) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse.statusCode == 200) {
                    if (data) {
                        //start json parsing
                        NSError *error;
                        NSDictionary *jsonDictionary =[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                        if (error) {
                            //alert
                        }
                        else{
                            [self performSelectorOnMainThread:@selector(updateUI:) withObject:jsonDictionary waitUntilDone:NO];
                            
                        }
                    }
                    else {
                        //alert
                    }}
                else{
                    //alert
                }
            }
            else{
                //alert
            }
        }
        
        
    }];
    [task resume];
}
-(void)updateUI:(NSDictionary *)resultDictionary {
    NSLog(@"%@",resultDictionary);
    
    NSString *temperature = [NSString stringWithFormat:@"%@",[resultDictionary valueForKeyPath:@"main.temp"]];
    NSLog(@"\n\nTEMPERATURE BEFORE : %@",temperature);
    int temp = temperature.intValue;
    
    temperature =[NSString stringWithFormat:@"%d °C",temp];
    NSLog(@"\n\nTEMPERATURE AFTER: %@",temperature);
    NSArray *weather = [resultDictionary valueForKey:@"weather"];
    NSLog(@"%@",weather);
    NSDictionary *weatherDictionary = weather.firstObject;
    
    NSString *condition = [NSString stringWithFormat:@"%@",[weatherDictionary valueForKey:@"description"]];
    
    NSLog(@"%@",condition);
    
    NSString *city =[NSString stringWithFormat: @"%@",[resultDictionary valueForKey:@"name"]];
    
    self.City.text =city;
    self.Temperature.text = temperature;
    self.Condition.text = condition.capitalizedString;
    
    
}



- (IBAction)StartAction:(id)sender {
    //[locationManager startUpdatingHeading];
    
    [self startlocating];
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return forecast.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDic = [forecast objectAtIndex:indexPath.row];
    //[tableView separatorColor:[UIColor clearColor]];
    NSString *dt  =[tempDic valueForKey:@"dt"];
    NSLog(@"%@",dt);
    NSTimeInterval time = dt.doubleValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"%@",date);
    NSDateFormatter *dateformatter =[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"dd MMM yyyy HH:mm a Z EEEE"];
    NSString *day =[dateformatter stringFromDate:date];
    NSLog(@"%@",day);
    
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"forcast_cell"];
    cell.textLabel.text =day;
    cell.detailTextLabel.text =[[[tempDic valueForKey:@"maximum"]stringByAppendingString:@" "]stringByAppendingString:[tempDic valueForKey:@"minimum" ]];
    
    
    return cell;
    
    
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height/7;
}

@end
