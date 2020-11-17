//
//  InfoCardView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/9.
//

import SwiftUI

struct InfoCardView: View {
    var finalData : FinalDataStructure
    
    @State var averagePingString = ""
    
    var body: some View {
        
        HStack {
            FixedMapView(coordinate: finalData.Location)
                .frame(width: 110, height: 110)
                .cornerRadius(16)
            
            VStack(alignment: .leading) {
                Text("机型：" + finalData.DeviceName)
                Text("运营商：" + finalData.MobileCarrier + " " + finalData.RadioAccessTechnology)
                Text(self.averagePingString)
                    .onAppear(perform: {
                        self.averagePingString = "平均延迟：\(String(format: "%.1f", finalData.AveragedPingLatency))ms"
                        if finalData.AveragedPingLatency == 999999 {
                            self.averagePingString = "平均延迟：error"
                        }
                    })
                Spacer()
            }.padding()
            
            Spacer()
            
        }
        //.background(Color(.secondarySystemBackground))
        //.cornerRadius(8)
    }
}

struct InfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        InfoCardView(finalData: FinalDataStructure(AveragedPingLatency: 10, DeviceName: "iPhone", Location: CLLocationCoordinate2D(latitude: 34.322700, longitude: 108.552500), MobileCarrier: "Mobile", RadioAccessTechnology: "5G"))
    }
}
