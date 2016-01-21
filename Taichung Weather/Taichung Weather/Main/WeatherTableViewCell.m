//
//  WeatherTableViewCell.m
//  Taichung Weather
//
//  Created by ChenHelios on 2016/1/19.
//  Copyright © 2016年 ChenHelios. All rights reserved.
//

#import "WeatherTableViewCell.h"

@implementation WeatherTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)updateCurrentWeather:(NSString *)weekday
                 andHighTemp:(NSString *)highTemp
                  andLowTemp:(NSString *)lowTemp
                     andDate:(NSString *)date
                     andText:(NSString *)text {
    self.labelWeekday.text = weekday;
    self.labelHighTemp.text =
    [NSString stringWithFormat:@"%@%@%@", @"High:", highTemp, @"°F"];
    self.labelLowTemp.text =
    [NSString stringWithFormat:@"%@%@%@", @"Low :", lowTemp, @"°F"];
    self.labelDate.text = date;
    self.labelText.text = text;
}

@end
