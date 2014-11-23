//
//  CircleView.swift
//  CueScreen
//
//  Created by Debjit Saha on 11/20/14.
//  Copyright (c) 2014 com.cuescreen.app. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        // Get the Graphics Context
        var context = UIGraphicsGetCurrentContext();
        
        // Set the circle outerline-width
        CGContextSetLineWidth(context, 15.0);
        
        // Set the circle outerline-colour
        //UIColor.greenColor().set()
        
        CGContextSetRGBStrokeColor(context, 0.776, 0.875, 0.592, 1)
        
        //CGContextSetFillColorWithColor(context, UIColor(0.5) )
        
        // Create Circle
        CGContextAddArc(context, (frame.size.width)/2, frame.size.height/2, (frame.size.width - 15)/2, 0.0, CGFloat(M_PI * 2.0), 1)
        
        // Draw
        CGContextStrokePath(context);
        
        
    }
    
}
