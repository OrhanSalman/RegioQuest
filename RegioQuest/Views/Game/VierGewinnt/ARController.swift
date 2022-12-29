//
//  ARController.swift
//  RegioQuest
//
//  Created by Orhan Salman on 26.12.22.
//

import UIKit
import ARKit
import RealityKit

class ARController: UIViewController {
    // 1: create an ARView
    var arView = ARView(frame: .zero)
    
    override func loadView() {
        super.loadView()
        // 2: add the arView to the main view
        view.addSubview(arView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 3: assign a frame to arView
        arView.frame = view.frame
        // 4: access to your Reality Composer file only by it's name
        // and load the scene asynchronously, in this case it's Scene1
        
        /*
        Spinner.loadScene1Async { (result, error) in
            guard error == nil else {
                return
            }
            
            if let spinnerScene = result {
                // 5: add the spinnerScene as an anchor in arView
                self.arView.scene.addAnchor(spinnerScene)
            }
            
        }
     */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 6: create an ARWorldTrackingConfiguration
        let configuration = ARWorldTrackingConfiguration()
        // 7: run the configuration
        arView.session.run(configuration)
    }
}
