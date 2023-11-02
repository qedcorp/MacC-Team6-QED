//
//  Color+.swift
//  QED
//
//  Created by OLING on 11/1/23.
//

import SwiftUI
import UIKit

extension Color {

    init(hex: String) {
        let scanner = Scanner(string: hex)

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >>  8) & 0xFF) / 255.0
        let blue = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }

    init(uiColor: UIColor) {
        guard let components = uiColor.cgColor.components, components.count >= 3 else {
            self.init(.clear)
            return
        }

        let red = Double(components[0])
        let green = Double(components[1])
        let blue = Double(components[2])
        let alpha = Double(uiColor.cgColor.alpha)

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    convenience init(swiftUIColor: Color) {
        let uiColor = UIColor(swiftUIColor)
        self.init(cgColor: uiColor.cgColor)
    }
}

extension Color {
    static let monoWhite1 = Color(hex: "FFFFFF").opacity(0.25)
    static let monoWhite2 = Color(hex: "FFFFFF").opacity(0.40)
    static let monoWhite3 = Color(hex: "FFFFFF")
    static let monoLight = Color(hex: "ebebf5")
    static let monoNormal1 = Color(hex: "b0b0b8").opacity(0.20)
    static let monoNormal2 = Color(hex: "b0b0b8").opacity(0.60)
    static let monoNormal3 = Color(hex: "b0b0b8")
    static let monoDark = Color(hex: "8d8d93")
    static let monoDarker = Color(hex: "525256")
    static let monoBlack = Color(hex: "000000")
    static let blueLight1 = Color(hex: "72DFFB").opacity(0.1)
    static let blueLight2 = Color(hex: "72DFFB").opacity(0.25)
    static let blueLight3 = Color(hex: "72DFFB")
    static let blueNormal = Color(hex: "0BCDFF")
    static let blueDark = Color(hex: "0AB9E6")
    static let Dot1 = Color(hex: "8A66F6")
    static let Dot2 = Color(hex: "74FB9A")
    static let Dot3 = Color(hex: "FDFC54")
    static let Dot4 = Color(hex: "F666AB")
    static let Dot5 = Color(hex: "FF8000")
    static let Dot6 = Color(hex: "FF4601")
    static let Dot7 = Color(hex: "FF1594")
    static let Dot8 = Color(hex: "FFC700")
    static let Dot9 = Color(hex: "01F8FF")
    static let Dot10 = Color(hex: "00A5FF")
    static let Dot11 = Color(hex: "D9B8FA")
    static let Dot12 = Color(hex: "CDFAB8")
    static let Dot13 = Color(hex: "F8A98C")
    static let blueGradation1 = LinearGradient(colors: [Color.blueLight3.opacity(0.4), Color.blueNormal.opacity(0.4)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let blueGradation2 = LinearGradient(colors: [Color.blueLight3.opacity(0.6), Color.blueNormal.opacity(0.6)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let blueGradation3 = LinearGradient(colors: [Color.blueLight3, Color.blueNormal], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let strokeGlass1 = LinearGradient(colors: [Color.monoLight, Color.monoNormal3.opacity(0.6)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let strokeGlass2 = LinearGradient(colors: [Color.monoLight, Color.monoNormal3.opacity(0.3)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let strokeGlass3 = LinearGradient(colors: [Color.monoLight, Color.monoNormal3.opacity(0.2)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
}

 extension Gradient {
    static let blueGradation1 = LinearGradient(colors: [Color.blueLight3.opacity(0.4), Color.blueNormal.opacity(0.4)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let blueGradation2 = LinearGradient(colors: [Color.blueLight3.opacity(0.6), Color.blueNormal.opacity(0.6)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let blueGradation3 = LinearGradient(colors: [Color.blueLight3, Color.blueNormal], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let strokeGlass1 = LinearGradient(colors: [Color.monoLight, Color.monoNormal3.opacity(0.6)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let strokeGlass2 = LinearGradient(colors: [Color.monoLight, Color.monoNormal3.opacity(0.3)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
    static let strokeGlass3 = LinearGradient(colors: [Color.monoLight, Color.monoNormal3.opacity(0.2)], startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 1))
 }

extension UIColor {
    static let monoWhite1 = UIColor(hex: "FFFFFF").withAlphaComponent(0.25)
    static let monoWhite2 = UIColor(hex: "FFFFFF").withAlphaComponent(0.40)
    static let monoWhite3 = UIColor(hex: "FFFFFF")
    static let monoLight = UIColor(hex: "ebebf5")
    static let monoNormal1 = UIColor(hex: "b0b0b8").withAlphaComponent(0.20)
    static let monoNormal2 = UIColor(hex: "b0b0b8").withAlphaComponent(0.60)
    static let monoNormal3 = UIColor(hex: "b0b0b8")
    static let monoDark = UIColor(hex: "8d8d93")
    static let monoDarker = UIColor(hex: "525256")
    static let monoBlack = UIColor(hex: "000000")
    static let blueLight1 = UIColor(hex: "72DFFB").withAlphaComponent(0.1)
    static let blueLight2 = UIColor(hex: "72DFFB").withAlphaComponent(0.25)
    static let blueLight3 = UIColor(hex: "72DFFB")
    static let blueNormal = UIColor(hex: "0BCDFF")
    static let blueDark = UIColor(hex: "0AB9E6")
    static let Dot1 = UIColor(hex: "8A66F6")
    static let Dot2 = UIColor(hex: "74FB9A")
    static let Dot3 = UIColor(hex: "FDFC54")
    static let Dot4 = UIColor(hex: "F666AB")
    static let Dot5 = UIColor(hex: "FF8000")
    static let Dot6 = UIColor(hex: "FF4601")
    static let Dot7 = UIColor(hex: "FF1594")
    static let Dot8 = UIColor(hex: "FFC700")
    static let Dot9 = UIColor(hex: "01F8FF")
    static let Dot10 = UIColor(hex: "00A5FF")
    static let Dot11 = UIColor(hex: "D9B8FA")
    static let Dot12 = UIColor(hex: "CDFAB8")
    static let Dot13 = UIColor(hex: "F8A98C")
}

extension CAGradientLayer {

    static let blueGradation1: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint.init(x: layer.frame.width / 2, y: 0)
        layer.endPoint = CGPoint.init(x: layer.frame.width / 2, y: layer.frame.height)
        layer.colors = [UIColor.blueLight3.withAlphaComponent(0.4), UIColor.blueNormal.withAlphaComponent(0.4)]

        return layer
    }()
    static let blueGradation2: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint.init(x: layer.frame.width / 2, y: 0)
        layer.endPoint = CGPoint.init(x: layer.frame.width / 2, y: layer.frame.height)
        layer.colors = [UIColor.blueLight3.withAlphaComponent(0.6), UIColor.blueNormal.withAlphaComponent(0.6)]

        return layer
    }()
    static let blueGradation3: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint.init(x: layer.frame.width / 2, y: 0)
        layer.endPoint = CGPoint.init(x: layer.frame.width / 2, y: layer.frame.height)
        layer.colors = [UIColor.blueLight3, UIColor.blueNormal]

        return layer
    }()

    static let strokeGlass1: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint.init(x: layer.frame.width / 2, y: 0)
        layer.endPoint = CGPoint.init(x: layer.frame.width / 2, y: layer.frame.height)
        layer.colors = [UIColor.monoLight, UIColor.monoNormal3.withAlphaComponent(0.6)]

        return layer
    }()
    static let strokeGlass2: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint.init(x: layer.frame.width / 2, y: 0)
        layer.endPoint = CGPoint.init(x: layer.frame.width / 2, y: layer.frame.height)
        layer.colors = [UIColor.monoLight, UIColor.monoNormal3.withAlphaComponent(0.3)]

        return layer
    }()
    static let strokeGlass3: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint.init(x: layer.frame.width / 2, y: 0)
        layer.endPoint = CGPoint.init(x: layer.frame.width / 2, y: layer.frame.height)
        layer.colors = [UIColor.monoLight, UIColor.monoNormal3.withAlphaComponent(0.2)]

        return layer
    }()
}
