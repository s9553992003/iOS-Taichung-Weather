//
//  WeatherTableViewCurrentCell.m
//  Taichung Weather
//
//  Created by ChenHelios on 2016/1/20.
//  Copyright © 2016年 ChenHelios. All rights reserved.
//

#import "WeatherTableViewCurrentCell.h"

@implementation WeatherTableViewCurrentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)updateCurrentWeather:(NSString *)time
                     andTemp:(NSString *)temp
                     andText:(NSString *)text {
    self.labelTime.text = time;
    self.labelTemp.text = [NSString stringWithFormat:@"%@%@", temp, @"°F"];
    self.labelText.text = text;
}
@end
