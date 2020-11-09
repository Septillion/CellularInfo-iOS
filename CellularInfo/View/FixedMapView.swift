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
    
    var coordinate: CLLocationCoordinate2D
 
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        //let coordinate = coordinate
        //let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        //mkv.setRegion(region, animated: false)
        //mkv.showsUserLocation = true
        mkv.isUserInteractionEnabled = false
        
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        //uiView.setUserTrackingMode(.follow, animated: false)
        uiView.setRegion(MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: false)
    }
    
}

struct FixedMapView_Previews: PreviewProvider {
    static var previews: some View {
        FixedMapView(coordinate: CLLocationCoordinate2D(latitude: 34.322700, longitude: 108.552500))
    }
}
