// Created by byo.

import UIKit

class BezierPathConverter {
    weak var relativeCoordinateConverter: RelativeCoordinateConverter?

    func getRect(_ bezierPath: BezierPath) -> CGRect {
        guard let converter = relativeCoordinateConverter else {
            return .zero
        }
        let startPoint = converter.getAbsoluteValue(of: bezierPath.startPosition)
        let endPoint = converter.getAbsoluteValue(of: bezierPath.endPosition)
        let controlPoint = bezierPath.controlPoint.map { converter.getAbsoluteValue(of: $0) }
        let points: [CGPoint] = [startPoint, endPoint, controlPoint].compactMap { $0 }
        guard let minX = points.map({ $0.x }).min(),
              let minY = points.map({ $0.y }).min(),
              let maxX = points.map({ $0.x }).max(),
              let maxY = points.map({ $0.y }).max() else {
            return .zero
        }
        let padding: CGFloat = 22
        return CGRect(
            x: minX - padding,
            y: minY - padding,
            width: maxX - minX + padding,
            height: maxY - minY + padding
        )
    }

    func buildCAShapeLayer(_ bezierPath: BezierPath) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = buildUIBezierPath(bezierPath)
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.gray.cgColor
        layer.lineWidth = 1
        return layer
    }

    func buildUIBezierPath(_ bezierPath: BezierPath) -> UIBezierPath {
        let path = UIBezierPath()
        guard let startPoint = relativeCoordinateConverter?.getAbsoluteValue(of: bezierPath.startPosition),
              let endPoint = relativeCoordinateConverter?.getAbsoluteValue(of: bezierPath.endPosition) else {
            return path
        }
        path.move(to: startPoint)
        if let converter = relativeCoordinateConverter,
           let controlPoint = bezierPath.controlPoint.map({ converter.getAbsoluteValue(of: $0) }) {
            path.addCurve(to: endPoint, controlPoint1: startPoint, controlPoint2: controlPoint)
        } else {
            path.addLine(to: endPoint)
        }
        return path
    }
}
