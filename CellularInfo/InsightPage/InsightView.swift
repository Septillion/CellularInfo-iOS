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
    @State private var FetchButtonText = "加载全部数据"
    
    // Variable to Hold Data
    @State private var recievedData : [FinalDataStructure] = []
    
    //MARK: 总数据量
    @State private var TotalDataCountString: String = "-"
    
    //MARK: 范围分布
    private let TierOne = 50
    private let TierTwo = 100
    @State private var PercentOfItemsBelowLatencyTierOne: CGFloat = 0
    @State private var PercentOfItemsBetweenLatencyTierOneAndTierTwo: CGFloat = 0
    @State private var PercentOfItemsAboveLatencyTierTwo: CGFloat = 0
    @State private var PercentOfError: CGFloat = 0
    
    //MARK: 平均 Ping 值
    @State var AveragePingDeviceModels: [String] = ["-","-","-","-","-","-","-","-","-"]
    @State var AveragePingNumbers: [Double] = [0,0,0,0,0,0,0,0,0]
    @State var AveragePingPercentOfBarLength: [CGFloat] = [0,0,0,0,0,0,0,0,0]
    
    //MARK: 蜂窝技术
    @State var RadioAccessTechName: [String] = ["-","-","-","-","-"]
    @State var RadioAccessTechPercent: [Double] = [0,0,0,0,0]
    
    var body: some View {
        
        List {
            
            //MARK: - Load Button
            Section (footer: Text("数据量较大，需要 5-10 分钟获取")){
                
                Button(action: {
                    FetchAllData()
                }, label: {
                    Text(FetchButtonText)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                })
                .disabled(!isFetchButtonEnabled)
                
            }
            
            // MARK: - 总数据量
            Section (footer: Text("不包含海外数据")) {
                
                
                HStack {
                    Text("总数据量")
                        .font(.headline)
                    Spacer()
                    Text(TotalDataCountString)
                        .foregroundColor(Color(.label))
                }
                
            }
            
            // MARK: - 范围分布
            Section{
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("范围分布")
                            .font(.headline)
                    }
                    Spacer()
                }
                
                VStack{
                    
                    //Divider()
                    
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
                                Text("error（可能存在幸存者偏差）")
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
                    
                    //Divider()
                    
                }
                .padding([.leading])
                
            }
            
            // MARK: - 平均 ping 值
            Section{
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("平均 Ping 值")
                            .font(.headline)
                        Text("不包含 Error")
                            .font(.caption)
                    }
                    Spacer()
                }
                
                VStack{
                    //Divider()
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[0])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[0]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[0] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[1])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[1]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[1] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[2])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[2]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[2] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[3])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[3]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[3] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[4])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[4]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[4] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[5])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[5]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[5] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[6])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[6]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[6] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[7])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[7]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[7] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(AveragePingDeviceModels[8])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", AveragePingNumbers[8]))ms")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(AveragePingPercentOfBarLength[8] * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        //Divider()
                        
                    }
                    
                    
                    
                    
                }
                .padding([.leading])
            }
            
            // MARK: - 蜂窝技术覆盖率
            Section{
                
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("蜂窝技术")
                            .font(.headline)
                    }
                    Spacer()
                }
                
                VStack{
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(RadioAccessTechName[0])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", RadioAccessTechPercent[0] * 100))%")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(CGFloat(RadioAccessTechPercent[0]) * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(RadioAccessTechName[1])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", RadioAccessTechPercent[1] * 100))%")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(CGFloat(RadioAccessTechPercent[1]) * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(RadioAccessTechName[2])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", RadioAccessTechPercent[2] * 100))%")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(CGFloat(RadioAccessTechPercent[2]) * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(RadioAccessTechName[3])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", RadioAccessTechPercent[3] * 100))%")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(CGFloat(RadioAccessTechPercent[3]) * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        Divider()
                        
                    }
                    
                    VStack{
                        
                        HStack {
                            VStack (alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(RadioAccessTechName[4])
                                    Spacer()
                                    Text("\(NSString(format: "%.1f", RadioAccessTechPercent[4] * 100))%")
                                }
                                GeometryReader { metrics in
                                    Rectangle()
                                        .frame(width: max(CGFloat(RadioAccessTechPercent[4]) * metrics.size.width, 1), height: 20)
                                        .foregroundColor(.accentColor)
                                }.frame(height: 20)
                            }
                        }
                        
                        //Divider()
                        
                    }
                    
                    
                }
                .padding([.leading])
                
            }
            
            
            //MARK: - List End
        }.listStyle(GroupedListStyle())
        
    }
    
    
    //MARK: - Function triggered by Fetch Button
    func FetchAllData() {
        
        ClearDataAndView()
        
        //MARK: - Initiating Pull Everything From The Cloud
        let manager = CloudRelatedStuff.CloudKitManager()
        manager.PullEverythingFromTheCloud(){(records, error) -> Void in
            if let error = error {
                // Something Wrong
                print(error)
            } else {
                if let mRecords = records {
                    
                    // MARK: - Pulling Success
                    
                    // initiating temporary variables
                    
                    //MARK: Data Count: 范围分布
                    var NumberOfItemsBelowLatencyTierOne = 0.0
                    var NumberOfItemsBetweenLatencyTierOneAndTierTwo = 0.0
                    var NumberOfItemsAboveLatencyTierTwo = 0.0
                    var NumberOfError = 0.0
                    var LouWangZhiYu = 0.0
                    
                    //MARK: Data Count: 平均 Ping 值
                    var averagePingCombined: [String : Double] = [:] // String: Device Model, Double: Sum of Ping
                    var averagePingCount: [String : Int ] = [:] // String: Device Model, Double: How Many Are There
                    
                    //MARK: Data Count: 蜂窝技术
                    var radioAccessTechCount: [String : Int] = [:] // String: Radio Access Tech, Int: How Many Are There
                    
                    FetchButtonText = "处理数据..."
                    
                    // MARK: - Put Data into its corresponding catagories.
                    DispatchQueue.main.async {
                        
                        for i in mRecords {
                            var data = FinalDataStructure()
                            data.populateWith(record: i)
                            
                            // Ignore data that is outside of China.
                            guard !CoordinateTransformation.isLocationOut(ofChina: data.Location) else{
                                continue
                            }
                            
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
                            
                            //MARK: Sort Data: 平均 Ping 值
                            //Initializing Dictionaries
                            if averagePingCount[data.DeviceName] == nil {
                                averagePingCount[data.DeviceName] = 0
                            }
                            if averagePingCombined[data.DeviceName] == nil {
                                averagePingCombined[data.DeviceName] = 0
                            }
                            
                            // Only counting those that are not error
                            if !(data.AveragedPingLatency == 999999) {
                                averagePingCombined[data.DeviceName]! += data.AveragedPingLatency
                                averagePingCount[data.DeviceName]! += 1
                            }
                            
                            //MARK: Sort Data: 蜂窝技术
                            //Initializing Dictionaries
                            if radioAccessTechCount[data.RadioAccessTechnology] == nil {
                                radioAccessTechCount[data.RadioAccessTechnology] = 0
                            }
                            
                            radioAccessTechCount[data.RadioAccessTechnology]! += 1
                            
                        }
                        
                        // Populate View
                        FetchButtonText = "加载完成"
                        isFetchButtonEnabled = true
                        
                        //MARK: - Calculating Ratio
                        let count = Double (recievedData.count)
                         
                        //MARK: 总数据量
                        TotalDataCountString = "\(recievedData.count)"
                        
                        //MARK: Analyze Data: 范围分布
                        PercentOfItemsBelowLatencyTierOne = CGFloat(NumberOfItemsBelowLatencyTierOne / count)
                        PercentOfItemsBetweenLatencyTierOneAndTierTwo = CGFloat(NumberOfItemsBetweenLatencyTierOneAndTierTwo / count)
                        PercentOfItemsAboveLatencyTierTwo = CGFloat(NumberOfItemsAboveLatencyTierTwo / count)
                        PercentOfError = CGFloat(NumberOfError / count)
                        
                        
                        //MARK: 平均 Ping 值
                        
                        // Sort by Number of Data points.
                        let sortedAveragePingCount = averagePingCount.sorted{(first, second) -> Bool in
                            return first.value > second.value
                        }
                        
                        // Local Variable to hold temporary data
                        var AveragePingDeviceModels: [String] = []
                        var AveragePingNumbers: [Double] = []
                        var AveragePingPercentOfBarLength: [CGFloat] = []
                        
                        //Calculate
                        for i in sortedAveragePingCount {
                            AveragePingDeviceModels.append(i.key)
                            AveragePingNumbers.append(averagePingCombined[i.key]! / Double(i.value))
                        }
                        
                        for j in AveragePingNumbers{
                            AveragePingPercentOfBarLength.append(CGFloat(j / AveragePingNumbers.max()!))
                        }
                        
                        print("Available Models: \(AveragePingDeviceModels)")
                        
                        // Report Upstream
                        self.AveragePingDeviceModels = AveragePingDeviceModels
                        self.AveragePingNumbers = AveragePingNumbers
                        self.AveragePingPercentOfBarLength = AveragePingPercentOfBarLength
                        
                        
                        //MARK: 蜂窝技术
                        
                        // Sort by Count
                        let sortedRadioAccessTech = radioAccessTechCount.sorted{(first, second) -> Bool in
                            return first.value > second.value
                        }
                        
                        // Local variables to hold temporary data
                        var RadioAccessTechName: [String] = []
                        var RadioAccessTechPercent: [Double] = []
                        
                        for i in sortedRadioAccessTech{
                            RadioAccessTechName.append(i.key)
                            RadioAccessTechPercent.append(Double(i.value)/Double(recievedData.count))
                        }
                        
                        print("Available RATs: \(RadioAccessTechName)")
                        print(RadioAccessTechPercent)
                        
                        // Report Upstream
                        self.RadioAccessTechName = RadioAccessTechName
                        self.RadioAccessTechPercent = RadioAccessTechPercent
                        
                        //MARK: -End of DispatchQueue
                    }
                } else {
                    // do something
                }
            }
        }
    }
    
    
    // MARK: - Clear Data and View
    
    func ClearDataAndView() {
        
        //Clean Data
        recievedData.removeAll()
        TotalDataCountString = "-"
        PercentOfItemsBelowLatencyTierOne = 0
        PercentOfItemsBetweenLatencyTierOneAndTierTwo = 0
        PercentOfItemsAboveLatencyTierTwo = 0
        PercentOfError = 0
        AveragePingDeviceModels = ["-","-","-","-","-","-","-","-","-"]
        AveragePingNumbers = [0,0,0,0,0,0,0,0,0]
        AveragePingPercentOfBarLength = [0,0,0,0,0,0,0,0,0]
        RadioAccessTechName = ["-","-","-","-","-"]
        RadioAccessTechPercent = [0,0,0,0,0]
        
        //Update View
        isFetchButtonEnabled = false
        FetchButtonText = "正在下载..."
        TotalDataCountString = "获取中"
        
    }
    
    //MARK: - End of struct
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}
