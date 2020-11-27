//
//  InsightDataStructure.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/26.
//

import Foundation
import CloudKit

struct InsightDataStructure {
    
    // 更新日期
    var ModifiedAt: Date
    
    // 总数据量
    var NumberOfEntries: Int
    
    // 范围分布
    var NumberOfRangeBelowTierOne: Int
    var NumberOfRangeBetweenTierOneAndTwo: Int
    var NumberOfRangeAboveTierTwo: Int
    var NumberOfRangeError: Int
    
    // 平均 Ping 值
    var AveragePingDeviceModels: [String]
    var AveragePingLatencies: [Double]
    
    // 蜂窝技术
    var RadioAccessTechStrings: [String]
    var RadioAccessTechNumbers: [Double]
    
    
    mutating func populateWith(record: CKRecord){
        
        // 更新日期
        ModifiedAt = record.object(forKey: "modifiedAt") as! Date
        
        // 总数据量
        NumberOfEntries = record.object(forKey: "NumberOfEntries") as! Int
        
        // 范围分布
        NumberOfRangeBelowTierOne = record.object(forKey: "NumberOfRangeBelowTierOne") as! Int
        NumberOfRangeBetweenTierOneAndTwo = record.object(forKey: "NumberOfRangeBetweenTierOneAndTwo") as! Int
        NumberOfRangeAboveTierTwo = record.object(forKey: "NumberOfRangeAboveTierTwo") as! Int
        NumberOfRangeError = record.object(forKey: "NumberOfRangeError") as! Int
        
        // 平均 Ping 值
        AveragePingDeviceModels = record.object(forKey: "AveragePingDeviceModels") as! [String]
        AveragePingLatencies = record.object(forKey: "AveragePingLatencies")as! [Double]
        
        // 蜂窝技术
        RadioAccessTechStrings = record.object(forKey: "RadioAccessTechStrings") as! [String]
        RadioAccessTechNumbers = record.object(forKey: "RadioAccessTechNumbers") as! [Double]
        
    }
    
    func convert() -> CKRecord {
        
        let record = CKRecord(recordType: "Insight")
        
        // 更新日期
        record.setObject(ModifiedAt as __CKRecordObjCValue, forKey: "ModifiedAt")
        
        // 总数据量
        record.setObject(NumberOfEntries as __CKRecordObjCValue, forKey: "NumberOfEntries")
        
        // 范围分布
        record.setObject(NumberOfRangeBelowTierOne as __CKRecordObjCValue, forKey: "NumberOfRangeBelowTierOne")
        record.setObject(NumberOfRangeBetweenTierOneAndTwo as __CKRecordObjCValue, forKey: "NumberOfRangeBetweenTierOneAndTwo")
        record.setObject(NumberOfRangeAboveTierTwo as __CKRecordObjCValue, forKey: "NumberOfRangeAboveTierTwo")
        record.setObject(NumberOfRangeError as __CKRecordObjCValue, forKey: "NumberOfRangeError")
        
        // 平均 Ping 值
        record.setObject(AveragePingDeviceModels as __CKRecordObjCValue, forKey: "AveragePingDeviceModels")
        record.setObject(AveragePingLatencies as __CKRecordObjCValue, forKey: "AveragePingLatencies")
        
        // 蜂窝技术
        record.setObject(RadioAccessTechStrings as __CKRecordObjCValue, forKey: "RadioAccessTechStrings")
        record.setObject(RadioAccessTechNumbers as __CKRecordObjCValue, forKey: "RadioAccessTechNumbers")
        
        return record
        
    }
    
    init(record: CKRecord){
        
        // 更新日期
        ModifiedAt = record.object(forKey: "modifiedAt") as! Date
        
        // 总数据量
        NumberOfEntries = record.object(forKey: "NumberOfEntries") as! Int
        
        // 范围分布
        NumberOfRangeBelowTierOne = record.object(forKey: "NumberOfRangeBelowTierOne") as! Int
        NumberOfRangeBetweenTierOneAndTwo = record.object(forKey: "NumberOfRangeBetweenTierOneAndTwo") as! Int
        NumberOfRangeAboveTierTwo = record.object(forKey: "NumberOfRangeAboveTierTwo") as! Int
        NumberOfRangeError = record.object(forKey: "NumberOfRangeError") as! Int
        
        // 平均 Ping 值
        AveragePingDeviceModels = record.object(forKey: "AveragePingDeviceModels") as! [String]
        AveragePingLatencies = record.object(forKey: "AveragePingLatencies")as! [Double]
        
        // 蜂窝技术
        RadioAccessTechStrings = record.object(forKey: "RadioAccessTechStrings") as! [String]
        RadioAccessTechNumbers = record.object(forKey: "RadioAccessTechNumbers") as! [Double]
        
    }
    
}
