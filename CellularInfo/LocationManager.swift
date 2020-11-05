//
//  LocationManager.swift
//  FView Cellular Info
//
//  Created by 王跃琨 on 2020/11/2.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    override init() {
        super.init()
        self.locationsManager.delegate = self
        self.locationsManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationsManager.requestWhenInUseAuthorization()
        self.locationsManager.pausesLocationUpdatesAutomatically = true
        self.locationsManager.startUpdatingLocation()
    }
    
    @Published var locationStatus: CLAuthorizationStatus? {
        willSet {
            objectWillChange.send()
        }
    }
    
    @Published var lastLocation: CLLocation? {
        willSet {
            objectWillChange.send()
        }
    }
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
        
    }
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    private let locationsManager = CLLocationManager()
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if (self.lastLocation != location){
            self.lastLocation = location}
        print(#function, location)
    }
    
}
