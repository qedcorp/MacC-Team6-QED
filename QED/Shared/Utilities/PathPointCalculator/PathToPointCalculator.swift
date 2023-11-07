//  swiftlint:disable all
//  PathToPointCalculator.swift
//  QED
//
//  Created by changgyo seo on 11/3/23.
//

import UIKit

struct PathToPointCalculator {
    
    typealias ThreePoint = (startPoint: CGPoint, endPoint: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint)
    let totalPercent: CGFloat
    
    func getAllPoints(_ path: CGPath) -> [CGPoint] {
        let threePoint = getThreePoint(path: path)
        let startPoint = threePoint.startPoint
        let controllPoint1 = threePoint.controlPoint1
        let controllPoint2 = threePoint.controlPoint2
        let endPoint = threePoint.endPoint
        
        var answer: [CGPoint] = []
        
        if controllPoint1 == CGPoint(x: -1, y: -1) {
            for percent in stride(from: 0.0, through: totalPercent, by: 1.0) {
                
                let pathPoint = getPercentPoint(start: startPoint, end: endPoint, percent: percent)
                answer.append(pathPoint)
            }
        }
        else {
            for percent in stride(from: 0.0, through: totalPercent, by: 1.0) {
                let firstPoint = getPercentPoint(start: startPoint, end: controllPoint1, percent: percent)
                let sencondPoint = getPercentPoint(start: controllPoint1, end: controllPoint2, percent: percent)
                let thirdPoint = getPercentPoint(start: controllPoint2, end: endPoint, percent: percent)
                let fouthPoint = getPercentPoint(start: firstPoint, end: sencondPoint, percent: percent)
                let fifthPoint = getPercentPoint(start: sencondPoint, end: thirdPoint, percent: percent)
                
                let pathPoint = getPercentPoint(start: fouthPoint, end: fifthPoint, percent: percent)
                
                answer.append(pathPoint)
            }
        }
        return answer
    }
    
    private func getThreePoint(path: CGPath) -> ThreePoint {
        var answer: ThreePoint = (.zero, .zero, CGPoint(x: -1, y: -1), .zero)
        path.applyWithBlock { element in
            switch element.pointee.type {
            case .addLineToPoint:
                let point = element.pointee.points[0]
                answer.endPoint = point
            case .moveToPoint:
                let point = element.pointee.points[0]
                answer.startPoint = point
            case .addCurveToPoint:
                let controlPoint1 = element.pointee.points[0]
                let controlPoint2 = element.pointee.points[1]
                let endPoint = element.pointee.points[2]
                answer.controlPoint1 = controlPoint1
                answer.controlPoint2 = controlPoint2
                answer.endPoint = endPoint
            default:
                break
            }
        }
        return answer
    }
    
    private func getPercentPoint(start: CGPoint, end: CGPoint, percent: CGFloat) -> CGPoint {
        let pointX = start.x + ((end.x - start.x) * (percent / totalPercent))
        let pointy = start.y + ((end.y - start.y) * (percent / totalPercent))
        return CGPoint(x: pointX, y: pointy)
    }
}
