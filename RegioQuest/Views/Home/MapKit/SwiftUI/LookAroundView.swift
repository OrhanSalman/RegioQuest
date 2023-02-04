//
//  LookAroundView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 29.01.23.
//

import SwiftUI
import MapKit

struct LookAroundView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MKLookAroundViewController
    
    @Binding var tappedLocation: CLLocationCoordinate2D?
    @Binding var showLookAroundView: Bool
    
    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        return MKLookAroundViewController()
    }
    
    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        if let tappedLocation {
            Task {
                let scene = await getScene(tappedLocation: .init(latitude: tappedLocation.latitude, longitude: tappedLocation.longitude))

                if scene == nil {
                    withAnimation {
                        self.showLookAroundView = false
                    }
                    return
                }

                withAnimation {
                    self.showLookAroundView = true
                }

                uiViewController.scene = scene
            }
        }
    }
    
    func getScene(tappedLocation: CLLocationCoordinate2D?) async -> MKLookAroundScene? {
        if let latitude = tappedLocation?.latitude, let longitude = tappedLocation?.longitude {
            let sceneRequest = MKLookAroundSceneRequest(coordinate: .init(latitude: latitude, longitude: longitude))

            do {
                return try await sceneRequest.scene
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}

