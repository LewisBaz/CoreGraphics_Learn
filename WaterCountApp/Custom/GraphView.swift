//
//  GraphView.swift
//  WaterCountApp
//
//  Created by Lewis on 13.01.2023.
//

import UIKit

@IBDesignable
final class GraphView: UIView {
    
    // MARK: - @IBInspectable
    
    @IBInspectable var startColor: UIColor = .red
    @IBInspectable var endColor: UIColor = .green
    
    // MARK: - Private Properties
    
    private enum Constants {
        static let cornerRadiusSize = CGSize(width: 8.0, height: 8.0)
        static let margin: CGFloat = 20.0
        static let topBorder: CGFloat = 60
        static let bottomBorder: CGFloat = 50
        static let colorAlpha: CGFloat = 0.3
        static let circleDiameter: CGFloat = 5.0
    }
    
    private var graphHeight: CGFloat {
        let height = bounds.height
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        return height - topBorder - bottomBorder
    }
    
    // MARK: - Data Properties
    
    var graphPoints = [4, 2, 6, 4, 5, 8, 3]
    
    var columnXPoint: ((Int) -> CGFloat)?
    var columnYPoint: ((Int) -> CGFloat)?
    
    // MARK: - UI Elements
    
    private let graphPath = UIBezierPath()
    private var gradient: CGGradient?
    
    @IBOutlet weak var averageWaterDrankLabel: UILabel!
    @IBOutlet weak var daysStackView: UIStackView!
    
    // MARK: - Lifecycle

    override func draw(_ rect: CGRect) {
        drawGradient()
        makeRectClipped(rect)
        drawGraphXPoints(rect)
        drawGraphYPoints(rect)
        drawGraphPoints()
        drawGraphGradient(rect)
        drawDataPoints()
        drawGraphLines(rect)
        setupSubviews()
    }
}

// MARK: - Private Methods

private extension GraphView {
    
    func drawGradient() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let colors = [startColor.cgColor, endColor.cgColor]
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorLocation: [CGFloat] = [0.0, 1.0]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocation) else { return }
        self.gradient = gradient
        
        let startPoint = CGPoint.zero
        let endPoint = CGPoint(x: 0, y: bounds.height)
        
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
    }
    
    func makeRectClipped(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: Constants.cornerRadiusSize)
        path.addClip()
    }
    
    func drawGraphXPoints(_ rect: CGRect) {
        let width = rect.width
        let margin = Constants.margin
        let graphWidth = width - margin * 2 - 4
        columnXPoint = { (column: Int) -> CGFloat in
            let spacing = graphWidth / CGFloat(self.graphPoints.count - 1)
            return CGFloat(column) * spacing + margin + 2
        }
    }
    
    func drawGraphYPoints(_ rect: CGRect) {
//        let height = rect.height
        let topBorder = Constants.topBorder
//        let bottomBorder = Constants.bottomBorder
//        let graphHeight = height - topBorder - bottomBorder
        guard let maxValue = graphPoints.max() else { return }
        columnYPoint = { (graphPoint: Int) -> CGFloat in
            let yPoint = CGFloat(graphPoint) / CGFloat(maxValue) * self.graphHeight
            return self.graphHeight + topBorder - yPoint
        }
    }
    
    func drawGraphPoints() {
        UIColor.white.setFill()
        UIColor.white.setStroke()
        
        guard let columnXPoint = columnXPoint,
              let columnYPoint = columnYPoint else { return }
        let firstXPoint = (columnXPoint)(0)
        let fisrtYPoint = columnYPoint(graphPoints[0])
        graphPath.move(to: CGPoint(x: firstXPoint, y: fisrtYPoint))
        
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: (columnXPoint)(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLine(to: nextPoint)
        }
        
        graphPath.stroke()
    }
    
    
    func drawGraphGradient(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(),
              let clippingPath = graphPath.copy() as? UIBezierPath,
              let columnXPoint = columnXPoint,
              let columnYPoint = columnYPoint else { return }
        let height = rect.height
        context.saveGState()
        clippingPath.addLine(to: CGPoint(x: columnXPoint(graphPoints.count - 1), y: height))
        clippingPath.addLine(to: CGPoint(x: columnXPoint(0), y: height))
        clippingPath.close()
        clippingPath.addClip()
        
        guard let maxValue = graphPoints.max() else { return }
        let highestYPoint = columnYPoint(maxValue)
        let margin = Constants.margin
        let graphStartPoint = CGPoint(x: margin, y: highestYPoint)
        let graphEndPoint = CGPoint(x: margin, y: bounds.height)
        
        guard let gradient = gradient else { return }
        context.drawLinearGradient(gradient, start: graphStartPoint, end: graphEndPoint, options: [])
        context.restoreGState()
        
        graphPath.lineWidth = 2.0
        graphPath.stroke()
    }
    
    func drawDataPoints() {
        guard let columnXPoint = columnXPoint,
              let columnYPoint = columnYPoint else { return }
        for i in 0..<graphPoints.count {
            var point = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            point.x -= Constants.circleDiameter / 2
            point.y -= Constants.circleDiameter / 2
            
            let circle = UIBezierPath(ovalIn: CGRect(origin: point, size: CGSize(width: Constants.circleDiameter, height: Constants.circleDiameter)))
            circle.fill()
        }
    }
    
    func drawGraphLines(_ rect: CGRect) {
        let linePath = UIBezierPath()
        let width = rect.width
        let height = rect.height
        let margin = Constants.margin
        let topBorder = Constants.topBorder
        let bottomBorder = Constants.bottomBorder
        
        linePath.move(to: CGPoint(x: margin, y: topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: topBorder))
        
        linePath.move(to: CGPoint(x: margin, y: graphHeight / 2 + topBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: graphHeight / 2 + topBorder))
        
        linePath.move(to: CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLine(to: CGPoint(x: width - margin, y: height - bottomBorder))
        
        let color = UIColor(white: 1.0, alpha: Constants.colorAlpha)
        color.setStroke()
            
        linePath.lineWidth = 1.0
        linePath.stroke()
    }
    
    func setupSubviews() {
        setupAverageLabel()
        setupStackViewLabels()
    }
    
    func setupAverageLabel() {
        let average = graphPoints.reduce(0, +) / graphPoints.count
        averageWaterDrankLabel.text! += " \(average)"
    }
    
    func setupStackViewLabels() {
        let maxDayIndex = daysStackView.arrangedSubviews.count - 1
        let today = Date()
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEE")
        
        for i in 0...maxDayIndex {
            if let date = calendar.date(byAdding: .day, value: -i, to: today),
               let label = daysStackView.arrangedSubviews[maxDayIndex - i] as? UILabel {
                label.text = formatter.string(from: date)
            }
        }
    }
}
