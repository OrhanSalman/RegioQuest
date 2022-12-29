//
//  ARViewLoad.swift
//  asdf
//
//  Created by Orhan Salman on 20.12.22.
//

import SwiftUI
import RealityKit
import ARKit

struct ARViewLoad : View {
    var body: some View {
        return ARViewContainer().edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    /*
     var board = [
     ["1", false],    ["2", false],     ["3", false],     ["4", false],    ["5", false],    ["6", false],    ["7", false],
     ["8", false],    ["9", false],    ["10", false],    ["11", false],    ["12", false],    ["13", false],    ["14", false],
     ["15", false],    ["16", false],    ["17", false],    ["18", false],    ["19", false],    ["20", false],    ["21", false],
     ["22", false],    ["23", false],    ["24", false],    ["25", false],    ["26", false],    ["27", false],    ["28", false],
     ["29", false],    ["30", false],    ["31", false],    ["32", false],    ["33", false],    ["34", false],    ["35", false],
     ["36", false],    ["37", false],    ["38", false],    ["39", false],    ["40", false],    ["41", false],    ["42", false],
     ["45", false],    ["46", false],    ["47", false],    ["48", false],    ["49", false],    ["50", false],    ["51", false]
     ]
     */
    
    @State var board = [
        [1, false],    [2, false],     [3, false],     [4, false],    [5, false],    [6, false],    [7, false],
        [8, false],    [9, false],    [10, false],    [11, false],    [12, false],    [13, false],    [14, false],
        [15, false],    [16, false],    [17, false],    [18, false],    [19, false],    [20, false],    [21, false],
        [22, false],    [23, false],    [24, false],    [25, false],    [26, false],    [27, false],    [28, false],
        [29, false],    [30, false],    [31, false],    [32, false],    [33, false],    [34, false],    [35, false],
        [36, false],    [37, false],    [38, false],    [39, false],    [40, false],    [41, false],    [42, false]
    ]
    /*
     var row1 = [1, 8, 15, 22, 29, 36]
     var row2 = [2, 9, 16, 23, 30, 37]
     var row3 = [3, 10, 17, 24, 31, 38]
     var row4 = [4, 11, 18, 25, 32, 39]
     var row5 = [5, 12, 19, 26, 33, 40]
     var row6 = [7, 14, 21, 28, 35, 42]
     */
    
    @State var column1 = [
        [1, false],     // [0, 0] = 1     [0, 1] = false
        [8, false],     // [1, 0] = 8     [1, 1] = false
        [15, false],
        [22, false],
        [29, false],
        [36, false]
    ]
    @State var column2 = [
        [2, false],
        [9, false],
        [16, false],
        [23, false],
        [30, false],
        [37, false]
    ]
    @State var column3 = [
        [3, false],
        [10, false],
        [17, false],
        [24, false],
        [31, false],
        [38, false]
    ]
    @State var column4 = [
        [4, false],
        [11, false],
        [18, false],
        [25, false],
        [32, false],
        [39, false]
    ]
    @State var column5 = [
        [5, false],
        [12, false],
        [19, false],
        [26, false],
        [33, false],
        [40, false]
    ]
    @State var column6 = [
        [6, false],
        [13, false],
        [20, false],
        [27, false],
        [34, false],
        [41, false]
    ]
    @State var column7 = [
        [7, false],
        [14, false],
        [21, false],
        [28, false],
        [35, false],
        [42, false]
    ]
    
    func makeUIView(context: Context) -> ARView {
        
        var arView = ARView(frame: .zero)
        
        
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
        
        
        /*
         // Set debug options
         #if DEBUG
         arView.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
         #endif
         */
        
        // Load the "Box" scene from the "Experience" Reality File
        var boxAnchor = try! Experience.loadViergewinnt()
        // Add the box anchor to the scene
        
        
        boxAnchor.actions.col1.onAction = col1(_:)
        boxAnchor.actions.col7.onAction = col7(_:)
        arView.scene.anchors.append(boxAnchor)
        return arView
    }
    
    fileprivate func col1(_ entity: Entity?) {
        
        var found = false
        
        while found == false {
            for (index, number) in column1.reversed().enumerated() {
                if var firstCellToPlace = column1.firstIndex(where: { $0[1] as! Bool == false } ) {
                    
                    if found {
                        break
                    }
                    
                    let clipName = "clip\(number[0])"
                    
                    
                    var modelEntity = entity?.findEntity(named: clipName)?.children[0] as! ModelEntity
                    var material = SimpleMaterial(color: .red, isMetallic: false)
                    modelEntity.model?.materials = [material]
                    modelEntity.model?.materials[0] = material
                    
                    
                    print("Found \(number) at position \(index)")
                    
                    // Set to true
                    //                    col1[index][1] = true
                    found = true
                    
                }
                
                //                print("Found \(number) at position \(index)")
                /* Standard Output
                 Found [36, false] at position 0
                 Found [29, false] at position 1
                 Found [22, false] at position 2
                 Found [15, false] at position 3
                 Found [8, false] at position 4
                 Found [1, false] at position 5
                 */
                
                
            }
        }
        
        //        var  = try! Experience.loadViergewinnt().1?.children[0] as! ModelEntity
        
        //        var modelEntity = entity?.children[0] as! ModelEntity
        
        
        //            print("ENTITY: \(entity?.name)")
        //        print(try! Experience.loadViergewinnt().actions.Tapped.identifier)
    }
    
    fileprivate func col7(_ entity: Entity?) {
        
        var found: Bool = false
        
            for (index, number) in column7.reversed().enumerated() {
                if var firstCellToPlace = column7.firstIndex(where: { $0[1] as! Bool == false } ) {
                    
                    if found {
                        print("STOP")
                    }
                    else {
                        let clipName = "clip\(number[0])"
                        
                        var a = entity?.components
                        var b = entity?.children[0]
                        
                        print("___________________________________________________________________")
                        print("CLIPNAME: \(clipName)")
                        print(entity?.findEntity(named: "\(clipName)")?.children[0])
                        print("___________________________________________________________________")
                        
                        /*
                         var modelEntity = entity?.findEntity(named: "\(clipName)")?.children[0] as! ModelEntity
                         var material = SimpleMaterial(color: .green, isMetallic: false)
                         modelEntity.model?.materials = [material]
                         modelEntity.model?.materials[0] = material
                         */
                        //                    modelEntity.model?.materials[0] = material
                        
                        // Set to true
                        if index == 0 {
                            column7[5][1] = true
                        }
                        else if index == 1 {
                            column7[4][1] = true
                        }
                        else if index == 2 {
                            column7[3][1] = true
                        }
                        else if index == 3 {
                            column7[2][1] = true
                        }
                        else if index == 4 {
                            column7[1][1] = true
                        }
                        else if index == 5 {
                            column7[0][1] = true
                        }
                        else {
                            print("Index error")
                        }
                        
                        //                    print(column7)
                        // Stop looping
                        found = true
                    }
            }
        }
    }
    
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    /*
     func handleTapOnEntity(_ entity: Entity?) {
     guard var entity = entity else { return }
     // Do something with entity...
     
     }
     */
    
}

#if DEBUG
struct ARViewLoad_Previews : PreviewProvider {
    static var previews: some View {
        ARViewLoad()
    }
}
#endif
