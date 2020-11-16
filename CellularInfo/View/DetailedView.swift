//
//  DetailedView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/3.
//

import SwiftUI
import CoreLocation

//MARK: The modal sheet that pops up when you hit the submit button
struct DetailedView: View {
    
    @Binding var showSheetView: Bool
    var pingNumberAveraged : Double
    
    let networkInfo = CellularAndWifiInformation()
    @State var alertMessage: String = "网络错误"
    @State var butttonMesssage: String = "同意并提交"
    @State var dataReadyForUpload: FinalDataStructure?
    @State var showAlert: Bool = false
    @ObservedObject var locationManager = LocationManager()
    // var isTestDoneOnWifi : Bool
    let hapticsGenerator = UINotificationFeedbackGenerator()
    
    var body: some View {
        
        NavigationView{
            VStack {
                
                
                InfoCardView(finalData:FinalDataStructure(
                                AveragedPingLatency: pingNumberAveraged,
                                DeviceName: UIDevice().type.rawValue,
                                Location: locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
                                MobileCarrier: networkInfo.carrierName,
                                RadioAccessTechnology: networkInfo.radioAccessTech))
                    .background(Color(.secondarySystemFill))
                    .frame(height: 110, alignment: .leading)
                    .cornerRadius(16)
                    .padding()
                
                
                Spacer()
                
                Text("我们非常重视您的隐私，仅上述显示信息会被提交。本 app 基于 CloudKit 构建，我们不设任何中转服务器用于接受或处理信息。您可访问 github.com/Septillion/CellularInfo-iOS 查阅原始代码。")
                    .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    .font(.footnote)
                    .padding(.horizontal)
                
                Button(action: {uploadData()}, label: {
                    Text(butttonMesssage)
                        .frame(minWidth: 100, maxWidth: .infinity, idealHeight: 48, alignment: .center)
                        .padding()
                        .background(Color(.systemBlue))
                        .cornerRadius(16)
                        .foregroundColor(.white)
                        .font(.title)
                }).alert(isPresented: $showAlert, content: {
                    Alert(title: Text("请等一下！"), message: Text(alertMessage), dismissButton: .default(Text("关闭")))
                }).padding()
            }
            //.background(Color(.secondarySystemFill))
            .navigationBarTitle(Text("即将提交"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                print("取消提交")
                self.showSheetView = false
            }) {
                Text("取消").bold()
            })
        }
        
    }
    
    func uploadData() {
        
        if networkInfo.carrierName == "" {
            self.alertMessage = "蜂窝网络未连接，我们只接受使用蜂窝网络进行的测试。"
            hapticsGenerator.notificationOccurred(.warning)
            showAlert = true
            return
        }
        
        if pingNumberAveraged == 0 {
            self.alertMessage = "网络中断"
            hapticsGenerator.notificationOccurred(.warning)
            showAlert = true
            return
        }
        
        if locationManager.lastLocation == nil {
            self.alertMessage = "获取位置失败，请确认权限。"
            hapticsGenerator.notificationOccurred(.warning)
            showAlert = true
            return
        }
        
        self.dataReadyForUpload = FinalDataStructure(
            AveragedPingLatency: pingNumberAveraged,
            DeviceName: UIDevice().type.rawValue,
            Location: locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            MobileCarrier: networkInfo.carrierName,
            RadioAccessTechnology: networkInfo.radioAccessTech)
        
        let cloudKitmanager = CloudRelatedStuff.CloudKitManager()
        cloudKitmanager.PushData(finalData: [dataReadyForUpload!], completionHandler: {_,_ in
            
            hapticsGenerator.notificationOccurred(.success)
            self.showSheetView = false
            return
        })
    }
}


