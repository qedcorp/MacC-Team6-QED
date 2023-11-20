// Created by byo.

import Foundation

final class MyPageViewDependency: ViewDependency {
    let toastContainerViewModel: ToastContainerViewModel

    init(toastContainerViewModel: ToastContainerViewModel = .shared) {
        self.toastContainerViewModel = toastContainerViewModel
    }
}
