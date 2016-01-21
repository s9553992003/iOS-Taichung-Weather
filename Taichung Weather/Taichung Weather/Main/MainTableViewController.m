//
//  MainTableViewController.m
//  Taichung Weather
//
//  Created by ChenHelios on 2016/1/19.
//  Copyright © 2016年 ChenHelios. All rights reserved.
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

static const NSInteger numberOfSection = 2;
static const NSInteger hightForCurrentRow = 90;
static const NSInteger numberOfRowInWeekSection = 5;

@implementation MainTableViewController

- (void)viewDidLoad {
    self.isWeekWeatherGot = NO;
    [super viewDidLoad];
    [self initArray];
    [self initUI];
    [self updateWeatherFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSection;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case MainTableSectionIndexCurrent:
            return 1;
            break;
        case MainTableSectionIndexWeek:
            return [self.weekdayArray count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case MainTableSectionIndexCurrent: {
            [self.tableView registerNib:
             [UINib nibWithNibName:@"WeatherTableViewCurrentCell"
                            bundle:nil]
                 forCellReuseIdentifier:@"WeatherTableViewCurrentCellId"];
            WeatherTableViewCurrentCell *cell = [tableView
                                                 dequeueReusableCellWithIdentifier:@"WeatherTableViewCurrentCellId"];
            if (cell == nil) {
                cell = [[WeatherTableViewCurrentCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:@"WeatherTableViewCurrentCellId"];
            }
            [cell updateCurrentWeather:self.currentDate
                               andTemp:self.currentTemp
                               andText:self.currentText];
            return cell;
            break;
        }
        case MainTableSectionIndexWeek: {
            [self.tableView registerNib:[UINib nibWithNibName:@"WeatherTableViewCell"
                                                       bundle:nil]
                 forCellReuseIdentifier:@"WeatherTableViewCellId"];
            WeatherTableViewCell *cell = [tableView
                                          dequeueReusableCellWithIdentifier:@"WeatherTableViewCellId"];
            if (cell == nil) {
                cell = [[WeatherTableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:@"WeatherTableViewCellId"];
            }
            if (self.isWeekWeatherGot) {
                [cell
                 updateCurrentWeather:[self.weekdayArray objectAtIndex:indexPath.row]
                 andHighTemp:[self.weekHighTempArray
                              objectAtIndex:indexPath.row]
                 andLowTemp:[self.weekLowTempArray
                             objectAtIndex:indexPath.row]
                 andDate:[self.weekDateArray
                          objectAtIndex:indexPath.row]
                 andText:[self.weekTextArray
                          objectAtIndex:indexPath.row]];
            }
            
            return cell;
            break;
        }
            
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return hightForCurrentRow;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case MainTableSectionIndexCurrent:
            return @"Now";
            break;
        case MainTableSectionIndexWeek:
            return @"This week";
            break;
        default:
            return nil;
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case MainTableSectionIndexCurrent:
            return NO;
            break;
        case MainTableSectionIndexWeek:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
    //判斷編輯表格的類型為「刪除」
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"index : %d", indexPath.row);
        //刪除對應的陣列元素
        [self.weekdayArray removeObjectAtIndex:indexPath.row];
        [self.weekDateArray removeObjectAtIndex:indexPath.row];
        [self.weekHighTempArray removeObjectAtIndex:indexPath.row];
        [self.weekLowTempArray removeObjectAtIndex:indexPath.row];
        [self.weekTextArray removeObjectAtIndex:indexPath.row];
        
        for (int i = 0; i < [self.weekdayArray count]; i++) {
            NSLog(@"%d = %@", i, [self.weekdayArray objectAtIndex:i]);
        }
        //刪除對應的表格項目
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
        // withRowAnimation:UITableViewRowAnimationRight];
        
        //如果該分類已沒有任何項目則刪除整個分類
        /*if ([[self.weekdayArray objectAtIndex:indexPath.section] count] == 0) {
         [self.weekdayArray removeObjectAtIndex:indexPath.section];
         [self.weekDateArray removeObjectAtIndex:indexPath.section];
         [self.weekHighTempArray removeObjectAtIndex:indexPath.section];
         [self.weekLowTempArray removeObjectAtIndex:indexPath.section];
         [self.weekTextArray removeObjectAtIndex:indexPath.section];
         
         [tableView deleteSections:[NSIndexSet
         indexSetWithIndex:indexPath.section]
         withRowAnimation:UITableViewRowAnimationFade];
         }*/
    }
    [tableView reloadData];
}

- (void)initArray {
    self.weekdayArray = [[NSMutableArray alloc] init];
    self.weekDateArray = [[NSMutableArray alloc] init];
    self.weekHighTempArray = [[NSMutableArray alloc] init];
    self.weekLowTempArray = [[NSMutableArray alloc] init];
    self.weekTextArray = [[NSMutableArray alloc] init];
}

- (void)initUI {
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                               target:self
                               action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)updateWeatherFromServer {
    NSURL *URL = [NSURL URLWithString:YAHOO_WEATHER_URL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {
             NSDictionary *query = [responseObject valueForKey:@"query"];
             NSDictionary *results = [query valueForKey:@"results"];
             NSDictionary *channel = [results valueForKey:@"channel"];
             NSDictionary *item = [channel valueForKey:@"item"];
             [self getCurrentWeather:item];
             [self getWeekWeather:item];
             [self.tableView reloadData];
         }
         failure:^(NSURLSessionTask *operation, NSError *error){
         }];
}
- (void)getCurrentWeather:(NSDictionary *)response {
    NSDictionary *condition = [response valueForKey:@"condition"];
    self.currentDate = [condition valueForKey:@"date"];
    self.currentTemp = [condition valueForKey:@"temp"];
    self.currentText = [condition valueForKey:@"text"];
}

- (void)getWeekWeather:(NSDictionary *)response {
    for (int i = 0; i < numberOfRowInWeekSection; i++) {
        [self.weekdayArray
         addObject:[[response valueForKey:@"forecast"][i] objectForKey:@"day"]];
        [self.weekDateArray
         addObject:[[response valueForKey:@"forecast"][i] objectForKey:@"date"]];
        [self.weekHighTempArray
         addObject:[[response valueForKey:@"forecast"][i] objectForKey:@"high"]];
        [self.weekLowTempArray
         addObject:[[response valueForKey:@"forecast"][i] objectForKey:@"low"]];
        [self.weekTextArray
         addObject:[[response valueForKey:@"forecast"][i] objectForKey:@"text"]];
    }
    self.isWeekWeatherGot = YES;
}

- (void)refresh:(id)sender {
    [self.weekdayArray removeAllObjects];
    [self.weekDateArray removeAllObjects];
    [self.weekHighTempArray removeAllObjects];
    [self.weekLowTempArray removeAllObjects];
    [self.weekTextArray removeAllObjects];
    [self updateWeatherFromServer];
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView
 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView
 dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#>
 forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath
 *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath]
 withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the
 array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath
 *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath
 *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little
 preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
