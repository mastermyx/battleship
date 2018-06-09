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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setShips()
    }

    
    
    
    
    func setShips() {
        self.shipViewCarrier.shipType = .carrier
        self.shipViewCarrier.store()
        
        self.shipViewCruiser.shipType = .cruiser
        self.shipViewCruiser.store()
        
        self.shipViewSubmarine.shipType = .submarine
        self.shipViewSubmarine.store()
        
        self.shipViewPatrolBoat.shipType = .patrolBoat
        self.shipViewPatrolBoat.store()
    
        self.shipViewBattleship.shipType = .battleship
        self.shipViewBattleship.store()
    }


}
