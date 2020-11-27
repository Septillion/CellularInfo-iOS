//
//  Created by MLS on 15/12/22.
//  Copyright © 2015年 MLS. All rights reserved.
//
 
#import "CoordinateTransformation.h"
//#import <CoreLocation/CoreLocation.h>
 
#define LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0
 
#define LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0
 
#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293
// jzA = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
#define jzA 6378245.0
#define jzEE 0.00669342162296594323
 
@implementation CoordinateTransformation
 
 
//判断是不是在中国
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location
{
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}
 
+ (double)transformLat:(double)x BDLon:(double)y
{
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}
 
+ (double)transformLon:(double)x BDLon:(double)y
{
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}
 
+ (BOOL)outOfChina:(double)lat BDLon:(double)lon
{
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}
 
+ (CLLocationCoordinate2D)GCJ02Encrypt:(double)ggLat BDLon:(double)ggLon
{
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat BDLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)BDLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) BDLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}
 
+ (CLLocationCoordinate2D)GCJ02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D  gPt = [self GCJ02Encrypt:gjLat BDLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}
 
+ (CLLocationCoordinate2D)BD09Decrypt:(double)BDLat BDLon:(double)BDLon
{
    CLLocationCoordinate2D GCJPt;
    double x = BDLon - 0.0065, y = BDLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    GCJPt.longitude = z * cos(theta);
    GCJPt.latitude = z * sin(theta);
    return GCJPt;
}
 
+(CLLocationCoordinate2D)BD09Encrypt:(double)ggLat BDLon:(double)ggLon
{
    CLLocationCoordinate2D BDPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    BDPt.longitude = z * cos(theta) + 0.0065;
    BDPt.latitude = z * sin(theta) + 0.006;
    return BDPt;
}
 
 
+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location
{
    return [self GCJ02Encrypt:location.latitude BDLon:location.longitude];
}
 
+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location
{
    return [self GCJ02Decrypt:location.latitude gjLon:location.longitude];
}
 
 
+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D GCJ02Pt = [self GCJ02Encrypt:location.latitude
                                                  BDLon:location.longitude];
    return [self BD09Encrypt:GCJ02Pt.latitude BDLon:GCJ02Pt.longitude] ;
}
 
+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location
{
    return  [self BD09Encrypt:location.latitude BDLon:location.longitude];
}
 
+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location
{
    return [self BD09Decrypt:location.latitude BDLon:location.longitude];
}
 
+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location
{
    CLLocationCoordinate2D GCJ02 = [self BD09ToGCJ02:location];
    return [self GCJ02Decrypt:GCJ02.latitude gjLon:GCJ02.longitude];
}
 
@end
