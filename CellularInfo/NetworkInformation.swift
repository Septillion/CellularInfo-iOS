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

final class NetworkInformation: ObservableObject {
    
    @Published var pingNumberAveraged : Double = 0
    @Published var pingNumberDouble : [Double] = []
    @Published var pingNumberCurrent: Double = 0
    
    var interfaceType: String = ""
    @Published var carrierName: String = ""
    @Published var radioAccessTech: String = ""
    var reachability: String = "Internet Error"
    @Published var isWiFiConnected: Bool = false
    
    @Published var pingNumberInMilisecond: Double?{
        willSet{
            objectWillChange.send()
        }
    }
    
    init() {
        
        for type in NWPathMonitor().currentPath.availableInterfaces{
            if (interfaceType != ""){
                interfaceType += " "
            }
            interfaceType += "\(type)"
        }
        
        let monitorWiFi = NWPathMonitor(requiredInterfaceType: .wifi)
        monitorWiFi.pathUpdateHandler = {
            path in
            if path.status == .satisfied{
                self.isWiFiConnected = true
            }else{
                self.isWiFiConnected = false
            }
        }
        
        if isWiFiConnected {
            carrierName = "WiFi: \(getWiFiName() ?? "Connected")"
        }else{
            let networkInfo = CTTelephonyNetworkInfo()
            if let dataServiceIdentifier = networkInfo.dataServiceIdentifier,
               let allProviders = networkInfo.serviceSubscriberCellularProviders,
               let allRadioAccessTechs = networkInfo.serviceCurrentRadioAccessTechnology,
               let currentProvider = allProviders[dataServiceIdentifier],
               let currentRadioAccessTech = allRadioAccessTechs[dataServiceIdentifier]
            {
                self.carrierName = "活跃：\(currentProvider.carrierName ?? "Unknown Carrier") \(currentRadioAccessTech.replacingOccurrences(of: "CTRadioAccessTechnology", with: ""))"
                
            }
        }
        
        PlainPing.ping("www.qq.com", withTimeout: 10.0, completionBlock: {
            (timeElapsed:Double?, error:Error?) in
            if let latency = timeElapsed {
                self.pingNumberInMilisecond = latency
                print(latency)
            }
            if let error = error {
                print("error: \(error.localizedDescription)")
            }
        })
    }
    
    func getWiFiName() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
}
