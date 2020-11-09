//
//  InfoCardView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/9.
//

import SwiftUI

struct InfoCardView: View {
    var finalData : FinalDataStructure
    
    var body: some View {
        
        HStack {
            FixedMapView(coordinate: finalData.Location)
                .frame(width: 110, height: 110)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text("机型：" + finalData.DeviceName)
                Text("运营商：" + finalData.MobileCarrier + " " + finalData.RadioAccessTechnology)
                Text("平均延迟：\(Int(finalData.AveragedPingLatency))ms")
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
