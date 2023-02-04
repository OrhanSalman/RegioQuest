//
//  ARViewLoad.swift
//  asdf
//
//  Created by Orhan Salman on 20.12.22.
//

/*
import SwiftUI
import RealityKit
import ARKit

struct ARViewLoad : View {
    @State private var count = 5
    @State private var text = "Ende"
    @State private var showText = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Text("\(count)")
                    .font(.largeTitle)
                    .padding(.trailing)
            }
            Spacer()
            ARViewContainer().edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                self.count -= 1
                
                switch count {
                case 0:
                    count = 5
                default:
                    break
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @State private var counter = 0
    
    func makeUIView(context: Context) -> ARView {
        
        var arView = ARView(frame: .zero)
        /*
         // Start AR session
         var session = arView.session
         var config = ARWorldTrackingConfiguration()
         config.planeDetection = [.horizontal]
         session.run(config)
         
         // Add coaching overlay
         var coachingOverlay = ARCoachingOverlayView()
         coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         coachingOverlay.session = session
         coachingOverlay.goal = .horizontalPlane
         arView.addSubview(coachingOverlay)
         */
        
        /*
         // Set debug options
         #if DEBUG
         arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
         #endif
         */
        
        
        
        // Load the "Box" scene from the "Experience" Reality File
        let level = try! ARMath.loadSzene()
        // Add the box anchor to the scene
        arView.scene.anchors.append(level)
        
        
        for i in 1...6 {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                counter = i
                arView.scene.anchors.removeAll()
                
                switch counter {
                case 1:
                    let level1 = try! ARMath.loadSzene1()
                    arView.scene.anchors.append(level1)
                case 2:
                    let level2 = try! ARMath.loadSzene2()
                    arView.scene.anchors.append(level2)
                case 3:
                    let level3 = try! ARMath.loadSzene3()
                    arView.scene.anchors.append(level3)
                case 4:
                    let level4 = try! ARMath.loadSzene4()
                    arView.scene.anchors.append(level4)
                case 5:
                    let level5 = try! ARMath.loadSzene5()
                    arView.scene.anchors.append(level5)
                case 6:
                    let level6 = try! ARMath.loadSzene6()
                    arView.scene.anchors.append(level6)
                default:
                    let level = try! ARMath.loadSzene()
                    arView.scene.anchors.append(level)
                }
            }
        }
        
        
        return arView
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#if DEBUG
struct ARViewLoad_Previews : PreviewProvider {
    static var previews: some View {
        ARViewLoad()
    }
}
#endif

*/
