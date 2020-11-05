//
//  NetworkInformation.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/2.
//

import Foundation
import CoreTelephony
import Network
import SystemConfiguration.CaptiveNetwork

final class NetworkInformation {
    
    var carrierName: String = ""
    var radioAccessTech: String = ""
    var isWiFiConnected: Bool = false
    var ssid: String?
    
    init() {
        
        
        let monitorWiFi = NWPathMonitor(requiredInterfaceType: .wifi)
        monitorWiFi.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                self.isWiFiConnected = true
            }else{
                self.isWiFiConnected = false
            }
        }
        getWiFiName()
        aqquireCellularCarrierAndRadioAccessTech()
    }
    
    private func getWiFiName() {
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    isWiFiConnected = true
                    break
                }
            }
        }
    }
    
    private func aqquireCellularCarrierAndRadioAccessTech(){
        let networkInfo = CTTelephonyNetworkInfo()
        if let dataServiceIdentifier = networkInfo.dataServiceIdentifier,
           let allProviders = networkInfo.serviceSubscriberCellularProviders,
           let allRadioAccessTechs = networkInfo.serviceCurrentRadioAccessTechnology,
           let currentProvider = allProviders[dataServiceIdentifier],
           let currentRadioAccessTech = allRadioAccessTechs[dataServiceIdentifier]
        {
            self.carrierName = currentProvider.carrierName ?? "Unknown Carrier"
            self.radioAccessTech = currentRadioAccessTech.replacingOccurrences(of: "CTRadioAccessTechnology", with: "")
            
        }
    }
    
}
