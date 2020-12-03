//
//  InsightAveragePingByDeviceListItem.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/12/3.
//

import SwiftUI

struct InsightListItem{
    var description: String
    var barLength : CGFloat
}

struct InsightAveragePingData {
    
    var dataSet: [String : InsightListItem]
    
    init(recievedData: [FinalDataStructure], calculateBy: FinalDataStructure.index){

        // Populate RawData
        if calculateBy == .DeviceName{
            
            var rawData : [ String : [Double] ]  = [:] // [ Device Name : [ #0: Sum of Ping , #1: Number of items] ]
            
            // Populate Data
            for i in recievedData{
                if rawData[i.DeviceName] == nil {
                    rawData[i.DeviceName] = [0,0]
                }
                if i.AveragedPingLatency != 999999 { // discard error data
                    rawData[i.DeviceName] = [ rawData[i.DeviceName]![0] + i.AveragedPingLatency, rawData[i.DeviceName]![1] + 1]
                }
            }
            
            // Calculate Average Ping
            var deviceAndAveragePing : [ String : Double ] = [:] // [ Device Name : Calculated Average Ping ]
            for j in rawData{
                deviceAndAveragePing[j.key] = j.value[0] / j.value[1]
            }
            
            // Find Maximum Number
            var maxNumber : Double = 0
            for k in deviceAndAveragePing {
                if k.value > maxNumber{
                    maxNumber = k.value
                }
            }
            
            // Calculate dataSet
            self.dataSet = [:]
            for l in deviceAndAveragePing{
                self.dataSet[l.key] = InsightListItem(description: "\(NSString(format: "%.1f", l.value))ms", barLength: CGFloat(l.value / maxNumber))
            }
            
            return
            
        }else if calculateBy == .MobileCarrier {
            
            /* These code was used to display usage percent rather than ping
            var rawData : [ String: Int ] = [:] // [ Mobile Carrier : Count ]
            
            // Populate Data
            for i in recievedData{
                if rawData[i.MobileCarrier] == nil {
                    rawData[i.MobileCarrier] = 0
                }
                rawData[i.MobileCarrier]! += 1
            }
            
            // Find Max Number
            var maxNumber = 0
            for j in rawData {
                if j.value > maxNumber{
                    maxNumber = j.value
                }
            }
            
            // Calculate Dataset
            self.dataSet = [:]
            for k in rawData{
                self.dataSet[k.key] = InsightListItem(description: "\(NSString(format: "%.1f", Double(k.value) / Double(maxNumber) * 100))%", barLength: CGFloat(k.value) / CGFloat(maxNumber))
            }
            
            return
            
            
        }else if calculateBy == .RadioAccessTechnology {
            
        }
        
        // Calculate dataSet
        self.dataSet = [:]
        */
            
            var rawData : [ String : [Double] ]  = [:] // [ Mobile Carrier : [ #0: Sum of Ping , #1: Number of items] ]
            
            // Populate Data
            for i in recievedData{
                if rawData[i.MobileCarrier] == nil {
                    rawData[i.MobileCarrier] = [0,0]
                }
                if i.AveragedPingLatency != 999999 { // discard error data
                    rawData[i.MobileCarrier] = [ rawData[i.MobileCarrier]![0] + i.AveragedPingLatency, rawData[i.MobileCarrier]![1] + 1]
                }
            }
            
            // Calculate Average Ping
            var deviceAndAveragePing : [ String : Double ] = [:] // [ Mobile Carrier : Calculated Average Ping ]
            for j in rawData{
                deviceAndAveragePing[j.key] = j.value[0] / j.value[1]
            }
            
            // Find Maximum Number
            var maxNumber : Double = 0
            for k in deviceAndAveragePing {
                if k.value > maxNumber{
                    maxNumber = k.value
                }
            }
            
            // Calculate dataSet
            self.dataSet = [:]
            for l in deviceAndAveragePing{
                self.dataSet[l.key] = InsightListItem(description: "\(NSString(format: "%.1f", l.value))ms", barLength: CGFloat(l.value / maxNumber))
            }
            
            return
        } else if calculateBy == .RadioAccessTechnology{
            
            var rawData : [ String : [Double] ]  = [:] // [ RadioAccessTechnology : [ #0: Sum of Ping , #1: Number of items] ]
            
            // Populate Data
            for i in recievedData{
                if rawData[i.RadioAccessTechnology] == nil {
                    rawData[i.RadioAccessTechnology] = [0,0]
                }
                if i.AveragedPingLatency != 999999 { // discard error data
                    rawData[i.RadioAccessTechnology] = [ rawData[i.RadioAccessTechnology]![0] + i.AveragedPingLatency, rawData[i.RadioAccessTechnology]![1] + 1]
                }
            }
            
            // Calculate Average Ping
            var deviceAndAveragePing : [ String : Double ] = [:] // [ RadioAccessTechnology : Calculated Average Ping ]
            for j in rawData{
                deviceAndAveragePing[j.key] = j.value[0] / j.value[1]
            }
            
            // Find Maximum Number
            var maxNumber : Double = 0
            for k in deviceAndAveragePing {
                if k.value > maxNumber{
                    maxNumber = k.value
                }
            }
            
            // Calculate dataSet
            self.dataSet = [:]
            for l in deviceAndAveragePing{
                self.dataSet[l.key] = InsightListItem(description: "\(NSString(format: "%.1f", l.value))ms", barLength: CGFloat(l.value / maxNumber))
            }
            
            return
            
        }
        
        self.dataSet = [:]
    }
    
}

struct InsightAveragePingList: View {
    
    @Binding var dataSet: InsightAveragePingData
    
    var body: some View {
        VStack (spacing: 15) {
            ForEach (Array(dataSet.dataSet.keys).sorted(by: >), id: \.self){ key in
                //Text(key)
                //Text(dataSet.dataSet[key]!.description)
                //Text("\(dataSet.dataSet[key]!.barLength)")
                
                VStack{
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text(key)
                                Spacer()
                                Text(dataSet.dataSet[key]!.description)
                            }
                            GeometryReader { metrics in
                                Rectangle()
                                    .frame(width: max(dataSet.dataSet[key]!.barLength * metrics.size.width, 1), height: 20)
                                    .foregroundColor(.accentColor)
                            }.frame(height: 20)
                        }
                    }
                    
                    //Divider()
                    
                }
                
            }
        }
    }
}

struct InsightAveragePingListItem_Previews: PreviewProvider {
    static var previews: some View {
        InsightAveragePingList(dataSet: .constant(InsightAveragePingData(recievedData: [FinalDataStructure(fillWithRandom: true),
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
                                                                                                    FinalDataStructure(fillWithRandom: true),], calculateBy: .DeviceName)))
    }
}
