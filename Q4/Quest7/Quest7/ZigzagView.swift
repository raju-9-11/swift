//
//  ZigzagView.swift
//  Quest7
//
//  Created by Rajkumar S on 29/10/21.
//

import UIKit

class ZigzagView: UIView {
    
    var demoPath: UIBezierPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.backgroundColor = UIColor.clear
    }
       
    override func draw(_ rect: CGRect) {
        createTriangle()
        UIColor.purple.setFill()
        demoPath.fill()
        UIColor.orange.setStroke()
        demoPath.stroke()
    }
      
      
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
      
      
    func createTriangle(){
        demoPath = UIBezierPath()
        demoPath.move(to: CGPoint(x: self.frame.width/2, y: 0.0))
        demoPath.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        demoPath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        demoPath.close()
          
    }  

}
