import SwiftUI
import MapKit

struct ContentView: View {
  @State private var region = MKCoordinateRegion(
    // Apple Park
    center: CLLocationCoordinate2D(latitude: 37.334803, longitude: -122.008965),
    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
  )

  @State private var lineCoordinates = [

    // Steve Jobs theatre
    CLLocationCoordinate2D(latitude: 37.330828, longitude: -122.007495),

    // Caffè Macs
    CLLocationCoordinate2D(latitude: 37.336083, longitude: -122.007356),

    // Apple wellness center
    CLLocationCoordinate2D(latitude: 37.336901, longitude:  -122.012345)
  ];

  var body: some View {
    MapView(
      region: region,
      lineCoordinates: lineCoordinates
    )
      .edgesIgnoringSafeArea(.all)
  }
}
