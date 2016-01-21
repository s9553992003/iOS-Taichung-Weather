//
//  WeatherTableViewCell.h
//  Taichung Weather
//
//  Created by ChenHelios on 2016/1/19.
//  Copyright © 2016年 ChenHelios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *labelWeekday;
@property(weak, nonatomic) IBOutlet UILabel *labelHighTemp;
@property(weak, nonatomic) IBOutlet UILabel *labelLowTemp;
@property(weak, nonatomic) IBOutlet UILabel *labelDate;
@property(weak, nonatomic) IBOutlet UILabel *labelText;

- (void)updateCurrentWeather:(NSString *)weekday
                 andHighTemp:(NSString *)highTemp
                  andLowTemp:(NSString *)lowTemp
                     andDate:(NSString *)date
                     andText:(NSString *)text;

@end
