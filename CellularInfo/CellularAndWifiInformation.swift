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

final class CellularAndWifiInformation {
    
    var carrierName: String = ""
    var radioAccessTech: String = ""
    var isWiFiConnected: Bool = false
    var ssid: String?
    var isConnectedToVpn: Bool {
        if let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? Dictionary<String, Any>,
            let scopes = settings["__SCOPED__"] as? [String:Any] {
            for (key, _) in scopes {
             if key.contains("tap") || key.contains("tun") || key.contains("ppp") || key.contains("ipsec") {
                    return true
                }
            }
        }
        return false
    }
    
    init() {
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
