//
//  Ship.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 25/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

enum ShipType {
    case PatrolBoat
    case Submarine
    case Cruiser
    case Battleship
    case Carrier
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
        case .PatrolBoat:
            self.length = 2
            break
        case .Carrier:
            self.length = 5
            break
        case .Cruiser:
            self.length = 3
            break
        case .Battleship:
            self.length = 4
            break
        case .Submarine:
            self.length = 3
            break
        }
    }
}
