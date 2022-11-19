//
//  LoginViewController.swift
//  RegioQuest
//
//  Created by Orhan Salman on 16.11.22.
//

import UIKit
import SwiftUI

class LoginViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    @IBSegueAction func segueToSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        return UIHostingController(coder: coder, rootView: StoryView())
    }
    let swiftUIController = UIHostingController(rootView: StoryView())
    
    // goToSwiftUIView
    @IBAction func button(_ sender: Any) {
        let swiftUIViewController = UIHostingController(rootView: StoryView())
        self.navigationController?.pushViewController(swiftUIViewController, animated: true)

    }

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle("Navigiere", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        /*
        button.addTarget(self, action: #selector(button), for: .touchUpInside)
        view.addSubview(button)
        */
        label.text = "Ein Text"
        indicator.addSubview(label)
        


        
    }
}



func someLongTask() async -> Int {
    try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second
    return Int.random(in: 1 ... 6)
}
