//
//  LocationManager.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import MapKit
import CoreLocation
import UIKit


final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Start region to Siegen
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50.87489, longitude: 8.02513), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
//    @Published var location: CLLocationCoordinate2D?
    @Published var location: CLLocationCoordinate2D?
    var locationManager: CLLocationManager?
    
    override init() {
         super.init()
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager?.startUpdatingLocation()
        } else {
            checkLocationAuthorization()
            locationManager?.requestAlwaysAuthorization()
        }
     }

     func requestLocation() {
         locationManager?.requestLocation()
     }
        
    
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else {
            return
        }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            print("Your location is restricted likely due to parental controls.")
        case .denied:
            print("You have denied this app location permission. Go into your settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location ist: \(location)")
        
        self.location = location.coordinate
        self.region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            
        /*
        DispatchQueue.main.async {
            self.location = location.coordinate
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
        }
         */
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Handle any errors here...
        print ("error")
    }
}
