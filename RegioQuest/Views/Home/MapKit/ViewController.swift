
import UIKit
import MapKit
import SwiftUI
import CoreData

class ViewController: UIViewController {
    
    @StateObject private var vm = FetchQuestModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    let context = CoreDataStack.shared.context
    
    @IBOutlet weak var mapView : MKMapView!
//    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapTypeSelector: UISegmentedControl!
    
    @IBOutlet weak var resetCenter: UILabel!
    
    let distance: CLLocationDistance = 650
    let pitch: CGFloat = 65
    let heading = 0.0
    var camera: MKMapCamera?
    
    let locationManager = CLLocationManager()
    
    var foundLocations : [MKMapItem] = []
    var foundAnnotations : [MKAnnotation] = []
    var selectedAnnotation: MKAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        var annotations = [MKPointAnnotation]()
        
        let fetchRequest: NSFetchRequest<Quest> = Quest.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            for i in entities {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                annotation.title = i.title
                annotation.subtitle = i.descripti ?? "Keine Beschreibung"
                annotations.append(annotation)
                mapView.addAnnotations(annotations)
//                mapView.addAnnotation(annotation)
                
                print("ANNOTATIONS: \(annotation)")
            }
        } catch {
            print("Fetch failed")
        }
        
        askUserLocation()
        // https://www.hackingwithswift.com/example-code/location/how-to-find-directions-using-mkmapview-and-mkdirectionsrequest
        configureMapArea()
        configureSegmentedControl()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let location = locationManager.location {
            lookForLatestLocation(location: location)
        }
    }
    
    func askUserLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func lookForLatestLocation(location: CLLocation) {
        self.mapView.showsUserLocation = true
        let region = MKCoordinateRegion(center: location.coordinate, span: .init(latitudeDelta: 8.005, longitudeDelta: 8.005))
        self.mapView.setCenter(location.coordinate, animated: true)
        self.mapView.setRegion(region, animated: true)
        self.mapView.userTrackingMode = .followWithHeading
        self.mapView.isRotateEnabled = false
        self.mapView.isZoomEnabled = false
        self.mapView.isScrollEnabled = false
        self.mapView.showsCompass = false
        
        camera = MKMapCamera(lookingAtCenter: location.coordinate,
            fromDistance: distance,
            pitch: pitch,
            heading: heading)
        mapView.camera = camera!
    }
    
    func configureSegmentedControl() {
        mapTypeSelector.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
    }
    
    @objc func selectionChanged() {
        switch mapTypeSelector.selectedSegmentIndex {
        case 0:
            mapView.preferredConfiguration = MKStandardMapConfiguration(elevationStyle: .realistic)
        case 1:
            mapView.preferredConfiguration = MKHybridMapConfiguration(elevationStyle: .realistic)
        case 2:
            mapView.preferredConfiguration = MKImageryMapConfiguration(elevationStyle: .realistic)
        default:
            break
        }
    }
    
    func configureMapArea() {
        let region = MKCoordinateRegion(center: .init(latitude: 50.874886, longitude: 8.025132), span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
        mapView.isZoomEnabled = true
  
        /*
        var annotations = [MKPointAnnotation]()
        
        let fetchRequest: NSFetchRequest<Quest> = Quest.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            for i in entities {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: i.latitude, longitude: i.longitude)
                annotation.title = i.title
                annotation.subtitle = i.descripti ?? "Keine Beschreibung"
                annotations.append(annotation)
//                mapView.addAnnotations(annotations)
                mapView.addAnnotation(annotation)
                
                print("ANNOTATIONS: \(annotation)")
            }
        } catch {
            print("Fetch failed")
        }
         */
    }

    
    /*
    func searchPlace() {
        mapView.removeAnnotations(foundAnnotations)
        foundAnnotations.removeAll()
        foundLocations.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchField.text
        request.region = MKCoordinateRegion(center: mapView.centerCoordinate, span: .init(latitudeDelta: 0.05, longitudeDelta: 0.05))
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let error = error as? MKError{
                print(error.localizedDescription)
            } else if let response {
                self.foundLocations = response.mapItems
                self.addPlacesToAnnotations()
            }
            search.cancel()
        }
        
    }
    */
    /*
    func addPlacesToAnnotations() {
        for location in foundLocations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.placemark.coordinate
            annotation.title = location.name ?? ""
            self.foundAnnotations.append(annotation)
        }
        self.mapView.addAnnotations(foundAnnotations)
    }
    */
}

extension ViewController : CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            if let location = manager.location {
                self.mapView.showsUserLocation = true
                let region = MKCoordinateRegion(center: location.coordinate, span: .init(latitudeDelta: 0.005, longitudeDelta: 0.005))
                self.mapView.setCenter(location.coordinate, animated: true)
                self.mapView.setRegion(region, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            lookForLatestLocation(location: location)
        }
    }
}


extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let view = MKMarkerAnnotationView()
        view.animatesWhenAdded = true
        view.annotation = annotation
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        if annotation is MKUserLocation { return }
        if annotation is MKMapFeatureAnnotation { return }
        selectedAnnotation = annotation
        presentWithSheet(item: annotation)
    }
    /*
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let destination = MKPlacemark(coordinate: view.annotation!.coordinate)
        let source = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let routes = response?.routes else { return }
            for route in routes {
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            return renderer
        } else {
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func presentWithSheet(item: MKAnnotation) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MarkerDetailViewController") as? MarkerDetailViewController else { return }
        vc.selectedItem = foundLocations.filter({ $0.placemark.coordinate == item.coordinate }).first
        if let sheet = vc.sheetPresentationController {
            sheet.delegate = self
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(vc, animated: true)
        
        print("ANNOTATIONSS: \(foundLocations.filter({ $0.placemark.coordinate == item.coordinate }).first)")
        
    }
}

extension ViewController: UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if let selectedAnnotation{
            mapView.deselectAnnotation(selectedAnnotation, animated: true)
            self.selectedAnnotation = nil
        }
    }
}
/*
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
           !text.isEmpty{
            textField.resignFirstResponder()
            searchPlace()
        }
        return true
    }
    
}
*/
extension CLLocationCoordinate2D : Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}
