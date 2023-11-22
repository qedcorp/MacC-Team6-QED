// Created by byo.

import Foundation

final class AccountInfoViewDependency: ViewDependency {
    let myPageViewModel: MyPageViewModel

    init(myPageViewModel: MyPageViewModel) {
        self.myPageViewModel = myPageViewModel
    }
}
