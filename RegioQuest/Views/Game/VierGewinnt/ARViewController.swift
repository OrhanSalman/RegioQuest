//
//  ARController.swift
//  RegioQuest
//
//  Created by Orhan Salman on 26.12.22.
//


import ARKit
import CoreLocation


import ARKit
import CoreLocation
import MapKit

class ARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    
    let locationManager = CLLocationManager()
    var destinationCoordinate: CLLocationCoordinate2D!
    var currentRoute: [CLLocationCoordinate2D] = []
    var currentLocationNode: SCNNode?
    var routeNodes: [SCNNode] = []
    var currentHeading: CLHeading?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destinationCoordinate = CLLocationCoordinate2D(latitude: 50.955203, longitude: 7.992895)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Set up location manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let currentLocation = locationManager.location else { return }
        guard let destination = destinationCoordinate else { return }
        guard let currentHeading = currentHeading else { return }
        
        let currentPosition = SCNVector3(currentLocation.coordinate.latitude, currentLocation.altitude, currentLocation.coordinate.longitude)
        if currentLocationNode == nil {
            currentLocationNode = createSphereNode(at: currentPosition, with: UIColor.red)
            sceneView.scene.rootNode.addChildNode(currentLocationNode!)
        } else {
            currentLocationNode?.position = currentPosition
        }
        
        if currentRoute.count == 0 {
            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
            directionRequest.transportType = .automobile
            
            let directions = MKDirections(request: directionRequest)
            directions.calculate { (response, error) in
                guard let response = response else { return }
                
                let route = response.routes[0].polyline
                var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid, count: route.pointCount)
                route.getCoordinates(&coords, range: NSRange(location: 0, length: route.pointCount))
                self.currentRoute = coords
                for i in 0..<self.currentRoute.count {
                    let currentStep = self.currentRoute[i]
                    let nextStep = self.currentRoute[i + 1]
                    let heading = self.getHeading(from: currentStep, to: nextStep)
                    let rotation = simd_quatf(angle: Float(heading), axis: simd_float3(0, 1, 0))
                    let position = SCNVector3(currentStep.latitude, currentLocation.altitude, currentStep.longitude)
                    let arrowNode = self.createArrowNode(at: position, with: UIColor.green, rotation: rotation)
                    self.routeNodes.append(arrowNode)
                    self.sceneView.scene.rootNode.addChildNode(arrowNode)
                }
            }
            
        } else {
            let currentStep = currentRoute[0]
            let nextStep = currentRoute[1]
            let heading = getHeading(from: currentStep, to: nextStep)
            let rotation = simd_quatf(angle: Float(heading), axis: simd_float3(0, 1, 0))
            currentLocationNode?.simdOrientation = rotation
        }
        
    }
    
    
    func createSphereNode(at position: SCNVector3, with color: UIColor) -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        sphere.firstMaterial?.diffuse.contents = color
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.position = position
        return sphereNode
    }
    
    func createArrowNode(at position: SCNVector3, with color: UIColor, rotation: simd_quatf) -> SCNNode {
            let arrow = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
            arrow.firstMaterial?.diffuse.contents = UIImage(systemName: "arrow.right")
            arrow.firstMaterial?.diffuse.wrapS = .repeat
            arrow.firstMaterial?.diffuse.wrapT = .repeat
            let arrowNode = SCNNode(geometry: arrow)
            arrowNode.position = position
            arrowNode.simdOrientation = rotation
            arrowNode.scale = SCNVector3(0.01, 0.01, 0.01)
            return arrowNode
        }

    
//    func createArrowNode(at position: SCNVector3, with color: UIColor, rotation: simd_quatf) -> SCNNode {
//        let arrow = SCNScene(named: "art.scnassets/arrow.scn")!.rootNode.clone()
//        arrow.position = position
//        arrow.simdOrientation = rotation
//        arrow.scale = SCNVector3(0.1, 0.1, 0.1)
//        arrow.geometry?.firstMaterial?.diffuse.contents = color
//        return arrow
//    }
    
    func getHeading(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
        let fLat = from.latitude * Double.pi / 180
        let fLng = from.longitude * Double.pi / 180
        let tLat = to.latitude * Double.pi / 180
        let tLng = to.longitude * Double.pi / 180
        let degree = atan2(sin(tLng - fLng) * cos(tLat), cos(fLat) * sin(tLat) - sin(fLat) * cos(tLat) * cos(tLng - fLng))
        return degree
    }
    
}

/*
struct MapViewContainer: UIViewRepresentable {
    @Binding var currentLocation: CLLocation
    @Binding var destination: CLLocationCoordinate2D
    @Binding var currentRoute: [CLLocationCoordinate2D]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        let currentLocation = CLLocation(latitude: self.currentLocation.coordinate.latitude, longitude: self.currentLocation.coordinate.longitude)
        let destination = CLLocation(latitude: self.destination.latitude, longitude: self.destination.longitude)

        let directionRequest = MKDirections.Request()
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
        directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        directionRequest.transportType = .automobile

        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else { return }

            let route = response.routes[0].polyline
            uiView.addOverlay(route)
            uiView.setVisibleMapRect(route.boundingMapRect, animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
            var parent: MapViewContainer

            init(_ parent: MapViewContainer) {
                self.parent = parent
            }

            func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = UIColor.blue
                renderer.lineWidth = 5
                return renderer
            }
        }
    }
*/


/*
 class ARViewController: UIViewController, ARSCNViewDelegate, CLLocationManagerDelegate {
 
 let configuration = ARWorldTrackingConfiguration()
 let locationManager = CLLocationManager()
 let targetCoordinate = CLLocationCoordinate2D(latitude: 50.955203, longitude: 7.992895) // Replace with your target coordinate
 //    var sceneView = ARSCNView()
 @IBOutlet var sceneView: ARSCNView!
 var arrowNode = SCNNode()
 @IBOutlet var arrowImageView: UIImageView!
 //    var arrowImageView = UIImageView()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 // Set up ARKit scene
 sceneView = ARSCNView(frame: view.frame)
 sceneView.delegate = self
 sceneView.session.run(configuration)
 view.addSubview(sceneView)
 
 // Set up location manager
 locationManager.delegate = self
 locationManager.startUpdatingHeading()
 
 /*
  // Add 3D arrow model as AR object
  let arrowScene = SCNScene(named: "art.scnassets/arrow.scn")!
  arrowNode = arrowScene.rootNode.childNode(withName: "arrow", recursively: true)!
  sceneView.scene.rootNode.addChildNode(arrowNode)
  */
 
 // Add arrow image view as a subview
 arrowImageView = UIImageView(image: UIImage(named: "regio"))
 arrowImageView.contentMode = .scaleAspectFit
 arrowImageView.frame = CGRect(x: view.frame.midX - 25, y: view.frame.midY - 25, width: 50, height: 50)
 view.addSubview(arrowImageView)
 
 }
 
 func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
 let currentLocation = CLLocation(latitude: locationManager.location!.coordinate.latitude, longitude: locationManager.location!.coordinate.longitude)
 let targetLocation = CLLocation(latitude: targetCoordinate.latitude, longitude: targetCoordinate.longitude)
 let distance = targetLocation.distance(from: currentLocation)
 let direction = newHeading.magneticHeading
 let angle = bearing(from: currentLocation, to: targetLocation) - direction
 arrowNode.eulerAngles.y = Float(angle)
 if distance < 10 {
 print("You have reached the target")
 }
 }
 func bearing(from: CLLocation, to: CLLocation) -> Double {
 let lat1 = from.coordinate.latitude.toRadians()
 let lon1 = from.coordinate.longitude.toRadians()
 let lat2 = to.coordinate.latitude.toRadians()
 let lon2 = to.coordinate.longitude.toRadians()
 
 let dLon = lon2 - lon1
 let y = sin(dLon) * cos(lat2)
 let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
 return atan2(y, x).toDegrees()
 }
 }
 
 extension Double {
 func toRadians() -> Double {
 return self * .pi / 180
 }
 func toDegrees() -> Double {
 return self * 180 / .pi
 }
 }
 */
