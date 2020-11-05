//
//  FixedMapView.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//

import SwiftUI
import MapKit

struct FixedMapView: UIViewRepresentable {

    
    @ObservedObject var locationManager = LocationManager()
    //@State var timesOfRecenter : Int = 0
    
    private var recievedData : FinalDataStructure?

    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        mkv.setRegion(region, animated: true)
        mkv.showsUserLocation = true
        mkv.isUserInteractionEnabled = false
        
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        //uiView.showsUserLocation = true
        uiView.setCenter(coordinate, animated: true)
        //self.timesOfRecenter+=1
    }
    
}

struct FixedMapView_Previews: PreviewProvider {
    static var previews: some View {
        FixedMapView()
    }
}
