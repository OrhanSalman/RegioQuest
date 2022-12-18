//
//  HomeView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 10.11.22.
//

import SwiftUI
import MapKit


struct HomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \User.id, ascending: true)],
        animation: .default) var user: FetchedResults<User>
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        // We use this View as mother view for some other views to which we can navigate from the HomePage
        
        switch viewRouter.currentView {
        case .HomeView:
            HomePage()
        case .OrteView:
            OrteView()
        case .AboutThisAppView:
            AboutThisAppView()
        }
    }
}

struct HomePage: View {
    @State var sheet: Bool = false
    @StateObject var content = HomeViewContents()
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        VStack {
                            VStack {
                                Image("spielerischregio")
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .clipped()
                            
                            VStack {
                                VStack {
                                    Text("Universitätsstadt Siegen")
                                        .font(.title2.weight(.thin))
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            self.sheet.toggle()
                                        }
                                }
                                .sheet(isPresented: $sheet) {
                                    RegionSheet()
                                }
                                TopTapBarView()
                                Divider()
                                ContentView(textContent: content.homeViewContentsMap)
                                ContentView(textContent: content.homeViewContentsOrte)
                                ContentView(textContent: content.homeViewContentsStories)
                                ContentView(textContent: content.homeViewContentsInfo)
                            }
                        }
                    }
                    .background {
                        VStack {
                            LinearGradient(gradient: Gradient(colors: [.indigo, .black.opacity(0)]), startPoint: .top, endPoint: .bottom)
                                .rotationEffect(.degrees(0), anchor: .center)
//                                .frame(height: UIScreen.main.bounds.height * 0.5)
                                .clipped()
                                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                                .offset(x: 0, y: -100)
                            Spacer()
                            LinearGradient(gradient: Gradient(colors: [.indigo, .black.opacity(0)]), startPoint: .bottom, endPoint: .top)
                                .rotationEffect(.degrees(0), anchor: .center)
//                                .frame(height: UIScreen.main.bounds.height * 0.5)
                                .clipped()
                                .mask { RoundedRectangle(cornerRadius: 10, style: .continuous) }
                                .offset(x: 0, y: +100)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct TopTapBarView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    var body: some View {
        VStack(spacing: 25) {
            HStack(spacing: 25) {
                Button(action: {
                    withAnimation {
                        viewRouter.currentView = .OrteView
                    }
                }, label: {
                    Image(systemName: "map")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.pink.opacity(0.75))
                        .scaleEffect(1.2, anchor: .center)
                })
                Button(action: {
                }, label: {
                    Image(systemName: "building.2.crop.circle")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.pink.opacity(0.75))
                        .scaleEffect(1.2, anchor: .center)
                })
                NavigationLink(destination: StoryView()) {
                    Image(systemName: "person.wave.2")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.pink.opacity(0.75))
                        .scaleEffect(1.2, anchor: .center)
                }
                NavigationLink(destination: AboutThisAppView()) {
                    Image(systemName: "info.square")
                        .imageScale(.medium)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.pink.opacity(0.75))
                        .scaleEffect(1.2, anchor: .center)
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(Color(.quaternaryLabel), lineWidth: 1)
                    .scaleEffect(1.4, anchor: .center)
                    .shadow(color: .primary.opacity(0.9), radius: 5, x: 0, y: 0)
            }
            Divider()
                .padding(.horizontal, 60)
        }
        .padding()
    }
}

struct ContentView: View {
    @State var textContent: [String]
    var body: some View {
        VStack {
            VStack(spacing: 4) {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.indigo, .pink]), startPoint: .top, endPoint: .bottom)
                        .mask { RoundedRectangle(cornerRadius: 18, style: .continuous) }
                        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    Image(systemName: textContent[0])
                        .imageScale(.large)
                        .symbolRenderingMode(.monochrome)
                        .foregroundColor(.white)
                        .font(.largeTitle.weight(.light))
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 3)
                }
                .frame(width: 80, height: 80)
                .clipped()
                .padding(.bottom, 8)
                Text(textContent[1])
                    .font(.title.weight(.regular))
                    .multilineTextAlignment(.center)
                Text(textContent[2])
                    .font(.footnote.weight(.regular))
                    .frame(width: 280)
                    .clipped()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.top, 48)
            .padding(.bottom, 32)
            VStack(spacing: 24) {
                HStack {
                    Image(systemName: textContent[3])
                        .foregroundColor(.pink)
                        .font(.title.weight(.regular))
                        .frame(width: 60, height: 50)
                        .clipped()
                    VStack(alignment: .leading, spacing: 3) {
                        Text(textContent[4])
                            .font(.footnote.weight(.regular))
                        Text(textContent[5])
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                HStack {
                    Image(systemName: textContent[6])
                        .foregroundColor(.pink)
                        .font(.title.weight(.regular))
                        .frame(width: 60, height: 50)
                        .clipped()
                    VStack(alignment: .leading, spacing: 3) {
                        Text(textContent[7])
                            .font(.footnote.weight(.regular))
                        Text(textContent[8])
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                HStack {
                    Image(systemName: textContent[9])
                        .foregroundColor(.pink)
                        .font(.title.weight(.regular))
                        .frame(width: 60, height: 50)
                        .clipped()
                    VStack(alignment: .leading, spacing: 3) {
                        Text(textContent[10])
                            .font(.footnote.weight(.regular))
                        Text(textContent[11])
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity)
        .clipped()
        .padding(.bottom, 40)
        .padding(.horizontal, 29)
        .overlay(alignment: .top) {
            Group {
                
            }
        }
    }
}
struct RegionSheet: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 50.8838, longitude: 8.0210),
        span: MKCoordinateSpan(latitudeDelta: 0.18, longitudeDelta: 0.18)
    )
    /*
     How to get region coordinates:
     https://gis.stackexchange.com/questions/183248/getting-polygon-boundaries-of-city-in-json-from-google-maps-api
     */
    @State private var coordArr = [[7.9195,50.938],[7.922,50.9405],[7.928,50.9385],[7.9335,50.939],[7.935,50.938],[7.939,50.939],[7.9385,50.941],[7.9405,50.9425],[7.9425,50.9425],[7.944,50.9415],[7.948,50.944],[7.951,50.944],[7.9525,50.9405],[7.954,50.94],[7.9575,50.9405],[7.9585,50.9425],[7.961,50.9425],[7.9615,50.9415],[7.964,50.9425],[7.9665,50.942],[7.965,50.944],[7.965,50.9455],[7.9665,50.947],[7.976,50.9475],[7.977,50.946],[7.98,50.9475],[7.9815,50.946],[7.984,50.9465],[7.991,50.9445],[7.9915,50.945],[7.995,50.9445],[7.9985,50.941],[7.9985,50.938],[8.001,50.935],[8.0025,50.935],[8.009,50.9295],[8.0135,50.9295],[8.016,50.9265],[8.0195,50.928],[8.0195,50.9315],[8.0215,50.934],[8.0215,50.9365],[8.0165,50.942],[8.016,50.944],[8.017,50.948],[8.021,50.9525],[8.0225,50.953],[8.0265,50.9525],[8.028,50.9535],[8.0325,50.953],[8.0355,50.9515],[8.0425,50.952],[8.047,50.9465],[8.0485,50.942],[8.0545,50.94],[8.056,50.9385],[8.0565,50.9355],[8.058,50.9355],[8.06,50.934],[8.06,50.932],[8.059,50.931],[8.0595,50.929],[8.0575,50.927],[8.053,50.925],[8.052,50.922],[8.049,50.92],[8.0485,50.918],[8.044,50.9165],[8.0375,50.917],[8.0405,50.9135],[8.0415,50.9135],[8.043,50.912],[8.043,50.911],[8.0445,50.911],[8.048,50.909],[8.049,50.908],[8.0495,50.9055],[8.0535,50.904],[8.0575,50.9],[8.0655,50.901],[8.0725,50.9005],[8.0735,50.9],[8.074,50.8985],[8.0785,50.8985],[8.082,50.899],[8.0835,50.901],[8.0875,50.901],[8.089,50.9],[8.091,50.9],[8.095,50.9005],[8.098,50.9025],[8.1,50.9025],[8.1015,50.901],[8.108,50.8995],[8.1105,50.895],[8.1205,50.8875],[8.1255,50.8825],[8.1255,50.8815],[8.1295,50.8785],[8.13,50.876],[8.1265,50.8715],[8.124,50.8705],[8.117,50.871],[8.1115,50.8695],[8.108,50.869],[8.1075,50.8695],[8.1055,50.8685],[8.1035,50.8685],[8.101,50.87],[8.098,50.8695],[8.0925,50.864],[8.086,50.864],[8.085,50.8645],[8.0845,50.866],[8.0815,50.866],[8.0835,50.863],[8.0835,50.861],[8.082,50.86],[8.072,50.859],[8.0695,50.8575],[8.067,50.859],[8.062,50.858],[8.061,50.8575],[8.0605,50.8555],[8.058,50.855],[8.0575,50.853],[8.0555,50.852],[8.0535,50.8525],[8.053,50.85],[8.0515,50.849],[8.0495,50.849],[8.0535,50.8465],[8.0555,50.8435],[8.0545,50.8415],[8.0525,50.841],[8.0545,50.8345],[8.0525,50.833],[8.052,50.831],[8.054,50.8305],[8.055,50.829],[8.055,50.826],[8.0535,50.8245],[8.054,50.8235],[8.0535,50.816],[8.0525,50.815],[8.043,50.813],[8.024,50.818],[8.019,50.818],[8.0045,50.814],[8.003,50.813],[8.001,50.8135],[7.993,50.8095],[7.986,50.8095],[7.981,50.812],[7.9715,50.8125],[7.9705,50.8135],[7.9705,50.8155],[7.972,50.8175],[7.972,50.819],[7.974,50.821],[7.974,50.8255],[7.972,50.8275],[7.972,50.8295],[7.9745,50.8315],[7.9725,50.8315],[7.972,50.8325],[7.969,50.833],[7.966,50.835],[7.965,50.8385],[7.9665,50.84],[7.9655,50.842],[7.9635,50.843],[7.9615,50.8455],[7.9575,50.8465],[7.954,50.844],[7.948,50.844],[7.9435,50.846],[7.938,50.8465],[7.935,50.845],[7.9305,50.845],[7.927,50.843],[7.9245,50.843],[7.923,50.845],[7.923,50.847],[7.924,50.848],[7.93,50.851],[7.932,50.853],[7.934,50.8535],[7.937,50.8565],[7.9365,50.8585],[7.934,50.8585],[7.933,50.8595],[7.933,50.8615],[7.931,50.8615],[7.93,50.8625],[7.9295,50.867],[7.932,50.8695],[7.932,50.875],[7.9345,50.878],[7.936,50.8785],[7.937,50.8805],[7.9375,50.882],[7.936,50.8835],[7.936,50.886],[7.937,50.8865],[7.9375,50.889],[7.939,50.8905],[7.941,50.891],[7.941,50.8925],[7.942,50.8935],[7.9445,50.8945],[7.9495,50.8925],[7.9505,50.896],[7.9535,50.8975],[7.9525,50.902],[7.954,50.904],[7.955,50.91],[7.9535,50.9115],[7.9545,50.9145],[7.9495,50.9195],[7.949,50.9215],[7.9435,50.922],[7.939,50.924],[7.9375,50.9255],[7.937,50.929],[7.9265,50.931],[7.9255,50.9325],[7.924,50.9325],[7.9215,50.934],[7.9205,50.936],[7.9195,50.938]]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                MapView(region: region, lineCoordinates: coordArr.map {
                    CLLocationCoordinate2D(latitude: $0[1], longitude: $0[0])
                })
                .frame(height: UIScreen.main.bounds.height * 0.50)
                Divider()
                    .padding(.horizontal, 35)
                
                VStack {
                    Text("Siegen ist die südlichste Stadt Westfalens bzw. des Siegerlands. Sie liegt in einem verzweigten Talkessel der oberen Sieg. Neben der Sieg sind die größten nennenswerten Fließgewässer innerhalb des Stadtgebiets die Sieg-Zuflüsse Ferndorf, Weiß, Alche, Eisernbach und Gosenbach. Vom Talkessel zweigen noch weitere zahlreiche Nebentäler ab. Die Höhen der umgebenden Berge sind, sofern nicht besiedelt, von Niederwald bedeckt. Nördlich schließt sich das Sauerland an, im Nordosten das Wittgensteiner Land im Rothaargebirge, südlich der Westerwald und im Westen das Wildenburger Land. Die nächsten größeren Städte in der Umgebung von Siegen sind (in durchschnittlicher Verkehrsentfernung) im Norden Hagen (83 km), im Südosten Frankfurt am Main (125 km), im Südwesten Koblenz (105 km) und im Westen Köln (93 km). Die räumlichen Entfernungen (Luftlinie) zu den umliegenden Großstädten betragen in etwa 65 km (Hagen), 95 km (Frankfurt), 65 km (Koblenz) und 75 km (Köln).")
                }
                .padding(20)
                VStack(spacing: 10) {
                    HStack {
                        Text("Universität")
                        Spacer()
                        Text("✓")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 30)
                    HStack {
                        Text("Industrie")
                        Spacer()
                        Text("✓")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 30)
                    HStack {
                        Text("Ausbildungsplätze")
                        Spacer()
                        Text("✓")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 30)
                    HStack {
                        Text("Freizeit")
                        Spacer()
                        Text("✓")
                            .foregroundColor(.green)
                    }
                    .padding(.horizontal, 30)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ViewRouter())
    }
}

