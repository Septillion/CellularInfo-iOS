//
//  InsightRangeOfPingView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/30.
//

import SwiftUI

// Data Structure
struct InsightRangeOfPingData {
    
    var sortedDataSet: [Double : Double] // [ starting milisecond : percent ]
    
    var numberOfRows: Int = 15
    var maxNumberDisplayed: Double = 300.0
    
    init(recievedData: [FinalDataStructure]){
        
        var rawData: [Double : Int] = [:] // [ starting milisecond : count ]
        let groupLength = maxNumberDisplayed / Double(numberOfRows)
        
        // Put data in corresponding groups
        for i in recievedData{
            
            for j in 1...numberOfRows{
                
                let startingMilisecond = groupLength * Double(j)
                
                if i.AveragedPingLatency > startingMilisecond
                    && i.AveragedPingLatency < (startingMilisecond + groupLength){
                    
                    if rawData[startingMilisecond] == nil {
                        rawData[startingMilisecond] = 0
                    }
                    
                    rawData[startingMilisecond]! += 1
                    
                }
            }
            
        }
        
        rawData.sorted{(first, second) -> Bool in
            return first.key > second.key
        }
        
        var sortedDataSet : [Double : Double] = [:]
        
        for k in rawData{
            sortedDataSet[k.key] = Double(k.value / recievedData.count)
        }
        
        self.sortedDataSet = sortedDataSet
    }
    
}

struct InsightRangeOfPingView: View {
    
    @State var dataSet: InsightRangeOfPingData
    
    var body: some View {
        
        HStack{

            
        }
        
    }
}

struct InsightRangeOfPingView_Previews: PreviewProvider {
    static var previews: some View {
        InsightRangeOfPingView(dataSet: InsightRangeOfPingData(recievedData: [
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true),
                                                                FinalDataStructure(isRandom: true)]))
    }
}
