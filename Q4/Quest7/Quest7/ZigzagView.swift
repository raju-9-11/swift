//
//  ZigzagView.swift
//  Quest7
//
//  Created by Rajkumar S on 29/10/21.
//

import UIKit

class ZigzagView: UIView {
    
    var myPath: UIBezierPath!
    var offset: CGFloat?
    let zigZagWidth = CGFloat(7)
    let zigZagHeight = CGFloat(5)

    override init(frame: CGRect) {
        super.init(frame: frame)
       
        self.backgroundColor = UIColor.clear
    }
    
    func setOffset(offset: CGFloat) {
        self.offset = offset
    }
       
    override func draw(_ rect: CGRect) {
        drawZigZag()
        UIColor.purple.setFill()
        UIColor.black.setStroke()
        myPath.stroke()
    }
      
      
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
      
      
    func drawZigZag(){
        
        
        myPath = UIBezierPath()
        myPath.lineWidth = 2
        var x = CGFloat(0)
        var i = 0
        var slope = -1.0
        myPath.move(to: CGPoint(x: 0.0 , y: self.frame.size.height / 2 ))
        
        while (x < self.frame.size.width) {
            x = zigZagWidth * CGFloat(i)
            myPath.addLine(to: CGPoint(x: x, y: self.frame.size.height/2.0 + (slope * zigZagHeight)))
            slope = slope*(-1.0)
            i+=1
        }
          
    }  

}
