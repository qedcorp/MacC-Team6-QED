//  swiftlint:disable all
//  PathToPointCalculator.swift
//  QED
//
//  Created by changgyo seo on 11/3/23.
//

import UIKit

struct PathToPointCalculator {

    func getMiddlePoint(_ path: CGPath, startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) -> CGPoint {
        let straightMiddlePoint = middlePointOf(a: startPoint, b: endPoint)

        var answer: CGPoint = .zero
        let linearFunctionValue = makeLinearFunction(startPoint: startPoint, endPoint: straightMiddlePoint)
        var beforePoint: CGPoint = .zero
        for x in Int(controlPoint.x)...Int(straightMiddlePoint.x) {
            let y = (Int(linearFunctionValue.sloth)) * Int(x) + Int(linearFunctionValue.height)
            let currentPoint = CGPoint(x: x, y: y)
            if path.contains(currentPoint) {
                answer = beforePoint
                break
            }
            beforePoint = currentPoint
        }
        return answer
    }

    func getAThreePoint(path: CGPath) -> (startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) {
        var answer: (startPoint: CGPoint, endPoint: CGPoint, controlPoint: CGPoint) = (.zero, .zero, .zero)
        path.applyWithBlock { element in
               switch element.pointee.type {
               case .moveToPoint:
                   let point = element.pointee.points[0]
                   answer.startPoint = point
               case .addCurveToPoint:
                   let controlPoint2 = element.pointee.points[1]
                   let endPoint = element.pointee.points[2]
                   answer.controlPoint = controlPoint2
                   answer.endPoint = endPoint
               default:
                   break
               }
           }
        return answer
    }

    func makeLinearFunction(startPoint: CGPoint, endPoint: CGPoint) -> (sloth: CGFloat, height: CGFloat) {
        let sloth = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x)
        let height =  startPoint.y - (sloth * startPoint.x)

        return (sloth, height)
    }

    func middlePointOf(a: CGPoint, b: CGPoint) -> CGPoint {
        let middlePointX = max(a.x, b.x) - min(a.x, b.x)
        let middlePointY = max(a.y, b.y) - min(a.y, b.y)

        return CGPoint(x: middlePointX, y: middlePointY)
    }
}
