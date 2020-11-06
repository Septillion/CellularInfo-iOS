//
//  FixedMapView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//

import SwiftUI
import MapKit

struct FixedMapView: UIViewRepresentable {

    //@ObservedObject var locationManager = LocationManager()
    
    private var recievedData : FinalDataStructure?

    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        let coordinate = CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mkv.setRegion(region, animated: true)
        mkv.showsUserLocation = true
        mkv.isUserInteractionEnabled = false
        
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setUserTrackingMode(.follow, animated: false)
    }
    
}

struct FixedMapView_Previews: PreviewProvider {
    static var previews: some View {
        FixedMapView()
    }
}
