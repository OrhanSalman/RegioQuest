//
//  LetzterVersuch.swift
//  RegioQuest
//
//  Created by Orhan Salman on 25.01.23.
//


import ARKit
import MapKit
import SwiftUI
import CoreLocation
import simd

struct QuestGameView: View {
    @Environment(\.dismiss) var dismiss
    @State var quest: Quest
    
    var body: some View {
        VStack {
            ARView(quest: quest)
                .frame(height: UIScreen.main.bounds.height * 0.60)
                .padding(.zero)
            MapViewBottom(quest: quest)
                .padding(.zero)
            //                .frame(height: UIScreen.main.bounds.height * 0.38)
            Button(action: {
                dismiss()
            }, label: {
                Text("Beenden")
            })
            .padding(5)
        }
    }
}

struct ARView: UIViewRepresentable {
    
    @State var quest: Quest
    
    func makeUIView(context: Context) -> ARSCNView {
        
        let arView = ARSCNView()
        arView.automaticallyUpdatesLighting = true
        arView.session.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration)
        arView.autoenablesDefaultLighting = true
        return arView
    }
    
    func updateUIView(_ arView: ARSCNView, context: Context) {
        //        let location = CLLocationCoordinate2D(latitude: 50.956399, longitude: 7.987760)
        let scene = SCNScene()
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        box.materials = [material]
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(x: Float(quest.longitude), y: Float(quest.latitude), z: 0)
        scene.rootNode.addChildNode(node)
        arView.scene = scene
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        var control: ARView
        
        init(_ control: ARView) {
            self.control = control
        }
        
        func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
            switch camera.trackingState {
            case .normal:
                break
            case .notAvailable:
                break
            case .limited(let reason):
                switch reason {
                case .initializing:
                    break
                case .excessiveMotion:
                    break
                case .insufficientFeatures:
                    break
                case .relocalizing:
                    break
                @unknown default:
                    break
                }
            }
        }
    }
}


struct MapViewBottom: UIViewRepresentable {
    
    private let distance: CLLocationDistance = 0.1
    private let pitch: CGFloat = 150.0
    private let heading = 45.0
    
    @State var quest: Quest
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.isUserInteractionEnabled = false
        mapView.showsBuildings = true
        mapView.isPitchEnabled = true
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: quest.latitude, longitude: quest.longitude)
        annotation.title = quest.title
        mapView.addAnnotation(annotation)
        
        
        let camera: MKMapCamera?
        camera = MKMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: distance, pitch: pitch, heading: heading)
        mapView.camera = camera!
        
        return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let sourceCoordinate = uiView.userLocation.coordinate
        let destinationCoordinate = CLLocationCoordinate2D(latitude: quest.latitude, longitude: quest.longitude)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destinationItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            uiView.addOverlay(route.polyline, level: .aboveRoads)
        }
    }
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapViewBottom
        
        init(_ parent: MapViewBottom) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5.0
            return renderer
        }
    }
}

