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
       
        let x : Int  = Int(shipView.frame.origin.x) / CELLSIZE;
        let y : Int = Int(shipView.frame.origin.y) / CELLSIZE;
        
        let firstSegment : Int = y * 10 + x;
        var i = 0
        
        while (i < self.length)  {
            if isRotated {
                self.segments.append(CGFloat(firstSegment) + CGFloat(i * 10))
            } else {
                self.segments.append(CGFloat(firstSegment) + CGFloat(i))
            }
            
           
            i += 1
        }
    }
}
