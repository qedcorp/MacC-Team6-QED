// Created by byo.

import SwiftUI

func animate<Result>(_ animation: Animation? = .default, _ body: () throws -> Result) rethrows -> Result {
    try withAnimation(animation, body)
}
