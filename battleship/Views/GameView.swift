//
//  GameView.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 26/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

class GameView: UIView {

    override func draw(_ rect: CGRect) {
        
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext!.saveGState()
        
        let path = UIBezierPath()
        
        UIColor.blue.setStroke()
        
        let cellWidth = CELLSIZE
        let cellHeight = CELLSIZE
        
        
        var i = 0
        
        // Draw vertical lines
        while (i <= 10) {
            let xPos = CGFloat(i) * cellWidth
            
            path.move(to: CGPoint(x: xPos, y: rect.origin.y))
            path.addLine(to: CGPoint(x: xPos, y: rect.size.height))
            path.stroke()
            path.removeAllPoints()
            i += 1
        }
    
        // Draw horizontal lines
        while (i <= 10) {
            let yPos = CGFloat(i) * cellHeight
            
            path.move(to: CGPoint(x: rect.origin.x, y: yPos))
            path.addLine(to: CGPoint(x: rect.size.width, y: yPos))
            path.stroke()
            path.removeAllPoints()
            i += 1
        }
        
        currentContext?.restoreGState()
    }
}
