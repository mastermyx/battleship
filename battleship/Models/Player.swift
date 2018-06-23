//
//  Player.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 25/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

enum PlayerNumber : Int {
    case PlayerOne = 0
    case PlayerTwo = 1
}

enum PlayerType {
    case PlayerHuman
    case PlayerComputer
    case HumanVSHuman
    case HumanVSComputer
    case Online
}


class Player: NSObject {
    
    var name: String
    var id: String
    var ships: Array<Any>
    var type : PlayerType?
    
    override init() {
        self.name = ""
        self.id = "0000000"
        self.ships = []
        super.init()
    }
    
    init(withName name: String) {
        self.name = name
        self.id = "0000000"
        self.ships = []
    }
    
}
