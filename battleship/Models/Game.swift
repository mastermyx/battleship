//
//  Game.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 25/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

let dirty_point = CGPoint.init(x: -1, y: -1)


enum GameReason {
    case GameOver
    case GameQuit
}

enum GameState {
    case GameStatePreparation
    case GameStatePlacing
    case GameStatePlaying
    case GameStateGameOver
    case GameStateQuitting
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

protocol GameDelegate {
    func GamePreparation()
    func ShipPlacement()
    func GamePlaying(player: Int)
    func GameQuitWithReason(reason: GameReason)
    func GameRestart()
    func GamePlayWithAI()
    func AIShipPlacement()
}

class Game: NSObject {

    var latch : [Int] = []
    
    var up : [NSValue]?
    var down : [NSValue]?
    var left : [NSValue]?
    var right : [NSValue]?
    var used : [NSValue]?
    
    var playerOne : Player?
    var playerTwo : Player?
    
    var winner : Int?
   
    var gameState : GameState?
    var gameMode : Player
    
    func handleGridTapPoint(point: CGPoint, player : Int) -> Bool {
        let oppPlayer = player == 0 ? playerTwo! : playerOne!;
        
        let xIndex = point.x / CELLSIZE
        let yIndex = point.y / CELLSIZE
        
        let segment = yIndex * 10.0 + xIndex;
        
        let segmentObj = Int(segment)
            
        var hit_f = false
        
        for ship in oppPlayer.ships as! Array<Ship>{
            var isContained = false
            
            for number in ship.segments as! Array<Int> {
                if number == segmentObj {
                    isContained = true
                    hit_f = true
                    for number in ship.hitSegments as! Array<Int> {
                        if number == segmentObj {
                            isContained = false
                            break
                        }
                    }
                    break
                }
            }
            if (isContained) {
                ship.hitSegments.append(segmentObj)
                break
            }
        }
        return hit_f;
    }
 
    func isWin() -> Bool {
        var playerOneWin = true
        var playerTwoWin = true
        
        for ship in playerOne!.ships as! Array<Ship> {
            if ship.segments.count != ship.hitSegments.count {
                playerTwoWin = false
                break
            }
        }
        
        for ship in playerTwo!.ships as! Array<Ship> {
            if ship.segments.count != ship.hitSegments.count {
                playerOneWin = false
                break
            }
        }
        
        if (playerTwoWin || playerTwoWin) {
            winner = playerOneWin ? 0 : 1
        }
        
        return playerOneWin || playerTwoWin
    }

    
    func calculateAIHitPoint(hit_f : Bool) -> CGPoint {
        if (up != nil) {
            
            self.resetLatch()
            up = []
            down = []
            left = []
            right = []
            used = []
        }
        if (!hit_f && self.isLatched() == false) {
            return self.regeneratePoint()
        }
        // latched but not hit, try the other directions
        else if (self.isLatched() && !hit_f) {
            var currentPoint = self.usePointWithReverseLatch()
            // check reverse dir if possible
            if (currentPoint.equalTo(dirty_point) == false) {
                return currentPoint
            }
            // if not check other dir
            currentPoint = self.usePointWithAvailableLatch()
            if (currentPoint.equalTo(dirty_point) == false) {
                return currentPoint
            }
            // if all used then regenerate
            if (self.latchState() == .allLatchUsed) {
                return self.regeneratePoint()
            }
        }
        // just hit
        else if (hit_f) {
            if (self.isLatched() == true) {
                return self.usePointWithSameLatch();
            }
            // NO latch use available latch at will
            else {
                return self.usePointWithAvailableLatch();
            }
        }
        // return to avoid warning
        return CGPoint.zero
    }
    
    func isLatched() -> Bool {
        var isLatched = false
        var i = 0
        while (i < 4) {
            if latch[i] == 1 {
                isLatched == true
                break
            }
            i += 1;
        }
        return isLatched
    }
    
    func resetLatch() {
        latch = []
        up?.removeAll()
        down?.removeAll()
        left?.removeAll()
        right?.removeAll()
    }
    
    func latchState() -> LatchState {
        var state : LatchState = .zeroLatch
        var slot = -1
        var i = 0
        while i < 4 {
            if (latch[i] == 1) {
                slot = i
                break
            } else if latch[i] == 0 {
                slot = 5
            } else if latch[i] == 2 {
                slot = 6
            }
            i += 1
        }
        
        switch slot {
            case 0:
                state = .upLatch
                break
            case 1:
                state = .downLatch
                break
            case 2:
                state = .leftLatch
                break
            case 3:
                state = .rightLatch
                break
            case 5:
                state = .zeroLatch
                break
            case 6:
                state = .allLatchUsed
                break;
            default:
                state = .allLatchUsed
                break;
        }
        
        return state
    }
    
    func latchStateWithState(state: LatchState) -> LatchState {
        if state == .upLatch {
            return latch[0] == 2 ? .latchSlotExpired : .latchSlotActive
        } else if state == .downLatch {
            return latch[1] == 2 ? .latchSlotExpired : .latchSlotActive
        } else if state == .leftLatch {
            return latch[2] == 2 ? .latchSlotExpired : .latchSlotActive
        } else if state == .rightLatch {
            return latch[3] == 2 ? .latchSlotExpired : .latchSlotActive
        }
        return .latchSlotExpired
    }
    
    func nextPointWithLatchState(state : LatchState) -> CGPoint {
        var currentPoint = dirty_point
        if self.latchStateWithState(state: state) == .latchSlotExpired {
            return currentPoint
        }
        if state == .upLatch {
            if up!.count > 0 {
                currentPoint = up!.last!.cgPointValue
                up?.removeLast()
            } else {
                self.setDirtyBitAtLatchWithState(state: state)
            }
        } else if state == .downLatch {
            if down!.count > 0 {
                currentPoint = down!.last!.cgPointValue
                down!.removeLast()
            } else {
                 self.setDirtyBitAtLatchWithState(state: state)
            }
        } else if state == .leftLatch {
            if left!.count > 0 {
                currentPoint = left!.last!.cgPointValue
                left!.removeLast()
            } else {
                self.setDirtyBitAtLatchWithState(state: state)
            }
        } else if state == .rightLatch {
            if right!.count > 0 {
                currentPoint = right!.last!.cgPointValue
                right!.removeLast()
            } else {
                self.setDirtyBitAtLatchWithState(state: state)
            }
        }
        
        used!.append(NSValue(cgPoint: currentPoint))
        return currentPoint
    }

    
    
    
    func setDirtyBitAtLatchWithState(state: LatchState) {
        if (state == .upLatch) {
            latch[0] = 2
        } else if (state == .downLatch) {
            latch[1] = 2
        } else if (state == .leftLatch) {
            latch[2] = 2
        } else if (state == .rightLatch) {
            latch[3] = 2
        }
    }
    
    func setActiveBitAtLatchWithState(state: LatchState) {
        if (state == .upLatch) {
            latch[0] = 1
        } else if (state == .downLatch) {
            latch[1] = 1
        } else if (state == .leftLatch) {
            latch[2] = 1
        } else if (state == .rightLatch) {
            latch[3] = 1
        }
    }
    
    func reverseStateWithState(state: LatchState) -> LatchState {
        if (state == .upLatch) {
            return .downLatch
        } else if (state == .downLatch) {
            return .upLatch
        } else if (state == .leftLatch) {
            return .rightLatch
        } else if (state == .rightLatch) {
            return .leftLatch
        }
        return .allLatchUsed
    }
    
    func usePointWithSameLatch() -> CGPoint {
        let state = latchState()
        return nextPointWithLatchState(state: state)
    }
    
    func usePointWithReverseLatch () -> CGPoint {
        let state = latchState()
        self.setDirtyBitAtLatchWithState(state: state)
        let reverseState = self.reverseStateWithState(state: state)
        if (latchStateWithState(state: reverseState) != .latchSlotExpired) {
            setActiveBitAtLatchWithState(state: reverseState)
        }
        return nextPointWithLatchState(state: reverseState)
    }
    
    func usePointWithAvailableLatch () -> CGPoint {
        var state : LatchState = .zeroLatch
        
        var currentPoint : CGPoint = dirty_point
        var i = 0
        while i < 4 {
            if latch[i] == 0 {
                if i == 0 {
                    state = .upLatch
                } else if i == 1 {
                    state = .downLatch
                } else if i == 2 {
                    state = .leftLatch
                } else if i == 3 {
                    state = .rightLatch
                }
                setActiveBitAtLatchWithState(state: state)
                currentPoint = nextPointWithLatchState(state: state)
                break
            }
            i += 1
        }
        used!.append(NSValue(cgPoint: currentPoint))
        return currentPoint
    }
    
    func visitedStateWithPoint(point: CGPoint) -> Bool {
        for value : NSValue in used! {
            if value.cgPointValue.equalTo(point) {
                return true
            }
        }
        return false
    }
    
    
    func regeneratePoint () -> CGPoint {
        var cellX = 0
        var cellY = 0
        
        var loop = true
        
        var currentPoint = CGPoint.zero
        
        while loop {
            cellX = Int(arc4random() % 8 + 1)
            cellY = Int(arc4random() % 8 + 1)
            
            currentPoint = CGPoint(x: cellX * Int(CELLSIZE), y: cellY * Int(CELLSIZE))
            loop = visitedStateWithPoint(point: currentPoint)
        }
        
        resetLatch()
        
        var i = 4
        
        while i >= 1 {
            //up
            if cellY - i >= 0 {
                let upPoint = CGPoint(x: cellX * Int(CELLSIZE), y: (cellY - i) * Int(CELLSIZE))
                if visitedStateWithPoint(point: upPoint) == false {
                    up!.append(NSValue(cgPoint: upPoint))
                }
            }
            // down
            if cellY + i < 10 {
                let downPoint = CGPoint(x: cellX * Int(CELLSIZE), y: (cellY + i) * Int(CELLSIZE))
                if visitedStateWithPoint(point: downPoint) == false {
                    down!.append(NSValue(cgPoint: downPoint))
                }
            }
            // left
            if cellX - i >= 0 {
                let leftPoint = CGPoint(x: (cellX - i) * Int(CELLSIZE), y: cellY * Int(CELLSIZE))
                if visitedStateWithPoint(point: leftPoint) == false {
                    left!.append(NSValue(cgPoint: leftPoint))
                }
            }
            // right
            if cellX + i < 10 {
                let rightPoint = CGPoint(x: (cellX + i) * Int(CELLSIZE), y: cellY * Int(CELLSIZE))
                if visitedStateWithPoint(point: rightPoint) == false {
                    right!.append(NSValue(cgPoint: rightPoint))
                }
            }
            i -= 1
        }
        used!.append(NSValue(cgPoint: currentPoint))
        return currentPoint
    }
    
   
    
}
