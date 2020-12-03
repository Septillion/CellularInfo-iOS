//
//  InsightRangeOfPingView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/30.
//

import SwiftUI

// Data Structure
struct InsightRangeOfPingData {
    
    var dataSet: [Double : CGFloat] // [ starting milisecond : percent ]
    
    var numberOfRows: Int = 15
    var maxNumberDisplayed: Double = 300.0
    
    init(recievedData: [FinalDataStructure]){
        
        var rawData: [Double : Int] = [:] // [ starting milisecond : count ]
        var dataUsedByChart : [Double : CGFloat] = [:] // [starting milisecond : length of bar ]
        var maxNumber: Double = 0 // Highest bar should always be 100% height
        
        let groupLength = maxNumberDisplayed / Double(numberOfRows)
        
        // Put data in corresponding groups
        for i in recievedData{
            
            if i.AveragedPingLatency == 999999{
                
                if rawData[999999] == nil{
                    rawData[999999] = 0
                }
                rawData[999999]! += 1
                
            }else{
                
                for j in 0...numberOfRows-1{
                    
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
            
            
        }
        
        // Fill with Zero
        for i in 0...numberOfRows - 1{
            dataUsedByChart[(maxNumberDisplayed / Double(numberOfRows)) * Double(i)] = 0
        }
        dataUsedByChart[999999] = 0
        
        // Find Maximum Number
        for j in rawData {
            if Double(j.value) > maxNumber {
                maxNumber = Double(j.value)
            }
        }
        
        // Calculate height percent
        for k in rawData{
            dataUsedByChart[k.key] = CGFloat(k.value) / CGFloat(maxNumber)
        }
        
        self.dataSet = dataUsedByChart
    }
    
}

struct InsightRangeOfPingView: View {
    
    @Binding var dataSet: InsightRangeOfPingData
    
    var body: some View {
        
        HStack{
            ForEach (dataSet.dataSet.sorted(by: <), id: \.key ){ key, value in
                //Text("\(key)")
                //Text("\(value)")
                GeometryReader { metrics in
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(height: max((metrics.size.height - 40) * CGFloat(value) , 1))
                            .foregroundColor(.accentColor)
                            .transition(.identity)
                        Text( key == 999999 ? "err" : "\(Int(key))" )
                            .font(.system(size: 6))
                            .frame(height: 10.0)
                    }
                }
            }
            
        }
        
    }
}

struct InsightRangeOfPingView_Previews: PreviewProvider {
    static var previews: some View {
        InsightRangeOfPingView(dataSet: .constant(InsightRangeOfPingData(recievedData: [FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),
                                                                                        FinalDataStructure(fillWithRandom: true),])))
            .previewLayout(.fixed(width: 320, height: 200))
    }
    
    
}
