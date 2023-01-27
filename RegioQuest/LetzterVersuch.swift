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

struct QuestGameView: View {
    var body: some View {
        VStack {
            ARView()
            MapViewBottom()
        }
    }
}

struct ARView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        arView.automaticallyUpdatesLighting = true
        arView.session.delegate = context.coordinator
        let configuration = ARWorldTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        arView.session.run(configuration)
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
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
    private let pitch: CGFloat = 0.0
    private let heading = 0.0
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .followWithHeading
        mapView.isUserInteractionEnabled = false
        mapView.showsBuildings = true
        mapView.isPitchEnabled = true
        
        
        
        /*
        let camera: MKMapCamera?
        camera = MKMapCamera(lookingAtCenter: mapView.centerCoordinate, fromDistance: distance, pitch: pitch, heading: heading)
        mapView.camera = camera!
        */
        return mapView
    }
    func updateUIView(_ uiView: MKMapView, context: Context) {}
}
