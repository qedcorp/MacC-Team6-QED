// swiftlint:disable all
// Created by byo.

import Foundation

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
        let origin = getMidPoint(bezierPath, padding: sizeLength / 2)
        return CGRect(origin: origin, size: size)
    }

    func getStartPoint(_ bezierPath: BezierPath, relativeMargin: CGFloat) -> CGPoint {
        getPointInPath(bezierPath, relativeMargin: relativeMargin)
    }

    func getEndPoint(_ bezierPath: BezierPath, relativeMargin: CGFloat) -> CGPoint {
        getPointInPath(bezierPath, relativeMargin: 1 - relativeMargin)
    }

    func getMidPoint(_ bezierPath: BezierPath, padding: CGFloat = 0) -> CGPoint {
        let relativeMargin = getRelativeMargin(bezierPath)
        var origin = getPointInPath(
            startPoint: getStartPoint(bezierPath, relativeMargin: relativeMargin),
            endPoint: getEndPoint(bezierPath, relativeMargin: relativeMargin),
            controlPoint: bezierPath.controlPoint.map { converter.getAbsoluteValue(of: $0) },
            t: 0.5
        )
        origin.x -= padding
        origin.y -= padding
        return origin
    }

    func getAbsoluteValue<T: RelativeCoordinatable>(of relativeValue: T) -> CGPoint {
        converter.getAbsoluteValue(of: relativeValue)
    }

    func getRelativeMargin(_ bezierPath: BezierPath) -> CGFloat {
        let lineLength = getLineLength(bezierPath)
        return pixelMargin / lineLength
    }

    private func getLineLength(_ bezierPath: BezierPath) -> CGFloat {
        let segments = 100
        var length: CGFloat = 0
        var previousPoint = converter.getAbsoluteValue(of: bezierPath.startPosition)
        for i in 1 ... segments {
            let t = CGFloat(i) / CGFloat(segments)
            let currentPoint = getPointInPath(bezierPath, relativeMargin: t)
            length += currentPoint.getDistance(to: previousPoint)
            previousPoint = currentPoint
        }
        return length
    }

    private func getPointInPath(_ bezierPath: BezierPath, relativeMargin: CGFloat) -> CGPoint {
        let startPoint = converter.getAbsoluteValue(of: bezierPath.startPosition)
        let endPoint = converter.getAbsoluteValue(of: bezierPath.endPosition)
        let controlPoint = bezierPath.controlPoint.map { converter.getAbsoluteValue(of: $0) }
        return getPointInPath(startPoint: startPoint, endPoint: endPoint, controlPoint: controlPoint, t: relativeMargin)
    }

    private func getPointInPath(startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint?, t: CGFloat) -> CGPoint {
        let x: CGFloat
        let y: CGFloat
        if let controlPoint = controlPoint {
            let controlPoint1 = CGPoint.getMidPoint(startPoint, controlPoint)
            let controlPoint2 = CGPoint.getMidPoint(endPoint, controlPoint)
            x = (1 - t) * (1 - t) * (1 - t) * startPoint.x +
            3 * (1 - t) * (1 - t) * t * controlPoint1.x +
            3 * (1 - t) * t * t * controlPoint2.x +
            t * t * t * endPoint.x
            y = (1 - t) * (1 - t) * (1 - t) * startPoint.y +
            3 * (1 - t) * (1 - t) * t * controlPoint1.y +
            3 * (1 - t) * t * t * controlPoint2.y +
            t * t * t * endPoint.y
        } else {
            x = (1 - t) * startPoint.x + t * endPoint.x
            y = (1 - t) * startPoint.y + t * endPoint.y
        }
        return CGPoint(x: x, y: y)
    }
}
