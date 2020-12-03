//
//  FinalDataStructure.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//

import Foundation
import CoreLocation
import CloudKit

struct FinalDataStructure {
    
    var AveragedPingLatency: Double
    var DeviceName: String
    var Location: CLLocationCoordinate2D
    var MobileCarrier: String
    var RadioAccessTechnology: String
    
    enum index {
        case DeviceName
        case MobileCarrier
        case RadioAccessTechnology
    }
    
    func convert() -> CKRecord{
        let record = CKRecord(recordType: "CellularInfo")
        record.setObject(self.AveragedPingLatency as __CKRecordObjCValue, forKey: "AveragedPingLatency")
        record.setObject(self.DeviceName as __CKRecordObjCValue, forKey: "DeviceName")
        record.setObject(CLLocation(latitude: self.Location.latitude , longitude: self.Location.longitude) as __CKRecordObjCValue, forKey: "Location")
        record.setObject(self.MobileCarrier as __CKRecordObjCValue, forKey: "MobileCarrier")
        record.setObject(self.RadioAccessTechnology as __CKRecordObjCValue, forKey: "RadioAccessTechnology")
        return record
    }
    
    init(record:CKRecord){
        self.AveragedPingLatency = record.object(forKey: "AveragedPingLatency") as! Double
        self.DeviceName = record.object(forKey: "DeviceName") as! String
        self.Location = (record.object(forKey: "Location") as! CLLocation).coordinate
        self.MobileCarrier = record.object(forKey: "MobileCarrier") as! String
        self.RadioAccessTechnology = record.object(forKey: "RadioAccessTechnology") as! String        
    }
    
    init(fillWithRandom: Bool) {
        self.AveragedPingLatency = 0
        DeviceName = ""
        Location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        MobileCarrier = ""
        RadioAccessTechnology = ""
        
        if fillWithRandom{
            
            self.AveragedPingLatency = Double.random(in: 0...300)
            if Bool.random() && Bool.random() && Bool.random() && Bool.random() && Bool.random(){
                self.AveragedPingLatency = 999999
            }
            self.DeviceName = "Random iPhone \(Int.random(in: 20...30))"
            self.Location = CLLocationCoordinate2D(latitude: Double.random(in: 0...300), longitude: Double.random(in: 0...300))
            self.MobileCarrier = ["Random Carrier","Random Carrier 2","Random Carrier 3"].randomElement()!
            self.RadioAccessTechnology = ["6G","7G","8G","nmWave"].randomElement()!
        }
        
    }
    
    init(AveragedPingLatency: Double, DeviceName: String, Location: CLLocationCoordinate2D, MobileCarrier: String, RadioAccessTechnology: String){
        self.AveragedPingLatency = AveragedPingLatency
        self.DeviceName = DeviceName
        self.Location = Location
        self.MobileCarrier = MobileCarrier
        self.RadioAccessTechnology = RadioAccessTechnology
    }
    
}

