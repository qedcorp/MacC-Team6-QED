// Created by byo.

import UIKit

struct DotObjectViewModel {
    let radius: CGFloat?
    let color: UIColor?
    let borderColor: UIColor?
    let borderWidth: CGFloat?
    let alpha: CGFloat?

    init(
        radius: CGFloat? = nil,
        color: UIColor? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        alpha: CGFloat? = nil
    ) {
        self.radius = radius
        self.color = color
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.alpha = alpha
    }
}
