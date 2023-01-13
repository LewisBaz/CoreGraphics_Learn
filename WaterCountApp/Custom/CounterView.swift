//
//  CounterView.swift
//  WaterCountApp
//
//  Created by Lewis on 13.01.2023.
//

import UIKit

@IBDesignable
final class CounterView: UIView {
    
    // MARK: - @IBInspectable
    
    @IBInspectable var counter: Int = 5 {
        didSet {
            if counter <= Constants.numberOfGlasses {
                setNeedsDisplay()
            }
        }
    }
    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor = UIColor.orange
    
    // MARK: - Private Properties
    
    private struct Constants {
        static let numberOfGlasses = 8
        static let lineWidth: CGFloat = 5.0
        static let arcWidth: CGFloat = 76
        
        static var halfOfLineWidth: CGFloat {
            return lineWidth / 2
        }
    }
    
    private let startAngle = 3.0 * .pi / 4.0
    private let endAngle = .pi / 4.0
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        makeRadiusView()
        setNeedsDisplay()
    }
}

// MARK: - Private Methods

private extension CounterView {
    
    func makeRadiusView() {
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = max(bounds.width, bounds.height)
        
        let path = UIBezierPath(arcCenter: center, radius: radius / 2 - Constants.arcWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = Constants.arcWidth
        counterColor.setStroke()
        path.stroke()
        makeRadiusOutline(startPoint: center)
    }
    
    func makeRadiusOutline(startPoint: CGPoint) {
        let angleDifference = 2.0 * .pi - startAngle + endAngle
        let arcLengthPerGlass = angleDifference / CGFloat(Constants.numberOfGlasses)
        let outlineEndAngle = arcLengthPerGlass * CGFloat(counter) + startAngle
        let outerArcRadius = bounds.width / 2 - Constants.halfOfLineWidth

        let outlinePath = UIBezierPath(arcCenter: startPoint, radius: outerArcRadius, startAngle: startAngle, endAngle: outlineEndAngle, clockwise: true)

        let innerArcRadius = bounds.width / 2 - Constants.arcWidth + Constants.halfOfLineWidth

        outlinePath.addArc(withCenter: startPoint, radius: innerArcRadius, startAngle: outlineEndAngle, endAngle: startAngle, clockwise: false)
        outlinePath.close()

        outlineColor.setStroke()
        outlinePath.lineWidth = Constants.lineWidth
        outlinePath.stroke()
    }
}
