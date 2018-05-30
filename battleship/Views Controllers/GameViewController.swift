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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setShips() {
        
    }


}
