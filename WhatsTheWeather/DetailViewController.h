//
//  DetailViewController.h
//  WhatsTheWeather
//
//  Created by StreamWu on 2/28/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MasterDetailProtocol.h"
#import "NetWorking.h"



@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,MasterDetailProtocol>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *info1;
@property (weak, nonatomic) IBOutlet UILabel *info2;
@property (weak, nonatomic) IBOutlet UILabel *info3;
@property (weak, nonatomic) IBOutlet UILabel *info4;
@property (weak, nonatomic) IBOutlet MKMapView *map;


@end
