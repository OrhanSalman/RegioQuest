import ARKit
import SwiftUI
import MapKit
import CoreLocation
import Combine

/*

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var location: CLLocation
    let destinationCoordinate: CLLocationCoordinate2D
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView()
        // Füge AR-Box an der Zielkoordinate hinzu
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode(geometry: box)
        let boxAnchor = ARAnchor(transform:
                                    simd_float4x4(columns: (
                                        simd_float4(Float(destinationCoordinate.longitude), 0, Float(destinationCoordinate.latitude), 0),
                                        simd_float4(0, 1, 0, 0),
                                        simd_float4(0, 0, 1, 0),
                                        simd_float4(0, 0, 0, 1)
                                    ))
        )
        arView.session.add(anchor: boxAnchor)
        boxNode.addChildNode(SCNNode(geometry: SCNSphere(radius: 0.05)))
        boxAnchor.addChild(boxNode)
        
        // Berechne die Route zwischen dem aktuellen Standort und dem Ziel
        let currentLocation = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let destinationLocation = CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude)
        let distance = currentLocation.distance(from: destinationLocation)
        let direction = currentLocation.direction(to: destinationLocation)
        let steps = Int(distance)/5
        var lastStep = currentLocation
        for i in 1...steps {
            let stepLocation = lastStep.coordinateAt(distance: 5, bearing: direction)
            let sphere = SCNSphere(radius: 0.05)
            let sphereNode = SCNNode(geometry: sphere)
            let sphereAnchor = ARAnchor(transform: simd_float4x4(columns: (
                simd_float4(stepLocation.longitude, 0, stepLocation.latitude, 0),
                simd_float4(0, 1, 0, 0),
                simd_float4(0, 0, 1, 0),
                simd_float4(0, 0, 0, 1)
            )))
            arView.session.add(anchor: sphereAnchor)
            sphereNode.addChildNode(SCNNode(geometry: SCNSphere(radius: 0.05)))
            sphereAnchor.addChild(sphereNode)
            lastStep = CLLocation(latitude: stepLocation.latitude, longitude: stepLocation.longitude)
        }
        return arView
    }
    
    
}
*/
