//
//  Ship.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 25/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

enum ShipType {
    case patrolBoat
    case submarine
    case cruiser
    case battleship
    case carrier
}

class Ship: NSObject {

    var type: ShipType
    var length: NSInteger
    
    var segments: Array<Any>
    var hitSegments: Array<Any>
    

    init(withType type: ShipType) {
        self.type = type
        self.segments = []
        self.hitSegments = []
        
        switch type {
        case .patrolBoat:
            self.length = 2
            break
        case .carrier:
            self.length = 5
            break
        case .cruiser:
            self.length = 3
            break
        case .battleship:
            self.length = 4
            break
        case .submarine:
            self.length = 3
            break
        }
    }
    
    func saveShipSegments(shipView: UIView) {
        
        let isRotated = shipView.frame.size.width < shipView.frame.size.height
       
        let x = shipView.frame.origin.x / CELLSIZE;
        let y = shipView.frame.origin.y / CELLSIZE;
        
        let firstSegment = y * 10 + x;
        var i = 0
        
        while (i < self.length)  {
            let segment = isRotated ? firstSegment + (CGFloat.init(i) * 10) : firstSegment + CGFloat.init(i)
            self.segments.append(segment)
            i += 1
        }
    }
}
