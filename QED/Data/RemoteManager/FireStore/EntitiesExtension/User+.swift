//
//  User+.swift
//  QED
//
//  Created by changgyo seo on 10/22/23.
//

import Foundation

extension User: FireStoreEntityConvertable {
    var fireStoreID: String {
        get {
            self.id
        }
        set {
            self.id = newValue
        }
    }

    var fireStoreEntity: FireStoreEntity {
        FireStoreDTO.UserDTO(
            EMAIL: email,
            NAME: nickname
        )
    }
}
