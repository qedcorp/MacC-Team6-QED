//
//  FireStoreDTO+User.swift
//  QED
//
//  Created by changgyo seo on 10/21/23.
//

import Foundation

extension FireStoreDTO {
    class User: NSObject, FireStoreEntity {
        let collectionName: String = "USER"
        @objc var ID: String
        @objc var EMAIL: String?
        @objc var NAME: String?

        init(EMAIL: String? = nil, NAME: String? = nil) {
            self.ID = ""
            self.EMAIL = EMAIL
            self.NAME = NAME
        }

        convenience override init() {
            self.init(EMAIL: "", NAME: "")
        }
    }
}

extension FireStoreDTO.User {
    var entity: User {
        User(
            id: ID,
            email: EMAIL,
            nickname: NAME
        )
    }
}
