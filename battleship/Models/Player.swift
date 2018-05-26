//
//  Player.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 25/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit



class Player: NSObject {
    
    var name: String
    var id: String
    var ships: Array<Any>
    
    init(withName name: String) {
        self.name = name
        self.id = "0000000"
        self.ships = []
    }
    
}
