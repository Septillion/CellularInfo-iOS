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
    @State private var insightRangeOfPingData = InsightRangeOfPingData(recievedData: [])
    
    //MARK: 平均 Ping 值
    @State private var insightAveragePingDataByDeviceName = InsightAveragePingData(recievedData: [FinalDataStructure(AveragedPingLatency: 0, DeviceName: "-", Location: CLLocationCoordinate2D(latitude: 0, longitude: 0), MobileCarrier: "-", RadioAccessTechnology: "-")], calculateBy: .DeviceName)
    
    //MARK: 运营商
    @State private var insightAveragePingDataByMobileCarrier = InsightAveragePingData(recievedData: [FinalDataStructure(AveragedPingLatency: 0, DeviceName: "-", Location: CLLocationCoordinate2D(latitude: 0, longitude: 0), MobileCarrier: "-", RadioAccessTechnology: "-")], calculateBy: .MobileCarrier)
    
    //MARK: 蜂窝技术
    @State private var insightAveragePingDataByRAT = InsightAveragePingData(recievedData: [FinalDataStructure(AveragedPingLatency: 0, DeviceName: "-", Location: CLLocationCoordinate2D(latitude: 0, longitude: 0), MobileCarrier: "-", RadioAccessTechnology: "-")], calculateBy: .RadioAccessTechnology)
    
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
            Section (footer: Text("只包含三大运营商数据")) {
                HStack {
                    Text("总数据量")
                        .font(.headline)
                    Spacer()
                    Text(TotalDataCountString)
                        .foregroundColor(Color(.label))
                }
            }
            
            // MARK: - 范围分布
            Section(footer: Text("因存在幸存者偏差，timeout 比例可能过高")){
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("范围分布")
                            .font(.headline)
                    }
                    Spacer()
                }

                InsightRangeOfPingView(dataSet: $insightRangeOfPingData)
                    .frame(height: 200)
                    .padding(.leading)
            }
            
            // MARK: - 平均 ping 值
            Section(footer: Text("不包含 timeout")){
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("设备平均 Ping 值")
                            .font(.headline)
                    }
                    Spacer()
                }
                
                InsightAveragePingList(dataSet: $insightAveragePingDataByDeviceName)
                    .padding(.leading)
                    
            }
            
            // MARK: - 运营商
            Section(footer: Text("不包含 timeout")){
                
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("运营商")
                            .font(.headline)
                    }
                    Spacer()
                }
                
                InsightAveragePingList(dataSet: $insightAveragePingDataByMobileCarrier)
                    .padding(.leading)
                
                
            }
            
            // MARK: - 蜂窝技术
            Section(footer: Text("不包含 timeout")){
                
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("蜂窝技术")
                            .font(.headline)
                    }
                    Spacer()
                }
                
                InsightAveragePingList(dataSet: $insightAveragePingDataByRAT)
                    .padding(.leading)
                
                
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
                    FetchButtonText = "处理数据..."
                    
                    // MARK: - Put Data into its corresponding catagories.
                    DispatchQueue.main.async {
                        
                        for i in mRecords {
                            let data = FinalDataStructure(record: i)
                            
                            // Ignore data that is outside of China.
                            guard data.MobileCarrier.contains("中国") else{
                                continue
                            }
                            
                            self.recievedData.append(data)
                            TotalDataCountString = "加载中（\(recievedData.count)）"
                            
                        }
                        
                        // Populate View
                        FetchButtonText = "加载完成"
                        isFetchButtonEnabled = true
                        
                        //MARK: - Calculating Ratio
                        //let count = Double (recievedData.count)
                         
                        //MARK: 总数据量
                        TotalDataCountString = "\(recievedData.count)"
                        
                        //MARK: Analyze Data: 范围分布
                        insightRangeOfPingData = InsightRangeOfPingData(recievedData: recievedData)
                        
                        //MARK: 平均 Ping 值
                        insightAveragePingDataByDeviceName = InsightAveragePingData(recievedData: recievedData, calculateBy: .DeviceName)
                        
                        //MARK: 运营商
                        insightAveragePingDataByMobileCarrier = InsightAveragePingData(recievedData: recievedData, calculateBy: .MobileCarrier)
                        
                        //MARK: 蜂窝技术
                        insightAveragePingDataByRAT = InsightAveragePingData(recievedData: recievedData, calculateBy: .RadioAccessTechnology)
                        
                        //Turn On Auto Lock Again
                        UIApplication.shared.isIdleTimerDisabled = false
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
        
        //Update View
        isFetchButtonEnabled = false
        FetchButtonText = "正在下载..."
        TotalDataCountString = "获取中"
        
        //Turn Off Auto Lock
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    //MARK: - End of struct
}

struct InsightView_Previews: PreviewProvider {
    static var previews: some View {
        InsightView()
    }
}
