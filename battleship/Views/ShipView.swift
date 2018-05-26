//
//  ShipView.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 26/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

class ShipView: UIView {

    var isRotated = false
    var shipType: ShipType?
    
    var originLocation: CGPoint?
    var originFrame: CGRect?
    var originBounds: CGRect?
    var originSuperView: UIView?
    

    func store() {
        originLocation = self.center
        originSuperView = self.superview
        originFrame = self.frame
        originBounds = self.bounds
    }
    
    func restore() {
        originSuperView!.addSubview(self)
        self.center = originLocation!
        self.frame = originFrame!
        self.bounds = originBounds!
        self.isUserInteractionEnabled = true
    }

}
