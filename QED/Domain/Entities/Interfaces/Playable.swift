// Created by byo.

import Foundation

protocol Playable {
    var title: String { get }
    var creator: String { get }
    var thumbnailURL: URL? { get }
}
