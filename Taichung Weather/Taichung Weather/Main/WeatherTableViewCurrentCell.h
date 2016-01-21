//
//  WeatherTableViewCurrentCell.h
//  Taichung Weather
//
//  Created by ChenHelios on 2016/1/20.
//  Copyright © 2016年 ChenHelios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"

@interface WeatherTableViewCurrentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UILabel *labelTemp;
@property (weak, nonatomic) IBOutlet UILabel *labelText;


- (void)updateCurrentWeather:(NSString *)time andTemp:(NSString *)temp andText:(NSString *)text;
@end
