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
    var AveragedPingLatency: Double?
    var DeviceName: String?
    var Location: CLLocationCoordinate2D?
    var MobileCarrier: String?
    var RadioAccessTechnology: String?
    
    func populateWith(record: CKRecord) -> FinalDataStructure {
        var fds = FinalDataStructure()
        fds.AveragedPingLatency = record.object(forKey: "AveragedPingLatency") as? Double
        fds.DeviceName = record.object(forKey: "DeviceName") as? String
        fds.Location = (record.object(forKey: "Location") as? CLLocation)?.coordinate
        fds.MobileCarrier = record.object(forKey: "MobileCarrier") as? String
        fds.RadioAccessTechnology = record.object(forKey: "RadioAccessTechnology") as? String
        return fds
    }
    
    func convert() -> CKRecord{
        let record = CKRecord(recordType: "CellularInfo")
        record.setObject(self.AveragedPingLatency as! __CKRecordObjCValue, forKey: "AveragedPingLatency")
        record.setObject(self.DeviceName as! __CKRecordObjCValue, forKey: "DeviceName")
        if Location != nil {
            record.setObject(CLLocation(latitude: self.Location!.latitude , longitude: self.Location!.longitude) as __CKRecordObjCValue, forKey: "Location")
        }
        record.setObject(self.MobileCarrier as! __CKRecordObjCValue, forKey: "MobileCarrier")
        record.setObject(self.RadioAccessTechnology as! __CKRecordObjCValue, forKey: "RadioAccessTechnology")
        return record
    }
    
}
