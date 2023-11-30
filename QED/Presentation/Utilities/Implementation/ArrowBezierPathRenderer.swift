// Created by byo.

import UIKit

class ArrowBezierPathRenderer {
    let bezierPathConverter: BezierPathConverter
    private var _relativeMargin: CGFloat = 0

    init(bezierPathConverter: BezierPathConverter) {
        self.bezierPathConverter = bezierPathConverter
    }

    private var converter: BezierPathConverter {
        bezierPathConverter
    }

    func buildArrowLayer(_ bezierPath: BezierPath, color: UIColor) -> BezierPathLayer {
        _relativeMargin = converter.getRelativeMargin(bezierPath)
        let layer = BezierPathLayer()
        let arrowLineLayer = buildArrowLineLayer(bezierPath, color: color.cgColor)
        let arrowHeadLayer = buildArrowHeadLayer(bezierPath, color: color.cgColor)
        let circleLayer = buildCircleLayer(bezierPath, color: color.cgColor)
        [arrowLineLayer, arrowHeadLayer, circleLayer].forEach {
            layer.addSublayer($0)
        }
        return layer
    }

    private func buildArrowLineLayer(_ bezierPath: BezierPath, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = buildArrowLinePath(bezierPath).cgPath
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1
        return layer
    }

    private func buildArrowHeadLayer(_ bezierPath: BezierPath, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = buildArrowHeadPath(bezierPath)
        layer.path = path.cgPath
        layer.fillColor = color
        return layer
    }

    private func buildCircleLayer(_ bezierPath: BezierPath, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = buildCirclePath(bezierPath).cgPath
        layer.fillColor = color
        return layer
    }

    func buildArrowLinePath(_ bezierPath: BezierPath, relativeMargin: CGFloat? = nil) -> UIBezierPath {
        let path = UIBezierPath()
        let margin = relativeMargin ?? _relativeMargin
        let startPoint = converter.getStartPoint(bezierPath, relativeMargin: margin)
        let endPoint = converter.getEndPoint(bezierPath, relativeMargin: margin)
        path.move(to: startPoint)
        if let controlPoint = bezierPath.controlPoint.map({ converter.getAbsoluteValue(of: $0) }) {
            let controlPoint1 = CGPoint.getMidPoint(startPoint, controlPoint)
            let controlPoint2 = CGPoint.getMidPoint(endPoint, controlPoint)
            path.addCurve(to: endPoint, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
        } else {
            path.addLine(to: endPoint)
        }
        return path
    }

    func buildArrowHeadPath(_ bezierPath: BezierPath, relativeMargin: CGFloat? = nil) -> UIBezierPath {
        let path = buildTrianglePath()
        let margin = relativeMargin ?? _relativeMargin
        let endPoint = converter.getEndPoint(bezierPath, relativeMargin: margin - 0.01)
        let beforeEndPoint = converter.getEndPoint(bezierPath, relativeMargin: margin)
        let angle = getAngleBetweenPoints(endPoint, beforeEndPoint)
        let transform = CGAffineTransform(translationX: endPoint.x, y: endPoint.y)
            .rotated(by: angle)
        path.apply(transform)
        return path
    }

    private func buildTrianglePath() -> UIBezierPath {
        let path = UIBezierPath()
        let height: CGFloat = 8
        path.move(to: .zero)
        path.addLine(to: .init(x: height, y: -height / 2))
        path.addLine(to: .init(x: height, y: height / 2))
        path.close()
        return path
    }

    private func buildCirclePath(_ bezierPath: BezierPath) -> UIBezierPath {
        let sizeLength: CGFloat = 4
        let size: CGSize = .init(width: sizeLength, height: sizeLength)
        let origin = converter.getMidPoint(bezierPath, padding: sizeLength / 2)
        return UIBezierPath(ovalIn: .init(origin: origin, size: size))
    }

    private func getAngleBetweenPoints(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let deltaX = point2.x - point1.x
        let deltaY = point2.y - point1.y
        let radians = atan2(deltaY, deltaX)
        return radians
    }
}
