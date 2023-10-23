//
//  User+.swift
//  QED
//
//  Created by changgyo seo on 10/22/23.
//

import Foundation

extension User: FireStoreEntityConvertable {
    var fireStoreEntity: FireStoreEntity {
        FireStoreDTO.UserDTO(
            EMAIL: email,
            NAME: nickname
        )
    }
}
