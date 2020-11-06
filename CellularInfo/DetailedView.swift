//
//  DetailedView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/3.
//

import SwiftUI
import CoreLocation

struct DetailedView: View {
    
    let networkInfo = NetworkInformation()
    var pingNumberAveraged : Double
    @State var dataReadyForUpload: FinalDataStructure?
    @State var showAlert: Bool = false
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
      
        VStack {
            
            Text("Disclaimer")
                .font(.title)
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Text("We do not collect any personal information. In fact, we don't collect any information at all. When you press the submit button, everything goes straight to Apple's CloudKit servers. We do not poccess any information that can be used to identify you.")
                .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            Spacer()
            
            FixedMapView()
                .frame(width: .infinity, height: 100)
                .cornerRadius(8)
                
            
            Group {
                Text(UIDevice().type.rawValue)
                    .font(.title)
                Text("活跃：" + networkInfo.carrierName + " " + networkInfo.radioAccessTech)
                Text("平均延迟：\(Int(pingNumberAveraged))ms")
                
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
            
            
            Button(action: {uploadData()}, label: {
                Text("同意并提交")
                    .frame(minWidth: 100, maxWidth: .infinity, idealHeight: 48, alignment: .center)
                    .padding()
                    .background(Color(.systemBlue))
                    .cornerRadius(16)
                    .foregroundColor(.white)
                    .font(.title)
            }).alert(isPresented: $showAlert, content: {
                Alert(title: Text("Alert"), message: Text("internet error or is on wifi"), dismissButton: .default(Text("Got it")))
            })
        }
        .padding()
        
    }
    
    func uploadData() {
        if (networkInfo.isWiFiConnected)||(networkInfo.carrierName=="")||(pingNumberAveraged == 0){
            // Disable Upload
            showAlert = true
            return
        }
        self.dataReadyForUpload = FinalDataStructure(AveragedPingLatency: pingNumberAveraged, DeviceName: UIDevice().type.rawValue, Location: locationManager.lastLocation?.coordinate, MobileCarrier: networkInfo.carrierName, RadioAccessTechnology: networkInfo.radioAccessTech)
        let cloudKitmanager = CloudRelatedStuff.CloudKitManager()
        cloudKitmanager.PushData(finalData: [dataReadyForUpload!], completionHandler: {_,_ in
            return
        })
    }
}

struct DetailedView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedView(pingNumberAveraged: 10)
    }
}


