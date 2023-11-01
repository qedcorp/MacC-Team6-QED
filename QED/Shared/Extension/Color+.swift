//
//  Color+.swift
//  QED
//
//  Created by OLING on 11/1/23.
//

import SwiftUI

extension Color {

      init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")

        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >>  8) & 0xFF) / 255.0
        let blue = Double((rgb >>  0) & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
      }

    static let monoWhite1 = Color(hex: "#FFFFFF").opacity(0.25)
    static let monoWhite2 = Color(hex: "#FFFFFF").opacity(0.40)
    static let monoWhite3 = Color(hex: "#FFFFFF")
    static let monoLight = Color(hex: "#ebebf5")
    static let monoNormal1 = Color(hex: "#b0b0b8").opacity(0.20)
    static let monoNormal2 = Color(hex: "#b0b0b8").opacity(0.60)
    static let monoNormal3 = Color(hex: "#b0b0b8")
    static let monoDark = Color(hex: "#8d8d93")
    static let monoDarker = Color(hex: "#525256")
    static let monoBlack = Color(hex: "#000000")
    static let blueLight1 = Color(hex: "#72DFFB").opacity(0.1)
    static let blueLight2 = Color(hex: "#72DFFB").opacity(0.25)
    static let blueLight3 = Color(hex: "#72DFFB")
    static let blueNormal = Color(hex: "#0BCDFF")
    static let blueDark = Color(hex: "#0AB9E6")
    static let Dot1 = Color(hex: "#8A66F6")
    static let Dot2 = Color(hex: "#74FB9A")
    static let Dot3 = Color(hex: "#FDFC54")
    static let Dot4 = Color(hex: "#F666AB")
    static let Dot5 = Color(hex: "#FF8000")
    static let Dot6 = Color(hex: "#FF4601")
    static let Dot7 = Color(hex: "#FF1594")
    static let Dot8 = Color(hex: "#FFC700")
    static let Dot9 = Color(hex: "#01F8FF")
    static let Dot10 = Color(hex: "#00A5FF")
    static let Dot11 = Color(hex: "#D9B8FA")
    static let Dot12 = Color(hex: "#CDFAB8")
    static let Dot13 = Color(hex: "#F8A98C")
    static let blueGradation1 = LinearGradient(colors: [Color.blueLight3.opacity(0.4), Color.blueNormal.opacity(0.4)], startPoint: .top, endPoint: .bottom)
    static let blueGradation2 = LinearGradient(colors: [Color.blueLight3.opacity(0.6), Color.blueNormal.opacity(0.6)], startPoint: .top, endPoint: .bottom)
    static let blueGradation3 = LinearGradient(colors: [Color.blueLight3, Color.blueNormal], startPoint: .top, endPoint: .bottom)
}
