//
//  CompassView.swift
//  RegioQuest
//
//  Created by Orhan Salman on 24.01.23.
//


/*
import UIKit
import CoreLocation

class CompassView: UIView {
    let arrowImageView = UIImageView(image: UIImage(named: "arrow"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(arrowImageView)
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arrowImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            arrowImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCompass(to direction: CLLocationDirection) {
        arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(-direction))
    }
}


*/
