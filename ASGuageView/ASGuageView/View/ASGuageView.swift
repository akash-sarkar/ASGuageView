//
//  ASGuageView.swift
//  ASGuageView
//
//  Created by Akash Sarkar
//

import Foundation
import UIKit

final class ASGuageView: UIView {
    
    // For Drawing Arc
    public var arcWidth: CGFloat = 8 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var degreePerScore: CGFloat = .pi / 600 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var score: Int = 300 {
        didSet {
            setNeedsDisplay()
            toValue = CGFloat(score) * degreePerScore + shiftInAngleForArc
        }
    }
    
    public var drawGraph: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var drawKnob: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var shiftInAngleForArc: CGFloat = .pi/2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var colorArray: [ColorArrayModel]? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var gapInGraphScore: CGFloat?{
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var extraSizeOfKnobOuterCircle: CGFloat = 5 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var interiorCircleColor: CGColor = UIColor.white.cgColor {
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var exteriorCircleColor: CGColor = UIColor.red.cgColor {
        didSet{
            setNeedsDisplay()
        }
    }
    
    //For Animation
    public var fromValue: CGFloat = .pi
    
    public var toValue: CGFloat = 2 * .pi
    
    public var animate: Bool = false {
        didSet {
            animateGauge()
        }
    }
    
    public var duration: CFTimeInterval = 1
    
    
    //Display
    private var circleLayer: CAShapeLayer?
    private var displayLink: CADisplayLink?
    
    override func draw(_ rect: CGRect) {
        if drawGraph {
            drawArcGraph()
        }
        if drawKnob {
            drawDoubleKnob()
        }
    }
    
    func animateGauge() {
        DispatchQueue.main.async {
            if let animatingNeedle = self.circleLayer {
                self.animate(triangleLayer: animatingNeedle, duration: self.duration, callBack: {})
            }
        }
    }
    
    private func drawArcGraph(){
        if let array = colorArray {
            var firstIteration = true
            for ranges in array {
                if let withGaps = gapInGraphScore {
                    CreateArcs(color: ranges.color, startAngle: (ranges.startScore + (firstIteration ? 0 : withGaps)) * degreePerScore + shiftInAngleForArc , endAngle: ranges.endScore * degreePerScore + shiftInAngleForArc)
                    firstIteration = false
                    
                } else {
                    CreateArcs(color: ranges.color, startAngle: ranges.startScore * degreePerScore + shiftInAngleForArc , endAngle: ranges.endScore * degreePerScore + shiftInAngleForArc)
                }
            }
        }
    }
    
    private func CreateArcs(color: UIColor, startAngle: CGFloat, endAngle: CGFloat) {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height)
        
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = arcWidth
        path.lineCapStyle = .round
        color.setStroke()
        path.stroke()
    }
    
    private func drawDoubleKnob() {
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: arcWidth/2, y: bounds.height / 2), radius: arcWidth/2, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        
        let outerCircle = CAShapeLayer()
        let outerCirclePath = UIBezierPath(arcCenter: CGPoint(x: arcWidth/2, y: bounds.height / 2), radius: arcWidth/2 + extraSizeOfKnobOuterCircle, startAngle: 0.0, endAngle: CGFloat(2 * Double.pi), clockwise: false)
        
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = interiorCircleColor
        
        outerCircle.path = outerCirclePath.cgPath
        outerCircle.fillColor = exteriorCircleColor
        
        outerCircle.addSublayer(circleLayer)
        
        self.circleLayer = outerCircle
        layer.addSublayer(outerCircle)
    }
    
    func animate(triangleLayer: CAShapeLayer, duration: CFTimeInterval, callBack:@escaping () -> Void) {
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = animatingPath().cgPath
        animation.duration = duration
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.isRemovedOnCompletion = false
        
        triangleLayer.add(animation, forKey: "circleAnimation")
        
        let displayLink = CADisplayLink(target: self, selector: #selector(updateColor))
        displayLink.add(to: .current, forMode: .default)
    }
    
    @objc func updateColor() {
        let presentationLayer = circleLayer?.presentation()
        let currentAngle = angleFromPosition(presentationLayer?.position ?? .zero)
        
        
        if let colorArray = colorArray {
            for array in colorArray {
                
                let startRadians = array.startScore * degreePerScore
                let endRadians = array.endScore * degreePerScore
                
                if  currentAngle >= (startRadians + shiftInAngleForArc) && currentAngle.magnitude < (endRadians + shiftInAngleForArc) {
                    circleLayer?.fillColor = array.color.cgColor
                }
            }
        }
    }
    
    private func angleFromPosition(_ position: CGPoint) -> CGFloat {
        let center = CGPoint(x: bounds.width / 2 - arcWidth/2, y: 0)
        let deltaX = position.x - center.x
        let deltaY = position.y - center.y
        let angle = atan2(deltaY, deltaX)
        return (-angle - (2 * .pi)).magnitude
    }
    
    private func animatingPath() -> UIBezierPath {
        let center = CGPoint(x: bounds.width / 2 - arcWidth/2, y: 0)
        
        let radius = max(bounds.width, bounds.height)
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: fromValue, endAngle: toValue, clockwise: true)
        return path
    }
}


