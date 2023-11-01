//
//  FireStoreConvertable.swift
//  QED
//
//  Created by changgyo seo on 10/22/23.
//

import Foundation

protocol FireStoreEntityConvertable {
    var fireStoreID: String { get set }
    var fireStoreEntity: FireStoreEntity { get }
}
