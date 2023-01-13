//
//  PushButton.swift
//  WaterCountApp
//
//  Created by Lewis on 12.01.2023.
//

import UIKit

@IBDesignable
final class PushButton: UIButton {
    
    // MARK: - @IBInspectable
    
    @IBInspectable var fillColor: UIColor = UIColor(red: 17.0/255, green: 112.0/255, blue: 124.0/255, alpha: 1.0)
    @IBInspectable var isAddButton: Bool = true
    
    // MARK: - Private Properties
    
    private struct Constants {
        static let plusLineWidth: CGFloat = 3.0
        static let plusButtonScale: CGFloat = 0.6
        static let halfPointShift: CGFloat = 0.5
    }
      
    private var halfWidth: CGFloat {
        return bounds.width / 2
    }
      
    private var halfHeight: CGFloat {
        return bounds.height / 2
    }
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted ? shapeToHighlighted() : shapeToNotHighlighted()
        }
    }
    
    // MARK: - UI Elements
    
    private let plusPath = UIBezierPath()
    private let shapeLayer = CAShapeLayer()
    
    // MARK: - Lifecycle

    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
        createPlus()
        setNeedsDisplay()
    }
}

// MARK: - Private Methods

private extension PushButton {
    
    func createPlus() {
        plusPath.lineWidth = Constants.plusLineWidth
        
        let plusWidth = bounds.width * Constants.plusButtonScale
        let halfPlusWidth = plusWidth / 2
        
        plusPath.move(to: CGPoint(x: halfWidth - halfPlusWidth + Constants.halfPointShift, y: halfHeight + Constants.halfPointShift))
        plusPath.addLine(to: CGPoint(x: halfWidth + halfPlusWidth + Constants.halfPointShift, y: halfHeight + Constants.halfPointShift))
        
        if isAddButton {
            plusPath.move(to: CGPoint(x: halfWidth + Constants.halfPointShift, y: halfHeight - halfPlusWidth + Constants.halfPointShift))
            plusPath.addLine(to: CGPoint(x: halfWidth + Constants.halfPointShift, y: halfHeight + halfPlusWidth + Constants.halfPointShift))
        }
        
        UIColor.white.setStroke()
        plusPath.stroke()
        makePlusShapeLayer()
    }
    
    func makePlusShapeLayer() {
        shapeLayer.path = plusPath.cgPath
        shapeLayer.lineWidth = 3
        layer.addSublayer(shapeLayer)
    }
    
    func shapeToHighlighted() {
        shapeLayer.strokeColor = fillColor.cgColor
        shapeLayer.fillColor = fillColor.cgColor
    }
    
    func shapeToNotHighlighted() {
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
    }
}
