//
//  FixedMapView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//

import SwiftUI
import MapKit

struct FixedMapView: UIViewRepresentable {

    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct FixedMapView_Previews: PreviewProvider {
    static var previews: some View {
        FixedMapView()
    }
}
