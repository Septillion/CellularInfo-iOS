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
    
    
    @State private var recievedData : [FinalDataStructure] = []
    @State private var heatMapData = NSMutableDictionary()

    
    func makeUIView(context: Context) -> some MKMapView {
        let mkv = MKMapView(frame: .zero)
        
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        mkv.setRegion(region, animated: true)
        mkv.showsUserLocation = true
        
        var heatmap = DTMHeatmap()
        let manager = CloudRelatedStuff.CloudKitManager()
        manager.PullData(completion: {(records, error) in
            guard error == .none , let mRecords = records else{
                //deal with error
                return
            }
            
            DispatchQueue.main.async {
                for i in mRecords {
                    var data = FinalDataStructure()
                    data.populateWith(record: i)
                    self.recievedData.append(data)
                }
                
                for j in recievedData {
                    if j.Location != nil{
                        let weight: Double = 1
                        let mapPoint = MKMapPoint(j.Location!)
                        let value = NSValue(mkMapPoint: mapPoint)
                        heatMapData[value] = NSNumber(value: weight)
                    }
                }
                
                heatmap.setData(heatMapData as? [AnyHashable : Any])
                mkv.addOverlay(heatmap)
                
            }
        })
        
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.delegate = mapViewDelegate
        let coordinate = locationManager.lastLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 39.908743, longitude: 116.397573)
        
        //uiView.setCenter(coordinate, animated: true)
        

        
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
