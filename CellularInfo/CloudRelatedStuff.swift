//
//  CloudRelatedStuff.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//  with code snippets from https://medium.com/better-programming/swift-it-yourself-develop-a-to-do-app-with-cloudkit-e029e820df43
//

import Foundation
import CloudKit

class CloudRelatedStuff {
    
    var recievedData : [FinalDataStructure]?
    var dataReadyToSend : [FinalDataStructure]?
    
    enum FetchError {
        case fetchingError, noRecords, none, addingError
    }
    
    struct CloudKitManager {
        
        func PullData(completion: @escaping ([CKRecord]?, FetchError) -> Void){
            let publicDatabase = CKContainer(identifier: "iCloud.publicCellularInfo").publicCloudDatabase
            let query = CKQuery(recordType: "CellularInfo", predicate: NSPredicate(value: true))
            
            query.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            publicDatabase.perform(query, inZoneWith: CKRecordZone.default().zoneID, completionHandler: {(records, error) -> Void in
                self.processQueryResponseWith(records: records, error: error as NSError?, completion: {fetchedRecords, FetchError in
                    completion(fetchedRecords, FetchError)
                })
            })
        }
        
        func PushData(finalData: [FinalDataStructure], completionHandler: @escaping (CKRecord?, FetchError)->Void){
            let publicDatabase = CKContainer(identifier: "iCloud.publicCellularInfo").publicCloudDatabase
            for i in finalData{
                let record = i.convert()
                
                publicDatabase.save(record, completionHandler: {(record, error) in
                    guard error != nil else {
                        completionHandler(record, .none)
                        // Delete local data
                        return
                    }
                    let string1 = error!.localizedDescription
                    print(string1)
                    completionHandler(nil, .addingError)
                })
            }
            
        }
        
        
        private func processQueryResponseWith (records: [CKRecord]?, error: NSError?, completion: @escaping ([CKRecord]?, FetchError)->Void){
            guard error == nil else {
                completion(nil, .fetchingError)
                return
            }
            
            guard let records = records, records.count > 0 else {
                completion(nil, .noRecords)
                return
            }
            
            completion(records, .none)
        }
        
    }
    
    
    
    
    
    
}
