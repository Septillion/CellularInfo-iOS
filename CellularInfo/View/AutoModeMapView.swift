//
//  AutoModeMapView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/23.
//

import SwiftUI
import MapKit

struct AutoModeMapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView()
        mkv.isUserInteractionEnabled = false
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setUserTrackingMode(.follow, animated: true)
    }
    
}

struct AutoModeMapView_Previews: PreviewProvider {
    static var previews: some View {
        AutoModeMapView()
    }
}
