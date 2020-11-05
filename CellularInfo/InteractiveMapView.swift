//
//  MapView.swift
//  FView Cellular Info
//
//  Created by 王跃琨 on 2020/11/2.
//

import SwiftUI
import MapKit
import CoreLocation

struct InteractiveMapView: UIViewRepresentable {
    
    @ObservedObject var locationManager = LocationManager()
    let mapViewDelegate = MapViewDelegate()
    
    
    //private var recievedData : [FinalDataStructure]?

    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mkv.setRegion(region, animated: true)
        mkv.showsUserLocation = true
        
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.delegate = mapViewDelegate
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        
        //uiView.showsUserLocation = true
        uiView.setCenter(coordinate, animated: true)
        
        let heatmap = DTMHeatmap()
        var data = CloudRelatedStuff()
        data.getData()
        //heatmap.setData(data.recievedData)
        uiView.addOverlay(heatmap)
        
        //self.timesOfRecenter+=1
    }

}

class MapViewDelegate: NSObject, MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = DTMHeatmapRenderer(overlay: overlay)
        return renderer
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        InteractiveMapView()
    }
}
