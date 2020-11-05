//
//  ViewController.h
//  DTMHeatMapExample
//
//  Created by Bryan Oltman on 1/7/15.
//  Copyright (c) 2015 Dataminr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

