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
    
    private var angleDifference: CGFloat {
        return 2.0 * .pi - startAngle + endAngle
    }
    private var arcLengthPerGlass: CGFloat {
        return angleDifference / CGFloat(Constants.numberOfGlasses)
    }
    
    // MARK: - Lifecycle
    
    override func draw(_ rect: CGRect) {
        makeRadiusView()
        drawRadiusSections(rect)
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
    
    func drawRadiusSections(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        outlineColor.setFill()
        
        let markerWidth: CGFloat = 5.0
        let markerSize: CGFloat = 10.0
        
        let markerPath = UIBezierPath(rect: CGRect(x: -markerWidth / 2, y: 0, width: markerWidth, height: markerSize))
        context.translateBy(x: rect.width / 2, y: rect.height / 2)
        
        for i in 1...Constants.numberOfGlasses {
            context.saveGState()
            let angle = arcLengthPerGlass * CGFloat(i) + startAngle - .pi / 2
            context.rotate(by: angle)
            context.translateBy(x: 0, y: rect.height / 2 - markerSize)
            markerPath.fill()
            context.restoreGState()
        }
        
        context.restoreGState()
    }
}
