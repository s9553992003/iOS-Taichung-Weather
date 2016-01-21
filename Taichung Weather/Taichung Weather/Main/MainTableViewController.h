//
//  MainTableViewController.h
//  Taichung Weather
//
//  Created by ChenHelios on 2016/1/19.
//  Copyright © 2016年 ChenHelios. All rights reserved.
//

#define YAHOO_WEATHER_URL                                                    \
@"https://query.yahooapis.com/v1/public/"                                  \
@"yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(" \
@"select%20woeid%20from%20geo.places(1)%20where%20text%3D%22Taichung%" \
@"20City%2C%20Taiwan%20(R.O.C.)%22)&format=json&env=store%3A%2F%"      \
@"2Fdatatables.org%2Falltableswithkeys"

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "WeatherTableViewCurrentCell.h"
#import "WeatherTableViewCell.h"

typedef NS_ENUM(NSInteger, MainTableSectionIndex) {
    MainTableSectionIndexCurrent = 0,
    MainTableSectionIndexWeek,
};

@interface MainTableViewController : UITableViewController

@property(strong, nonatomic) NSString *currentDate;
@property(strong, nonatomic) NSString *currentTemp;
@property(strong, nonatomic) NSString *currentText;

@property(strong, nonatomic) NSMutableArray *weekdayArray;
@property(strong, nonatomic) NSMutableArray *weekDateArray;
@property(strong, nonatomic) NSMutableArray *weekHighTempArray;
@property(strong, nonatomic) NSMutableArray *weekLowTempArray;
@property(strong, nonatomic) NSMutableArray *weekTextArray;

@property(assign, nonatomic) BOOL isWeekWeatherGot;

@end
