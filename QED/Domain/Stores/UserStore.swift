// Created by byo.

import Foundation

protocol UserStore: AnyObject {
    var me: User? { get set }
}
