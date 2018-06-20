//
//  GameViewController.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 21/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

let CELLSIZE: CGFloat = 45.0 



class GameViewController: UIViewController {
    
   
    
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
    
    var game : Game?
    let waitView : UIView?
    
    var currentPlayer : PlayerNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setShips()
    }

    
    func setShips() {
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
        //TODO
        game!.gameState = .GameStatePreparation
        shipLocationView.delegate = self
        shipHitView.delegate = self
    }
    
    func ShipPlacement() {
            //TODO
    }
    
    func EndShipPlacement() {
            //TODO
    }
    
    func GamePlaying(player: Int) {
            //TODO
    }
    
    func GameQuitWithReason(reason: GameReason) {
            //TODO
    }
    
    func GameRestart() {
            //TODO
    }
    
    func AIShipPlacement() {
            //TODO
    }
    
    func doPlacement(shipView: ShipView) {
            //TODO
    }
    
    func GamePlayWithAI() {
            //TODO
    }
    
    //shipLongPressReactor
    
    //shipPanGestureReactor
    
    
    func moveShip(shipView: ShipView, location: CGPoint) -> Bool {
        
            //TODO
        return true
    }
    
    // Method to Avoid Misplacing on the board
    func nearestPoint(endPoint: CGPoint, isOdd: Bool, isRotated: Bool) -> CGPoint {
            //TODO
    }
    
    func saveShipSegment(shipView: ShipView, player playerNumber: PlayerNumber) {
        //TODO
    }
    
    func reuseShipWithType(shipType: ShipType, player playerNumber: PlayerNumber) -> Ship {
            //TODO
    }
    
    // alertview
    
    func restoreBoats(playerNumber: PlayerNumber) {
            //TODO
    }
    
    func restoreGridView(playerNumber: PlayerNumber) {
            //TODO
    }
    
    func lockupGridView() {
            //TODO
    }
    
    func unlockGridView() {
            //TODO
    }
    
    func nextMove() {
            //TODO
    }
    
    func restoreEverything() {
            //TODO
    }
    
    
    
    
    
    
    
    
    
}
