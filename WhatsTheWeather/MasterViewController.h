//
//  MasterViewController.h
//  WhatsTheWeather
//
//  Created by StreamWu on 2/28/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterDetailProtocol.h"


@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) id <MasterDetailProtocol> delegate;

@end
