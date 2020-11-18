//
//  MapView.swift
//  FView Cellular Info
//
//  Created by 王跃琨 on 2020/11/2.
//

import SwiftUI
import MapKit
import CoreLocation

//MARK: Second page of the app that display a Map and a HeatMap overlay.
struct InteractiveMapView: UIViewRepresentable {
    
    //@ObservedObject var locationManager = LocationManager()
    let mapViewDelegate = MapViewDelegate()
    
    
    @State private var recievedData : [FinalDataStructure] = []
    @State private var heatMapData = NSMutableDictionary()
    @State private var heatMapDataHighLatency = NSMutableDictionary()
    @State private var heatMapDataLowLatency = NSMutableDictionary()
    @State private var lastMapRect: MKMapRect = MKMapRect(origin: MKMapPoint(x: 1, y: 1), size: MKMapSize(width: 1, height: 1))
    
    // let heatmap = DTMHeatmap()
    let heatmap = DTMDiffHeatmap()
    
    func makeUIView(context: Context) -> some MKMapView {
        
        let mkv = MKMapView(frame: .zero)
        
        // Set a Starting Point
        mkv.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 33.955348, longitude: 114.952843), span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)), animated: false)
        mkv.showsUserLocation = true
        mkv.showsScale = true
        mkv.setUserTrackingMode(.follow, animated: true)
        return mkv
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.delegate = mapViewDelegate
        //uiView.setUserTrackingMode(.follow, animated: true)
        
        // MARK: - Pull and Populate Heatmap. Third Attempt, Now progressively fetch data
        
        guard !MKMapRectEqualToRect(uiView.visibleMapRect, lastMapRect) else{
            return
        }
            
        let manager = CloudRelatedStuff.CloudKitManager()
        manager.PullData(visibleMapRect: uiView.visibleMapRect, completion: {(records, error) in
            guard error == .none , let mRecords = records else{
                //deal with error
                return
            }
            
            // Convert data structure
            DispatchQueue.main.async {
                for i in mRecords {
                    var data = FinalDataStructure()
                    data.populateWith(record: i)
                    self.recievedData.append(data)
                }
                
                // populate data
                for j in recievedData {
                    if (j.Location.latitude != 0)&&(j.Location.longitude != 0){
                        let weight: Double = j.AveragedPingLatency
                        let mapPoint = MKMapPoint(j.Location)
                        let value = NSValue(mkMapPoint: mapPoint)
                        
                        //heatMapData[value] = NSNumber(value: weight)
                        
                        if weight < 150 { // MARK: Differentiating Point
                            heatMapDataLowLatency[value] = NSNumber(value: 1)
                            //heatMapDataLowLatency[value] = NSNumber(value: weight)
                        }else {
                            heatMapDataHighLatency[value] = NSNumber(value: 1)
                            //heatMapDataHighLatency[value] = NSNumber(value: weight)
                        }
                    }
                }
                
                // Add to heatmap
                //heatmap.setData(heatMapData as? [AnyHashable : Any])
                heatmap.setBeforeData(heatMapDataLowLatency as? [AnyHashable : Any], afterData: heatMapDataHighLatency as? [AnyHashable : Any])
                
                uiView.addOverlay(heatmap)
                print("InteractiveMapView: New Data Points Added")
                lastMapRect = uiView.visibleMapRect
                
            }
        })
        
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
