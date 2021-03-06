//
//  GameView.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 26/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

class GameView: UIView {

    var delegate : GameDelegate?
    var tapGestureRecognizer : UITapGestureRecognizer?
    
    
    override func draw(_ rect: CGRect) {
        
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext!.saveGState()
        
        let path = UIBezierPath()
        
        UIColor.blue.setStroke()
        
        let cellWidth : Int = CELLSIZE
        let cellHeight : Int = CELLSIZE
        
        
        
        var i = 0
        
        // Draw vertical lines
        while (i <= 10) {
            let xPos : Int = i * cellWidth
            
            path.move(to: CGPoint(x: CGFloat(xPos), y: rect.origin.y))
            path.addLine(to: CGPoint(x: CGFloat(xPos), y: rect.size.height))
            path.stroke()
            path.removeAllPoints()
            i += 1
        }
        
        i = 0
        // Draw horizontal lines
        while (i <= 10) {
            let yPos : Int = i * cellHeight
            
            path.move(to: CGPoint(x: rect.origin.x, y:  CGFloat(yPos)))
            path.addLine(to: CGPoint(x: rect.size.width, y:  CGFloat(yPos)))
            path.stroke()
            path.removeAllPoints()
            i += 1
        }
        
        currentContext?.restoreGState()
    }
    
   @objc func doTap(gestureRecognizer: UITapGestureRecognizer) {
        let tapPoint = gestureRecognizer.location(in: self)
    
        if let delegateGameVC = delegate as? GameViewController {
            if delegateGameVC.game.gameState == .GameStatePlaying {
                _ = self.addTargetViewAtPoint(point: tapPoint)
            }
        }
    }
    
    func addTargetViewAtPoint(point: CGPoint) -> Bool {
        let delegateGameVC = delegate as! GameViewController
        
        let currentPlayer = delegateGameVC.currentPlayer
        let locationView = delegateGameVC.shipLocationView
        
        let hit_f = delegateGameVC.game.handleGridTapPoint(point: point, player: currentPlayer!.rawValue)

        let xIndex : Int = Int(point.x) / CELLSIZE
        let yIndex : Int = Int(point.y) / CELLSIZE
        
        // draw circle or X by ret
        
        if hit_f == false  {
            let targetView = UIView(frame: CGRect(x: xIndex * Int(CELLSIZE), y: yIndex * Int(CELLSIZE), width: Int(CELLSIZE), height: Int(CELLSIZE)))
                
                
            targetView.alpha = 0.6
            targetView.layer.cornerRadius = CGFloat(CELLSIZE) / 2.0
            targetView.backgroundColor = UIColor.gray
            if (currentPlayer == .PlayerOne) {
                targetView.tag = 10
            } else {
                targetView.tag = 11
            }
            self.addSubview(targetView)
            targetView.isUserInteractionEnabled = false
            
            
            
        } else {
            // Add hit mark at location view
            let targetView = UIView(frame: CGRect(x: xIndex * Int(CELLSIZE), y: yIndex * Int(CELLSIZE), width: Int(CELLSIZE), height: Int(CELLSIZE)))
            targetView.alpha = 0.4
            targetView.backgroundColor = UIColor.red
            if (currentPlayer == .PlayerOne) {
                targetView.tag = 11
            } else {
                targetView.tag = 10
            }
            locationView!.addSubview(targetView)
            targetView.isHidden = true
            // Add hit mark at hit view
            let lines = LineView(frame: CGRect(x: xIndex * Int(CELLSIZE), y: yIndex * Int(CELLSIZE), width: Int(CELLSIZE), height: Int(CELLSIZE)))
            if (currentPlayer == .PlayerOne) {
                lines.tag = 10
            } else {
                lines.tag = 11
            }
            lines.backgroundColor = self.backgroundColor
            self.addSubview(lines)
            lines.isUserInteractionEnabled = false
            
        }
        
        if !hit_f {
            delegateGameVC.lockupGridView()
            
                delegateGameVC.navigationItem.setRightBarButton(UIBarButtonItem(title: "Next move", style: .plain, target: self.delegate!, action: #selector(delegateGameVC.nextMove)), animated: true)
           
        } // If Someone wins?
        else {
            if delegateGameVC.game.isWin() {
                delegateGameVC.GameQuitWithReason(reason: .GameOver)
            }
        }
        
        return hit_f
    }
    
}
