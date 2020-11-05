//
//  CellularInfoMapKitOverlay.swift
//  CellularInfo
//
//  Created by 王跃琨 on 2020/11/5.
//  with code snippets from https://www.raywenderlich.com/9956648-mapkit-tutorial-overlay-views
//

import Foundation
import MapKit

/*
class CellularInfoMapKitOverlay: NSObject, MKOverlay {
    
    let coordinate: CLLocationCoordinate2D
    let boundingMapRect: MKMapRect
    
    init(finalData: FinalDataStructure) {
        coordinate = finalData.Location
        boundingMapRect = nil
    }
    
}

class CellularInfoMapKitOverlayRenderer: MKOverlayRenderer {
    
    let overlayImage : UIImage
    
    override init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else {
            return
        }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
}

 */
