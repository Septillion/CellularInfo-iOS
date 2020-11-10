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
        
        // Set a Starting Point
        mkv.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 34.322700, longitude: 108.552500), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)), animated: false)
        mkv.showsUserLocation = true
        
        let heatmap = DTMHeatmap()
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
                    if (j.Location.latitude != 0)&&(j.Location.longitude != 0){
                        let weight: Double = j.AveragedPingLatency
                        let mapPoint = MKMapPoint(j.Location)
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
        uiView.setUserTrackingMode(.follow, animated: true) 
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
