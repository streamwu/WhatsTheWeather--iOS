//
//  DetailViewController.m
//  WhatsTheWeather
//
//  Created by StreamWu on 2/28/14.
//  Copyright (c) 2014 Stream Wu. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@property (strong, nonatomic) NSMutableDictionary *res;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        //[self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.cityName.text = [[self.detailItem description] stringByAppendingString:@", USA"];
        
        NSString *sun = [NSString stringWithFormat:@"sunrise: %@    sunset: %@", [[_res objectForKey:@"sys"] objectForKey:@"sunrise"], [[_res objectForKey:@"sys"] objectForKey:@"sunset"]];
        NSString *temp = [NSString stringWithFormat:@"temp_max: %@    temp_min: %@", [[_res objectForKey:@"main"] objectForKey:@"temp_max"], [[_res objectForKey:@"main"] objectForKey:@"temp_min"]];
        NSString *cloudCover = [NSString stringWithFormat:@"clouds: all =  %@", [[_res objectForKey:@"clouds"] objectForKey:@"all"]];
        NSString *precipitation = [NSString stringWithFormat:@"humidity: %@", [[_res objectForKey:@"main"] objectForKey:@"humidity"]];
        self.info1.text = sun;
        self.info2.text = temp;
        self.info3.text = cloudCover;
        self.info4.text = precipitation;
        
        CLLocationCoordinate2D coordinate;
        coordinate.latitude=[[[_res objectForKey:@"coord"] objectForKey:@"lat"] doubleValue];
        coordinate.longitude=[[[_res objectForKey:@"coord"] objectForKey:@"lon"] doubleValue];
        
        MKCoordinateSpan span;
        span.latitudeDelta=0.1;
        span.longitudeDelta=0.1;
        MKCoordinateRegion region;
        
        region.center = coordinate;
        region.span = span;
        
        [_map setMapType:MKMapTypeStandard];
        [_map setRegion:region];
    }
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
    //[self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(void)masterAction:(id)sender{
    NSString *loc = (NSString*)sender;
    NSString *url = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?q=%@&mode=json",
                     [[loc substringToIndex:[loc rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@" " withString:@""]];
    //NetWorking *download = [NetWorking sharedNetworking];
    //__block NSDictionary *result = [[NSDictionary alloc]init];
    
    [[NetWorking sharedNetworking] getWeatherForURL:url
                       success:^(NSDictionary *dic, NSError *error){
                           dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                               _res = [dic mutableCopy];
                               NSLog(@"city%@ --- %@",loc, _res);
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [self configureView];
                               });  
                           });
                           
                       }
                       failure:^(){
                           NSLog(@"fail");
                           [self showAlert];
                       }];
    
}

-(void) showAlert{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops..." message:nil delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    alertView.delegate = self;
    [alertView show];
}

@end