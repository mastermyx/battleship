//
//  GameViewController.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 21/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

let CELLSIZE = 45




class GameViewController: UIViewController,UIGestureRecognizerDelegate,  GameDelegate {
    
   
    @IBOutlet weak var gameStateLabel: UILabel!
    
    @IBOutlet weak var shipViewCarrier: ShipView!
    @IBOutlet weak var shipViewCruiser: ShipView!
    @IBOutlet weak var shipViewSubmarine: ShipView!
    @IBOutlet weak var shipViewPatrolBoat: ShipView!
    @IBOutlet weak var shipViewBattleship: ShipView!
    
    @IBOutlet weak var shipViewCarrier2: ShipView!
    @IBOutlet weak var shipViewCruiser2: ShipView!
    @IBOutlet weak var shipViewSubmarine2: ShipView!
    @IBOutlet weak var shipViewPatrolBoat2: ShipView!
    @IBOutlet weak var shipViewBattleship2: ShipView!
    
     @IBOutlet weak var shipLocationView : GameView!
     @IBOutlet weak var shipHitView : GameView!
    
    var game = Game()
    var waitView : UIView?
    
    var currentPlayer : PlayerNumber?
    
    var lpStartPoint : CGPoint?
    var lpEndPoint : CGPoint?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        waitView = Bundle.main.loadNibNamed("WaitView", owner: self, options: nil)!.first as? UIView
        
       self.GamePreparation()
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setShips()
    }

    
    func setShips() {
        print("setShips")
        self.shipViewCarrier.shipType = .carrier
        self.shipViewCarrier.player = .PlayerOne
        self.shipViewCruiser.shipType = .cruiser
        self.shipViewCruiser.player = .PlayerOne
        self.shipViewSubmarine.shipType = .submarine
        self.shipViewSubmarine.player = .PlayerOne
        self.shipViewPatrolBoat.shipType = .patrolBoat
        self.shipViewPatrolBoat.player = .PlayerOne
        self.shipViewBattleship.shipType = .battleship
        self.shipViewBattleship.player = .PlayerOne
    
        self.shipViewCarrier2.shipType = .carrier
        self.shipViewCarrier2.player = .PlayerTwo
        self.shipViewCruiser2.shipType = .cruiser
        self.shipViewCruiser2.player = .PlayerTwo
        self.shipViewSubmarine2.shipType = .submarine
        self.shipViewSubmarine2.player = .PlayerTwo
        self.shipViewPatrolBoat2.shipType = .patrolBoat
        self.shipViewPatrolBoat2.player = .PlayerTwo
        self.shipViewBattleship2.shipType = .battleship
        self.shipViewBattleship2.player = .PlayerTwo
        
        self.shipViewBattleship.store()
        self.shipViewPatrolBoat.store()
        self.shipViewSubmarine.store()
        self.shipViewCruiser.store()
        self.shipViewCarrier.store()
        
        self.shipViewBattleship2.store()
        self.shipViewPatrolBoat2.store()
        self.shipViewSubmarine2.store()
        self.shipViewCruiser2.store()
        self.shipViewCarrier2.store()
    }

    
    func GamePreparation() {
        print("GamePreparation")
        game.gameState = .GameStatePreparation
        shipLocationView.delegate = self
        shipHitView.delegate = self

        shipHitView.tapGestureRecognizer = UITapGestureRecognizer(target: self.shipHitView, action: #selector(self.shipHitView.doTap(gestureRecognizer:)))
        shipHitView.addGestureRecognizer(shipHitView.tapGestureRecognizer!)
        self.game  = Game()
        self.game.playerOne = Player()
        self.game.playerTwo = Player()
        self.gameStateLabel.text = "Battlehip"
        
        let alert = UIAlertController(title: "Battleship", message: "Welcome to play Battleship. Please choose different play mode below.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Player VS Player", style: .default) { (action:UIAlertAction!) in
            print("Player VS Player click")
            self.game.gameMode = .HumanVSHuman
            
        })
        alert.addAction(UIAlertAction(title: "Player VS AI", style: .default) { (action:UIAlertAction!) in
            print("Player VS AI click")
            self.game.gameMode = .HumanVSComputer
            self.game.playerOne!.type = .PlayerHuman
            self.game.playerTwo!.type = .PlayerComputer
        })
        alert.addAction(UIAlertAction(title: "Online", style: .default) { (action:UIAlertAction!) in
            print("Online click")
        })
        self.present(alert, animated: true, completion: nil)
        
        self.currentPlayer = .PlayerOne
        self.ShipPlacement()
        

    }
    
    func ShipPlacement() {
        print("ShipPlacement")
        self.game.gameState = .GameStatePlacing
        self.restoreBoats(playerNumber: self.currentPlayer!)
        let player = self.currentPlayer! == .PlayerOne ? 1 : 2
        
        self.gameStateLabel.text = "Player: \(player) is placing ships, long press ship to rotate"
    }
    
    @objc func EndShipPlacement() {
        print("EndShipPlacement")
        let playerOne = self.game.playerOne
        let playerTwo = self.game.playerTwo
        
        let playerOneReady = playerOne!.ships.count == 5
        let playerTwoReady = playerTwo!.ships.count == 5
        
        if playerOneReady && playerTwoReady {
            let randomPlayer = arc4random() % 10 < 5 ? PlayerNumber.PlayerOne : PlayerNumber.PlayerTwo
            self.GamePlaying(player: randomPlayer.hashValue)
        } else if !playerOneReady {
            self.navigationItem.rightBarButtonItem = nil
            self.currentPlayer = PlayerNumber.PlayerOne
            self.EndShipPlacement()
        } else if !playerTwoReady {
            self.navigationItem.rightBarButtonItem = nil
             // Handle Different Play Mode
            if self.game.gameMode! == .HumanVSHuman {
                self.currentPlayer = PlayerNumber.PlayerTwo
                self.ShipPlacement()
            } else {
                let randomPlayer = arc4random() % 10 < 5 ? PlayerNumber.PlayerOne : PlayerNumber.PlayerTwo
                self.currentPlayer! = randomPlayer
                self.AIShipPlacement()
                self.GamePlayWithAI()
            }
        }
    }
    
    func GamePlaying(player: Int) {
        print("GamePlaying")
        self.game.gameState = .GameStatePlaying
        self.navigationItem.rightBarButtonItem = nil
        self.currentPlayer! = player == 0 ? PlayerNumber.PlayerOne : PlayerNumber.PlayerTwo
        self.gameStateLabel.text = "Player \(player + 1) is playing"
        // Re-draw with Player Data
        self.restoreBoats(playerNumber: self.currentPlayer!)
        self.restoreGridView(playerNumber: self.currentPlayer!)
    }
    
    func GameQuitWithReason(reason: GameReason) {
        print("GameQuitWithReason")
        let alert = UIAlertController(title: "Battleship", message: "Congratulation!!! Player \(self.game.winner! + 1) wins the game! Want to play again?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Player VS Player", style: .default) { (action:UIAlertAction!) in
            print("Play again")
            self.GameRestart()
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func GameRestart() {
         print("GameRestart")
        self.restoreEverything()
        self.GamePreparation()
    }
    
    func AIShipPlacement() {
        print("AIShipPlacement")
        self.view .addSubview(self.waitView!)
        self.doPlacement(shipView: self.shipViewBattleship2)
        self.doPlacement(shipView: self.shipViewCarrier2)
        self.doPlacement(shipView: self.shipViewPatrolBoat2)
        self.doPlacement(shipView: self.shipViewSubmarine2)
        self.doPlacement(shipView: self.shipViewCruiser2)
        
        Timer.scheduledTimer(timeInterval: 2.0, target: self.waitView!, selector: #selector(self.waitView!.removeFromSuperview), userInfo: nil, repeats: false)
    }
    
    func doPlacement(shipView: ShipView) {
        print("doPlacement")
        while (true) {
            let x = arc4random() % 480 + 30
            let y = arc4random() % 480 + 100
            
            let isRotated = arc4random() % 10 < 5 ? true : false
            shipView.isRotated = isRotated
            shipView.center = CGPoint(x: Int(x), y: Int(y))
            if self .moveShip(shipView: shipView, location: CGPoint(x: Int(x), y: Int(y))) {
                self.saveShipSegment(shipView: shipView, shipType: shipView.shipType!, playerNumber: PlayerNumber.PlayerTwo)
                break
            }
        }
    }
    
    func GamePlayWithAI() {
         print("GamePlayWithAI")
        self.game.gameState = .GameStatePlaying
        
        if self.currentPlayer! == PlayerNumber.PlayerTwo {
            self.view .addSubview(waitView!)
            
            // Calculate and perform click
            var retCode = false
            while (true) {
                let aiPoint = self.game.calculateAIHitPoint(hit_f: retCode)
                
                retCode = self.shipHitView!.addTargetViewAtPoint(point: aiPoint)
                if retCode == false {
                    break;
                }
            }
            // move into next
            self.nextMove()
            // remove Wait View
            Timer.scheduledTimer(timeInterval: 0.3, target: self.waitView!, selector: #selector(self.waitView!.removeFromSuperview), userInfo: nil, repeats: false)
        } else {
            //human turn
            self.GamePlaying(player: PlayerNumber.PlayerOne.rawValue)
            
        }
    }
    
    @IBAction func shipLongPressReactor(_ sender: UILongPressGestureRecognizer) {
        print("shipLongPressReactor")
        let shipView = sender.view as! ShipView
        
        if sender.state == .began {
            lpStartPoint = shipView.center
        }
        
        if sender.state == .began {
            UIView.animate(withDuration: 0.3, animations: {
                var transform = shipView.transform
                transform = shipView.isRotated ? CGAffineTransform.identity : transform.rotated(by: .pi / 2 )
                
                shipView.transform = transform
                shipView.isRotated = !shipView.isRotated
            })
        }
        // Bring ship view to the front
        if shipView.superview!.isEqual(self.view) {
            shipView.center = sender.location(in: self.view)
            self.view.bringSubview(toFront: shipView)
        } else {
            shipView.center = sender.location(in: self.shipLocationView)
            self.shipLocationView.bringSubview(toFront: shipView)
        }
        
        if sender.state == .changed {
            shipView.center = shipView.superview!.isEqual(self.view) ? sender.location(in: self.view) : sender.location(in: self.shipLocationView)
        }
        
        if sender.state == .ended {
            lpEndPoint = shipView.center
            // move ship to the final point
            if (!self.moveShip(shipView: shipView, location: lpEndPoint!)) {
                UIView.animate(withDuration: 0.3, animations: {
                    var transform = shipView.transform
                    transform = shipView.isRotated ? CGAffineTransform.identity : transform.rotated(by: .pi / 2 )
                    
                    shipView.transform = transform
                    shipView.isRotated = !shipView.isRotated
                    
                    shipView.center = self.lpStartPoint!
                })
            } else {
                //save position
                self.saveShipSegment(shipView: shipView, shipType: shipView.shipType!, playerNumber: self.currentPlayer!)
            }
            
            
        }
    }
    
    @IBAction func shipPanGestureReactor(_ sender: UIPanGestureRecognizer) {
        
        // Get dragging View
        
        let shipView = sender.view as! ShipView
        
        if sender.state == .began {
            lpStartPoint = shipView.center
            print("shipPanGestureReactor ")
        }
        
        // Bring ship in front of all other ships
        if shipView.superview!.isEqual(self.view) {
            self.view.bringSubview(toFront: shipView)
            //print("shipPanGestureReactor 1.a")
        } else {
            self.shipLocationView.bringSubview(toFront: shipView)
           // print("shipPanGestureReactor 1.b")
        }
        
        // Get the translation of the gesture
        
        let translation = sender.translation(in: shipView.superview)
        let effectiveTranslation = translation.applying(CGAffineTransform.identity)
        
        let newX : Int = Int(shipView.center.x + effectiveTranslation.x)
        let newY : Int = Int(shipView.center.y + effectiveTranslation.y)
        
        shipView.center = CGPoint(x: newX, y: newY)
        
        sender.setTranslation(CGPoint.zero, in: shipView)
        
        if sender.state == .ended {
            self.lpEndPoint = shipView.center
            print("shipPanGestureReactor 2 \(lpEndPoint.debugDescription)")
            if !self.moveShip(shipView: shipView, location: lpEndPoint!) {
                print("shipPanGestureReactor 2.a")
                UIView.animate(withDuration: 0.5, animations: {
                    shipView.center = self.lpStartPoint!
                })
            } else {
                print("shipPanGestureReactor 2.b")
                self .saveShipSegment(shipView: shipView, shipType: shipView.shipType!, playerNumber: self.currentPlayer!)
            }
        }
    }
    

    
    
    func moveShip(shipView: ShipView, location point: CGPoint) -> Bool {
        // Already containig such ship
        print("moveShip ")
        //let endPointOnBoard = self.shipLocationView.convert(point, to: shipView.superview)
        //let frameOnBoard = self.shipLocationView.convert(shipView.frame, to: shipView.superview)
        
        let endPointOnBoard = shipView.superview!.convert(point, to: self.shipLocationView)
        let frameOnBoard = shipView.superview!.convert(shipView.frame, to: self.shipLocationView)
        
        print("moveShip endpoint:\(endPointOnBoard.debugDescription)\n frameOnBoard:\(frameOnBoard.debugDescription)")
        
        
        
        if self.shipLocationView.bounds.contains(endPointOnBoard) {
            print("moveShip X")
            var isOverlap = false
            
            for subview in self.shipLocationView.subviews as! [ShipView] {
                
                if !subview.isEqual(shipView) && subview.player == shipView.player {
                    if frameOnBoard.intersects(subview.frame) {
                        isOverlap = true
                        print("moveShip 1")
                    }
                }
            }
            
            if isOverlap {
                return false
                print("moveShip 2")
            }
            // Check if ship place is out of bounds
            
            let shipOdd = shipView.bounds.size.width > shipView.bounds.size.height ? fmod(shipView.bounds.size.width / CGFloat(CELLSIZE), 2.0) == 1 : fmod(shipView.bounds.size.height / CGFloat(CELLSIZE), 2.0) == 1
            
            let shipRotated = shipView.frame.size.width < shipView.frame.size.height
            
            let nearestPoint = self.nearestPoint(endPoint: endPointOnBoard, isOdd: shipOdd, isRotated: shipRotated)
            let translation = CGPoint(x: (nearestPoint.x - endPointOnBoard.x) , y: (nearestPoint.y - endPointOnBoard.y))
            
            let checkFrame = CGRect(x: frameOnBoard.origin.x + translation.x, y: frameOnBoard.origin.y + translation.y, width: frameOnBoard.size.width, height: frameOnBoard.size.height)
            
            if !shipLocationView.bounds.contains(checkFrame) {
                print("moveShip 3")
                return false
            }
            
            if !self.shipLocationView.subviews.contains(shipView) {
                shipView.removeFromSuperview()
                self.shipLocationView.addSubview(shipView)
                shipView.frame = frameOnBoard
                print("moveShip 4")
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                shipView.center = nearestPoint
            })
            
            return true
        }
        print("moveShip 5")
        return false
    }
    
    // Method to Avoid Misplacing on the board
    func nearestPoint(endPoint: CGPoint, isOdd: Bool, isRotated: Bool) -> CGPoint {
        
        print("nearestPoint")
        var newPoint = CGPoint.zero
        
        let xIndex : Int = Int(endPoint.x) / Int(CELLSIZE)
        let yIndex : Int = Int(endPoint.y) / Int(CELLSIZE)

        let xIndexF = CGFloat(xIndex)
        let yIndexF = CGFloat(yIndex)
        
        let cellsize = CGFloat(CELLSIZE)
        
        if !isRotated {
            if isOdd {
                newPoint.x = xIndexF * cellsize + (cellsize / 2.0)
                newPoint.y = yIndexF * cellsize + (cellsize / 2.0)
            } else {
                if endPoint.x - (xIndexF * cellsize) < (cellsize / 2.0) {
                    newPoint.x = xIndexF * cellsize
                } else {
                    newPoint.x = (xIndexF + 1) * cellsize
                }
                newPoint.y = yIndexF * cellsize + (cellsize / 2.0)
            }
            
        } else {
            if isOdd {
                newPoint.x = xIndexF * cellsize + (cellsize / 2.0)
                newPoint.y = yIndexF * cellsize + (cellsize / 2.0)
            } else {
                newPoint.x = xIndexF * cellsize + (cellsize / 2.0)
                if (endPoint.y - (yIndexF * cellsize) < (cellsize / 2.0)) {
                    newPoint.y = yIndexF * cellsize
                } else {
                    newPoint.y = (xIndexF + 1) * cellsize
                }
            }
            
        }
        return newPoint
    }
    
    func saveShipSegment(shipView: ShipView, shipType:ShipType, playerNumber: PlayerNumber) {
        print("saveShipSegment")
        let player = playerNumber == .PlayerOne ? self.game.playerOne : self.game.playerTwo
        
        let ship = self.reuseShipWithType(shipType: shipType, player: playerNumber)
        ship.saveShipSegments(shipView: shipView)
        player!.ships.append(ship)
        // Time to "ready" and trigger next stage
        shipView.isUserInteractionEnabled = false
        if player!.ships.count == 5 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Ready", style: .plain, target: self, action: #selector(EndShipPlacement))
        }
    }
    
    func reuseShipWithType(shipType: ShipType, player playerNumber: PlayerNumber) -> Ship {
        print("reuseShipWithType")
        let player = playerNumber == .PlayerOne ? self.game.playerOne : self.game.playerTwo
        
        for ship in player!.ships as! [Ship] {
            if ship.type == shipType {
                return ship
            }
        }
        
        let ship = Ship(withType: shipType)
        return ship
    }
    
    
    func restoreBoats(playerNumber: PlayerNumber) {
        print("restoreBoats")
        if (playerNumber == PlayerNumber.PlayerOne) {
            self.shipViewPatrolBoat.isHidden = false
            self.shipViewCarrier.isHidden = false
            self.shipViewCruiser.isHidden = false
            self.shipViewSubmarine.isHidden = false
            self.shipViewBattleship.isHidden = false
            
            self.shipViewPatrolBoat2.isHidden = true
            self.shipViewCarrier2.isHidden = true
            self.shipViewCruiser2.isHidden = true
            self.shipViewSubmarine2.isHidden = true
            self.shipViewBattleship2.isHidden = true
        } else {
            self.shipViewPatrolBoat.isHidden = true
            self.shipViewCarrier.isHidden = true
            self.shipViewCruiser.isHidden = true
            self.shipViewSubmarine.isHidden = true
            self.shipViewBattleship.isHidden = true
            
            self.shipViewPatrolBoat2.isHidden = false
            self.shipViewCarrier2.isHidden = false
            self.shipViewCruiser2.isHidden = false
            self.shipViewSubmarine2.isHidden = false
            self.shipViewBattleship2.isHidden = false
        }
    }
    
    func restoreGridView(playerNumber: PlayerNumber) {
        print("restoreGridView")
        self.unlockGridView()
        
        for subview in self.shipHitView.subviews {
            if subview.tag == 10 {
                subview.isHidden = (playerNumber != PlayerNumber.PlayerOne) ? true : false
            } else if subview.tag == 11 {
                subview.isHidden = (playerNumber != PlayerNumber.PlayerTwo) ? true : false
            }
        }
        
        for subview in self.shipLocationView.subviews {
            if subview.tag == 10 {
                subview.isHidden = (playerNumber != PlayerNumber.PlayerOne) ? true : false
            } else if subview.tag == 11 {
                subview.isHidden = (playerNumber != PlayerNumber.PlayerTwo) ? true : false
            }
        }
    }
    
    func lockupGridView() {
        print("lockupGridView")
        self.shipHitView.isUserInteractionEnabled = false
        self.shipLocationView.isUserInteractionEnabled = false
    }
    
    func unlockGridView() {
        print("unlockGridView")
        self.shipHitView.isUserInteractionEnabled = true
        self.shipLocationView.isUserInteractionEnabled = true
    }
    
    @objc func nextMove() {
        print("nextMove")
        if self.game.gameMode == .HumanVSComputer {
            self.currentPlayer = self.currentPlayer == PlayerNumber.PlayerOne ? PlayerNumber.PlayerTwo : PlayerNumber.PlayerOne
            self .GamePlayWithAI()
        } else {
            if (currentPlayer == PlayerNumber.PlayerOne) {
                self.GamePlaying(player: PlayerNumber.PlayerTwo.rawValue)
            } else {
                self.GamePlaying(player: PlayerNumber.PlayerOne.rawValue)
            }
        }
    }
    
    func restoreEverything() {
        print("restoreEverything")
        // Remove all subviews
        for subview in self.shipLocationView.subviews {
            subview.removeFromSuperview()
        }
        for subview in self.shipHitView.subviews {
            subview.removeFromSuperview()
        }
        
        // Reset Ship View
        self.shipViewCarrier.restore()
        self.shipViewCruiser.restore()
        self.shipViewBattleship.restore()
        self.shipViewSubmarine.restore()
        self.shipViewPatrolBoat.restore()
        
        self.shipViewCarrier2.restore()
        self.shipViewCruiser2.restore()
        self.shipViewBattleship2.restore()
        self.shipViewSubmarine2.restore()
        self.shipViewPatrolBoat2.restore()
    }
}
