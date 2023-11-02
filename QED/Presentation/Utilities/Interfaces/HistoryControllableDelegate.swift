// Created by byo.

import Foundation

protocol HistoryControllableDelegate: AnyObject {
    func reflectHistoryFromHistoryControllable<T: Equatable>(_ history: T)
}
