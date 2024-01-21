// Created by byo.

import Foundation

protocol UserStore: AnyObject {
    var myUser: User? { get set }
    func increaseLaunchingCount() -> Int
    func resetLaunchingCount()
}
