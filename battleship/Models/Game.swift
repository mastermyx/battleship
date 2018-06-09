//
//  Game.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 25/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit
enum GameEnd {
    case GameOver
    case GameQuit
}

enum GameState {
    case waiting
    case placing
    case playing
    case enemyPlaying
}

enum LatchState {
    case zeroLatch
    case upLatch
    case downLatch
    case leftLatch
    case rightLatch
    case allLatchUsed
    case latchSlotExpired
    case latchSlotActive
}


class Game: NSObject {

    var latch : [Int] = []
    var up : [Int] = []
    var down : [Int] = []
    var left : [Int] = []
    var right : [Int] = []
}
