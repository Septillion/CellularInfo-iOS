//
//  ConverFinalDataStructureToWhateverDTMHeatMapWhats.m
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/6.
//

#import "ConverFinalDataStructureToWhateverDTMHeatMapWhats.h"

@end

@implementation ConverFinalDataStructureToWhateverDTMHeatMapWhats

+ (NSDictionary *) ConverFinalDataStructureToWhateverDTMHeatMapWhats:(CLLocationCoordinate2D *)coordinate
{
    NSMutableDictionary *ret = [NSMutableDictionary new];
    
    
    
    
    for (NSString *line in lines) {
        NSArray *parts = [line componentsSeparatedByString:@","];
        NSString *latStr = parts[0];
        NSString *lonStr = parts[1];
        
        CLLocationDegrees latitude = [latStr doubleValue];
        CLLocationDegrees longitude = [lonStr doubleValue];
        
        // For this example, each location is weighted equally
        double weight = 1;
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude
                                                          longitude:longitude];
        MKMapPoint point = MKMapPointForCoordinate(location.coordinate);
        NSValue *pointValue = [NSValue value:&point
                                withObjCType:@encode(MKMapPoint)];
        ret[pointValue] = @(weight);
    }
    
    return ret;
}

@end
