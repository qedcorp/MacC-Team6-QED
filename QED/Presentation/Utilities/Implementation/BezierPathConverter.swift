// swiftlint:disable all
// Created by byo.

import UIKit

class BezierPathConverter {
    let pixelMargin: CGFloat
    weak var relativeCoordinateConverter: RelativeCoordinateConverter?
    
    init(pixelMargin: CGFloat) {
        self.pixelMargin = pixelMargin
    }
    
    private var converter: RelativeCoordinateConverter {
        relativeCoordinateConverter!
    }

    func getTouchableRect(_ bezierPath: BezierPath) -> CGRect {
        let sizeLength: CGFloat = 44
        let size = CGSize(width: sizeLength, height: sizeLength)
        let origin = getMidPoint(bezierPath: bezierPath, padding: sizeLength / 2)
        return CGRect(origin: origin, size: size)
    }
    
    func buildUIBezierPath(_ bezierPath: BezierPath) -> UIBezierPath {
        let path = UIBezierPath()
        let startPoint = converter.getAbsoluteValue(of: bezierPath.startPosition)
        let endPoint = converter.getAbsoluteValue(of: bezierPath.endPosition)
        path.move(to: startPoint)
        if let controlPoint = bezierPath.controlPoint.map({ converter.getAbsoluteValue(of: $0) }) {
            path.addCurve(to: endPoint, controlPoint1: startPoint, controlPoint2: controlPoint)
        } else {
            path.addLine(to: endPoint)
        }
        return path
    }

    func buildLayer(_ bezierPath: BezierPath, color: UIColor) -> BezierPathLayer {
        let layer = BezierPathLayer()
        let tMargin = getRelativeMargin(bezierPath: bezierPath)
        let arrowLayer = buildArrowLayer(bezierPath, tMargin: tMargin, color: color.cgColor)
        let arrowHeadLayer = buildArrowHeadLayer(bezierPath, tMargin: tMargin, color: color.cgColor)
        let circleLayer = buildCircleLayer(bezierPath, color: color.cgColor)
        layer.addSublayer(arrowLayer)
        layer.addSublayer(arrowHeadLayer)
        layer.addSublayer(circleLayer)
        return layer
    }
    
    private func buildArrowHeadLayer(_ bezierPath: BezierPath, tMargin: CGFloat, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        let path = buildArrowHeadPath(bezierPath, tMargin: tMargin)
        layer.path = path.cgPath
        layer.fillColor = color
        return layer
    }

    private func buildArrowLayer(_ bezierPath: BezierPath, tMargin: CGFloat, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = buildArrowPath(bezierPath, tMargin: tMargin).cgPath
        layer.strokeColor = color
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 1
        return layer
    }

    private func buildCircleLayer(_ bezierPath: BezierPath, color: CGColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.path = buildCirclePath(bezierPath).cgPath
        layer.fillColor = color
        return layer
    }

    private func buildArrowPath(_ bezierPath: BezierPath, tMargin: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let startPoint = getStartPoint(bezierPath: bezierPath, tMargin: tMargin)
        let endPoint = getEndPoint(bezierPath: bezierPath, tMargin: tMargin)
        path.move(to: startPoint)
        if let controlPoint = bezierPath.controlPoint.map({ converter.getAbsoluteValue(of: $0) }) {
            path.addCurve(to: endPoint, controlPoint1: controlPoint, controlPoint2: controlPoint)
        } else {
            path.addLine(to: endPoint)
        }
        return path
    }
    
    func buildArrowHeadPath(_ bezierPath: BezierPath, tMargin: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        let height: CGFloat = 8
        let endPoint = getEndPoint(bezierPath: bezierPath, tMargin: tMargin)
        let beforeEndPoint = getEndPoint(bezierPath: bezierPath, tMargin: tMargin + 0.01)
        path.move(to: endPoint)
        let angle = atan2(endPoint.y - beforeEndPoint.y, endPoint.x - beforeEndPoint.x)
        path.addLine(to: CGPoint(x: endPoint.x - height * cos(angle - .pi / 6), y: endPoint.y - height * sin(angle - .pi / 6)))
        path.addLine(to: CGPoint(x: endPoint.x - height * cos(angle + .pi / 6), y: endPoint.y - height * sin(angle + .pi / 6)))
        path.close()
        return path
    }

    private func buildCirclePath(_ bezierPath: BezierPath) -> UIBezierPath {
        let sizeLength: CGFloat = 4
        let size: CGSize = .init(width: sizeLength, height: sizeLength)
        let origin = getMidPoint(bezierPath: bezierPath, padding: sizeLength / 2)
        return UIBezierPath(ovalIn: .init(origin: origin, size: size))
    }
    
    private func getStartPoint(bezierPath: BezierPath, tMargin: CGFloat) -> CGPoint {
        getPointInPath(bezierPath: bezierPath, t: tMargin)
    }
    
    private func getEndPoint(bezierPath: BezierPath, tMargin: CGFloat) -> CGPoint {
        getPointInPath(bezierPath: bezierPath, t: 1 - tMargin)
    }
    
    private func getMidPoint(bezierPath: BezierPath, padding: CGFloat = 0) -> CGPoint {
        let tMargin = getRelativeMargin(bezierPath: bezierPath)
        var origin = getPointInPath(
            startPoint: getStartPoint(bezierPath: bezierPath, tMargin: tMargin),
            endPoint: getEndPoint(bezierPath: bezierPath, tMargin: tMargin),
            controlPoint: bezierPath.controlPoint.map { converter.getAbsoluteValue(of: $0) },
            t: 0.5
        )
        origin.x -= padding
        origin.y -= padding
        return origin
    }
    
    private func getPointInPath(bezierPath: BezierPath, t: CGFloat) -> CGPoint {
        let startPoint = converter.getAbsoluteValue(of: bezierPath.startPosition)
        let endPoint = converter.getAbsoluteValue(of: bezierPath.endPosition)
        let controlPoint = bezierPath.controlPoint.map { converter.getAbsoluteValue(of: $0) }
        return getPointInPath(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint, t: t)
    }

    private func getPointInPath(startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint?, t: CGFloat) -> CGPoint {
        let x: CGFloat
        let y: CGFloat
        if let controlPoint = controlPoint {
            x = (1 - t) * (1 - t) * (1 - t) * startPoint.x +
            3 * (1 - t) * (1 - t) * t * controlPoint.x +
            3 * (1 - t) * t * t * controlPoint.x +
            t * t * t * endPoint.x
            y = (1 - t) * (1 - t) * (1 - t) * startPoint.y +
            3 * (1 - t) * (1 - t) * t * controlPoint.y +
            3 * (1 - t) * t * t * controlPoint.y +
            t * t * t * endPoint.y
        } else {
            x = (1 - t) * startPoint.x + t * endPoint.x
            y = (1 - t) * startPoint.y + t * endPoint.y
        }
        return CGPoint(x: x, y: y)
    }
    
    private func getRelativeMargin(bezierPath: BezierPath) -> CGFloat {
        let lineLength = getLineLength(bezierPath: bezierPath)
        return pixelMargin / lineLength
    }
    
    private func getLineLength(bezierPath: BezierPath) -> CGFloat {
        let segments = 100
        var length: CGFloat = 0
        var previousPoint = converter.getAbsoluteValue(of: bezierPath.startPosition)
        for i in 1 ... segments {
            let t = CGFloat(i) / CGFloat(segments)
            let currentPoint = getPointInPath(bezierPath: bezierPath, t: t)
            length += currentPoint.getDistance(to: previousPoint)
            previousPoint = currentPoint
        }
        return length
    }
}
