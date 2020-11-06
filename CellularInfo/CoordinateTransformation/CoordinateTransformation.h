//  Created by MLS on 15/12/22.
//  Copyright © 2015年 MLS. All rights reserved.
//

#ifndef CoordinateTransformation_h
#define CoordinateTransformation_h


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
 
@interface CoordinateTransformation : NSObject
 
/**
 *    @brief    判断是否在中国
 *
 *    @param     location     世界标准地理坐标(WGS-84)
 *
 *    @return    中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;
 
 
/**
 *    @brief    世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *    @param     location     世界标准地理坐标(WGS-84)
 *
 *    @return    中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location;
 
 
/**
 *    @brief    中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *    @param     location     中国国测局地理坐标（GCJ-02）
 *
 *    @return    世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location;
 
 
/**
 *    @brief    世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *
 *    @param     location     世界标准地理坐标(WGS-84)
 *
 *    @return    百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location;
 
 
/**
 *    @brief    中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *    @param     location     中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *    @return    百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location;
 
 
/**
 *    @brief    百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *    @param     location     百度地理坐标（BD-09)
 *
 *    @return    中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location;
 
 
/**
 *    @brief    百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *    @param     location     百度地理坐标（BD-09)
 *
 *    @return    世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location;
 
@end

#endif /* CoordinateTransformation_h */
