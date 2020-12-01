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
    
    var AveragedPingLatency: Double = 0
    var DeviceName: String = ""
    var Location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var MobileCarrier: String = ""
    var RadioAccessTechnology: String = ""
    
    mutating func populateWith(record: CKRecord){
        self.AveragedPingLatency = record.object(forKey: "AveragedPingLatency") as! Double
        self.DeviceName = record.object(forKey: "DeviceName") as! String
        self.Location = (record.object(forKey: "Location") as! CLLocation).coordinate
        self.MobileCarrier = record.object(forKey: "MobileCarrier") as! String
        self.RadioAccessTechnology = record.object(forKey: "RadioAccessTechnology") as! String
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
    
    init(isRandom: Bool) {
        if isRandom{
            self.AveragedPingLatency = Double.random(in: 0...300)
        }
    }
    
}

