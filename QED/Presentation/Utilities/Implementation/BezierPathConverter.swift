// Created by byo.

import UIKit

class BezierPathConverter {
    weak var relativeCoordinateConverter: RelativeCoordinateConverter?

    func buildCAShapeLayer(_ bezierPath: BezierPath) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = buildUIBezierPath(bezierPath)
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.black.cgColor
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
