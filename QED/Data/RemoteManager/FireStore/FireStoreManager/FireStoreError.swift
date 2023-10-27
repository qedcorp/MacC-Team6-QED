//
//  FireStoreError.swift
//  QED
//
//  Created by changgyo seo on 10/27/23.
//

import Foundation

enum FireStoreError: Error {
    case didntFindDoucument
    case keyTypeError
    case cantReadCollection
    case disableFireStoreType
    case castingFailure(String)
    case fetchFailure
}
