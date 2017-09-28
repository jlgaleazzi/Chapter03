//
//  CompassView.swift
//  Chapter03
//
//  Created by Juan Luis Galeazzi on 9/27/17.
//  Copyright © 2017 Texas Department of public Safety. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: self.midX, y: self.midY)
    }
}

class CompassView: UIView {
    override class var layerClass:AnyClass {
        return CompassLayer.self;
    }
}
    
class CompassLayer : CALayer, CALayerDelegate {
    var arrow: CALayer?
    var didSetup = false;
    
  // g.contentScale = UIScreen.main.scale
    
    
    override func layoutSublayers() {
        if !self.didSetup {
            self.didSetup = true
            self.setup()
        }
     
    }
    func setup() {
        
        // the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.main.scale
        g.frame = self.bounds
        g.colors = [
            UIColor.black.cgColor,
            UIColor.red.cgColor
        ]
        g.locations = [0.0,1.0]
        self.addSublayer(g)
        
        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red: 0.9, green: 0.95, blue: 0.93, alpha: 0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        circle.path = p
        self.addSublayer(circle)
        circle.bounds = self.bounds
        circle.position = self.bounds.center
        
        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in pts.characters.enumerated() {
            let t = CATextLayer()
            t.string = String(c)
            t.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPoint(x: 0.5, y: vert)
            t.alignmentMode = kCAAlignmentCenter
            t.foregroundColor = UIColor.black.cgColor
            t.setAffineTransform(
                CGAffineTransform(rotationAngle: CGFloat(ix) * .pi/2.0))
            circle.addSublayer(t)
        }
        
        // the arrow
        let arrow = CALayer()
        arrow.contentsScale = UIScreen.main.scale
        arrow.bounds = CGRect(x: 0, y: 0, width: 40, height: 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPoint(x: 0.5, y: 0.8)
        arrow.delegate = self // draw arrow in delegate methos
        arrow.setAffineTransform(CGAffineTransform(rotationAngle: .pi/5.0))
        self.addSublayer(arrow)
        arrow.setNeedsDisplay()
        

    }
    
    func draw(_ layer: CALayer, in ctx: CGContext) {
        print("drawLayer:inContext for arrow")
        
        // punch triangular hole in context clipping region
        ctx.move(to: CGPoint(x: 10, y: 100))
        ctx.addLine(to: CGPoint(x: 20, y: 90))
        ctx.addLine(to: CGPoint(x: 30, y: 100))
        ctx.closePath()
        ctx.addRect(ctx.boundingBoxOfClipPath)
        ctx.clip(using: .evenOdd)
        
        // draw the vertical line, add its shape to the clipping version
        ctx.move(to: CGPoint(x: 20, y: 100))
        ctx.addLine(to: CGPoint(x: 20, y: 19))
        ctx.setLineWidth(20)
        ctx.strokePath()
        
        // draw the triangle, the point of the arrow
        let r = UIGraphicsImageRenderer(size: CGSize(width: 4, height: 4))
        let stripes = r.image{
            con in
            let imcon = con.cgContext
            imcon.setFillColor(UIColor.red.cgColor)
            imcon.fill(CGRect(x: 0, y: 0, width: 4, height: 4))
            imcon.setFillColor(UIColor.blue.cgColor)
            imcon.fill(CGRect(x: 0, y: 0, width: 4, height: 2))
        }
        
         let stripesPattern = UIColor(patternImage: stripes)
        
        UIGraphicsPushContext(ctx)
        do {
            stripesPattern.setFill()
            let p = UIBezierPath()
            p.move(to: CGPoint(x: 0, y: 25))
            p.addLine(to: CGPoint(x: 20, y: 0))
            p.addLine(to: CGPoint(x: 40, y: 25))
            p.fill()
        }
        UIGraphicsPopContext()
        
    }
    
    
    
    
}
  


