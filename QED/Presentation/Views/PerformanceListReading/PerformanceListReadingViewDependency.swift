// Created by byo.

import Foundation

final class PerformanceListReadingViewDependency: ViewDependency {
    let performances: [Performance]
    let toastContainerViewModel: ToastContainerViewModel

    init(performances: [Performance], toastContainerViewModel: ToastContainerViewModel = .shared) {
        self.performances = performances
        self.toastContainerViewModel = toastContainerViewModel
    }
}
