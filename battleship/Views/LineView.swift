//
//  LineView.swift
//  battleship
//
//  Created by Arthur Hatchiguian on 26/05/2018.
//  Copyright © 2018 Arthur Hatchiguian. All rights reserved.
//

import UIKit

class LineView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext!.saveGState()
        
        let path = UIBezierPath()
        
        UIColor.orange.setStroke()
        
        let x = rect.origin.x
        let y = rect.origin.y
        
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: CGPoint(x: x + CELLSIZE, y: y + CELLSIZE))
        path.stroke()
        path.removeAllPoints()
        
        path.move(to: CGPoint(x: x + CELLSIZE, y: y))
        path.addLine(to: CGPoint(x: x, y: y + CELLSIZE))
        path.stroke()
        path.removeAllPoints()

        currentContext!.restoreGState()
    }
}
