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
    
    enum FetchError {
        case fetchingError, noRecords, none, addingError
    }
    
    struct CloudKitManager {
        
        func cloudKitLoadRecords(result: @escaping (_ objects: [CKRecord]?, _ error: Error?) -> Void) {
            // predicate
            let predicate = NSPredicate(value: true)
            // query
            let cloudKitQuery = CKQuery(recordType: "CellularInfo", predicate: predicate)

            // records to store
            var records = [CKRecord]()

            //operation basis
            let publicDatabase = CKContainer(identifier: "iCloud.publicCellularInfo").publicCloudDatabase

            // recurrent operations function
            var recurrentOperationsCounter = 100
            func recurrentOperations(cursor: CKQueryOperation.Cursor?){
                let recurrentOperation = CKQueryOperation(cursor: cursor!)
                recurrentOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
                    print("-> cloudKitLoadRecords - recurrentOperations - fetch \(recurrentOperationsCounter)")
                    recurrentOperationsCounter += 1
                    records.append(record)
                }
                recurrentOperation.queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
                    if ((error) != nil) {
                        print("-> cloudKitLoadRecords - recurrentOperations - error - \(String(describing: error))")
                        result(nil, error)
                    } else {
                        if cursor != nil {
                            print("-> cloudKitLoadRecords - recurrentOperations - records \(records.count) - cursor \(cursor!.description)")
                            recurrentOperations(cursor: cursor!)
                        } else {
                            print("-> cloudKitLoadRecords - recurrentOperations - records \(records.count) - cursor nil - done")
                            result(records, nil)
                        }
                    }
                }
                publicDatabase.add(recurrentOperation)
            }
            // initial operation
            var initialOperationCounter = 1
            let initialOperation = CKQueryOperation(query: cloudKitQuery)
            initialOperation.recordFetchedBlock = { (record:CKRecord!) -> Void in
                print("-> cloudKitLoadRecords - initialOperation - fetch \(initialOperationCounter)")
                initialOperationCounter += 1
                records.append(record)
            }
            initialOperation.queryCompletionBlock = { (cursor: CKQueryOperation.Cursor?, error: Error?) -> Void in
                if ((error) != nil) {
                    print("-> cloudKitLoadRecords - initialOperation - error - \(String(describing: error))")
                    result(nil, error)
                } else {
                    if cursor != nil {
                        print("-> cloudKitLoadRecords - initialOperation - records \(records.count) - cursor \(cursor!.description)")
                        recurrentOperations(cursor: cursor!)
                    } else {
                        print("-> cloudKitLoadRecords - initialOperation - records \(records.count) - cursor nil - done")
                        result(records, nil)
                    }
                }
            }
            publicDatabase.add(initialOperation)
        }
        
        func PullData(completion: @escaping ([CKRecord]?, FetchError) -> Void){
            let publicDatabase = CKContainer(identifier: "iCloud.publicCellularInfo").publicCloudDatabase
            let query = CKQuery(recordType: "CellularInfo", predicate: NSPredicate(value: true))

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
