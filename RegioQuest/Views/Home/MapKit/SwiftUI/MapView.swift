
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.isUserInteractionEnabled = false
        
//        mapView.layer.opacity = 0.5
        // Polyline
        /*
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        */
        let polygon = MKPolygon(coordinates: lineCoordinates, count: lineCoordinates.count)
        
        mapView.addOverlay(polygon)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = #colorLiteral(red: 0, green: 0.6862745098, blue: 0.7607843137, alpha: 1)
            renderer.lineWidth = 5.0
            return renderer
        }
        else if overlay is MKPolygon {
            let renderer = MKPolygonRenderer(overlay: overlay)
            renderer.fillColor = UIColor.gray.withAlphaComponent(0.2)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
}

