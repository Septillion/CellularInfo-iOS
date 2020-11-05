//
//  MapView.swift
//  FView Cellular Info
//
//  Created by 王跃琨 on 2020/11/2.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @ObservedObject var locationManager = LocationManager()
    
    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mkv.setRegion(region, animated: true)
        mkv.showsUserLocation = true
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        //uiView.showsUserLocation = true
        
        uiView.setCenter(coordinate, animated: true)
        
    }
    
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
