//
//  InsightView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/18.
//

import SwiftUI

struct InsightView: View {
    
    //Button and Text States
    @State private var isFetchButtonEnabled: Bool = true
    @State private var FetchButtonText = "获取全部数据"

    
    
    // Variable to Hold Data
    @State private var recievedData : [FinalDataStructure] = []
    
    //MARK: 总数据量
    @State private var TotalDataCountString: String = "-"
    
    //MARK: 范围分布
    private let TierOne = 100
    private let TierTwo = 200
    @State private var PercentOfItemsBelowLatencyTierOne: CGFloat = 0
    @State private var PercentOfItemsBetweenLatencyTierOneAndTierTwo: CGFloat = 0
    @State private var PercentOfItemsAboveLatencyTierTwo: CGFloat = 0
    @State private var PercentOfError: CGFloat = 0
    
    //MARK: 平均 Ping 值
    
    
    var body: some View {
        
        
        
        List {
            
            //MARK: - Start of List
            
            VStack (alignment: .leading) {
                
                //MARK: Fetch Button
                Button(action: {
                    FetchAllData()
                }, label: {
                    Text(FetchButtonText)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                })
                .disabled(!isFetchButtonEnabled)
                
                Text("数据量较大，需要 5-10 分钟获取")
                    .font(.caption)
            }
            // MARK: - 总数据量
            HStack {
                Text("总数据量")
                    .font(.headline)
                Spacer()
                Text(TotalDataCountString)
                    .foregroundColor(Color(.label))
            }
            
            
            // MARK: - 范围分布
            VStack (spacing: 10){
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("范围分布")
                            .font(.headline)
                        Text("全机型 除去海外数据")
                            .font(.caption)
                    }
                    Spacer()
                }
                
                VStack{
                    
                    
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            
                            HStack {
                                Text("小于 \(TierOne)ms")
                                Spacer()
                                Text("\(NSString(format: "%.1f", PercentOfItemsBelowLatencyTierOne * 100))%")
                            }
                            
                            GeometryReader { metrics in
                                Rectangle()
                                    .frame(width: max(PercentOfItemsBelowLatencyTierOne * metrics.size.width , 1) , height: 20)
                                    .foregroundColor(.accentColor)
                            }.frame(height: 20)
                            
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("介于 \(TierOne)ms 和 \(TierTwo)ms 之间")
                                Spacer()
                                Text("\(NSString(format: "%.1f", PercentOfItemsBetweenLatencyTierOneAndTierTwo * 100))%")
                            }
                            GeometryReader { metrics in
                                Rectangle()
                                    .frame(width: max (PercentOfItemsBetweenLatencyTierOneAndTierTwo * metrics.size.width, 1), height: 20)
                                    .foregroundColor(.accentColor)
                            }.frame(height: 20)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("大于 \(TierTwo)ms")
                                Spacer()
                                Text("\(NSString(format: "%.1f", PercentOfItemsAboveLatencyTierTwo * 100))%")
                            }
                            GeometryReader { metrics in
                                Rectangle()
                                    .frame(width: max(PercentOfItemsAboveLatencyTierTwo * metrics.size.width, 1), height: 20)
                                    .foregroundColor(.accentColor)
                            }.frame(height: 20)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("error（存在幸存者偏差）")
                                Spacer()
                                Text("\(NSString(format: "%.1f", PercentOfError * 100))%")
                            }
                            GeometryReader { metrics in
                                Rectangle()
                                    .frame(width: max(PercentOfError * metrics.size.width, 1), height: 20)
                                    .foregroundColor(.accentColor)
                            }.frame(height: 20)
                        }
                    }
                    
                    Divider()
                    
                    
                    
                }
                .padding([.leading, .bottom])
                
            }
            
            // MARK: - 平均 ping 值
            
            VStack (spacing: 10){
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("平均 Ping 值")
                            .font(.headline)
                        Text("除去 error 和海外数据")
                            .font(.caption)
                    }
                    Spacer()
                }
                
                VStack{
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("iPhone 12")
                                Spacer()
                                Text("1425ms")
                            }
                            Rectangle()
                                .frame(width: .infinity, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("12.9 英寸 iPad Pro（第二代）")
                                Spacer()
                                Text("425ms")
                            }
                            Rectangle()
                                .frame(width: .infinity, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("iPhone 12 Pro Max")
                                Spacer()
                                Text("25ms")
                            }
                            Rectangle()
                                .frame(width: .infinity, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("12.9 英寸 iPad Pro（第四代）")
                                Spacer()
                                Text("5ms")
                            }
                            Rectangle()
                                .frame(width: .infinity, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                }
                .padding([.leading, .bottom])
            }
            
            // MARK: - 蜂窝技术覆盖率
            
            VStack (spacing: 10){
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("蜂窝技术")
                            .font(.headline)
                        Text("全机型 除去海外数据")
                            .font(.caption)
                    }
                    Spacer()
                }
                
                VStack{
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            
                            HStack {
                                Text("LTE")
                                Spacer()
                                Text("40%")
                            }
                            Rectangle()
                                .frame(width: .infinity, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("NRNSA")
                                Spacer()
                                Text("40%")
                            }
                            Rectangle()
                                .frame(width: 80, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("NR")
                                Spacer()
                                Text("40%")
                            }
                            Rectangle()
                                .frame(width: 40, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack (alignment: .leading, spacing: 3) {
                            HStack {
                                Text("WCDMA")
                                Spacer()
                                Text("40%")
                            }
                            Rectangle()
                                .frame(width: 10, height: 20)
                                .foregroundColor(.accentColor)
                        }
                    }
                    
                    Divider()
                    
                }
                .padding([.leading, .bottom])
                
            }
            
            //MARK: - List End
        }
        
        
    }
    
    
    //MARK: - Function triggered by Fetch Button
    func FetchAllData() {
        
        recievedData.removeAll()
        isFetchButtonEnabled = false
        FetchButtonText = "获取中"
        TotalDataCountString = "获取中"
        
        let manager = CloudRelatedStuff.CloudKitManager()
        
        manager.PullEverythingFromTheCloud(){(records, error) -> Void in
            if let error = error {
                // do something
                print(error)
            } else {
                if let mRecords = records {
                    // do something
                    
                    
                    var NumberOfItemsBelowLatencyTierOne = 0.0
                    var NumberOfItemsBetweenLatencyTierOneAndTierTwo = 0.0
                    var NumberOfItemsAboveLatencyTierTwo = 0.0
                    var NumberOfError = 0.0
                    var LouWangZhiYu = 0.0
                    
                    DispatchQueue.main.async {
                        for i in mRecords {
                            var data = FinalDataStructure()
                            data.populateWith(record: i)
                            
                            //Don't do anything unless location is within China
                            if (!CoordinateTransformation.isLocationOut(ofChina: data.Location)){
                                self.recievedData.append(data)
                                
                                //MARK: Sort Data: 范围分布
                                if data.AveragedPingLatency <= Double(TierOne) {
                                    NumberOfItemsBelowLatencyTierOne += 1
                                }else if data.AveragedPingLatency > Double(TierOne) && data.AveragedPingLatency < Double(TierTwo) {
                                    NumberOfItemsBetweenLatencyTierOneAndTierTwo += 1
                                }else if data.AveragedPingLatency >= Double(TierTwo) && data.AveragedPingLatency < 999999{
                                    NumberOfItemsAboveLatencyTierTwo += 1
                                }else if data.AveragedPingLatency == 999999 {
                                    NumberOfError += 1
                                }else {
                                    LouWangZhiYu += 1
                                }
                            }
                            
                        }
                        
                        let count = Double (recievedData.count)
                        
                        //MARK: Analyze Data: 范围分布
                        PercentOfItemsBelowLatencyTierOne = CGFloat(NumberOfItemsBelowLatencyTierOne / count)
                        PercentOfItemsBetweenLatencyTierOneAndTierTwo = CGFloat(NumberOfItemsBetweenLatencyTierOneAndTierTwo / count)
                        PercentOfItemsAboveLatencyTierTwo = CGFloat(NumberOfItemsAboveLatencyTierTwo / count)
                        PercentOfError = CGFloat(NumberOfError / count)
                        
                        
                        
                        // Populate View
                        FetchButtonText = "获取完成"
                        isFetchButtonEnabled = true
                        
                        //MARK: 总数据量
                        TotalDataCountString = "\(recievedData.count)"
                        
                        //MARK: 范围分布
                        
                        
                        //MARK: 平均 Ping 值
                        
                        //MARK: -End of DispatchQueue
                    }
                } else {
                    // do something
                }
            }
        }
    }
    
    //MARK: - End of struct
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}
