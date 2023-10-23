//
//  FireStoreDTO+Performance.swift
//  QED
//
//  Created by changgyo seo on 10/21/23.
//

import Foundation

extension FireStoreDTO {
    final class Performance: NSObject, FireStoreEntity {

        let collectionName: String = "PERFORMANCE"
        @objc var ID: String
        @objc var OWNERID: String?
        @objc var DATA: String?

        init(ID: String = "", OWNERID: String? = nil, DATA: String? = nil) {
            self.ID = ""
            self.OWNERID = OWNERID
            self.DATA = DATA
        }

        convenience override init() {
            self.init(OWNERID: "", DATA: "")
        }

        func copys() -> Performance {
            Performance(ID: ID, OWNERID: OWNERID, DATA: DATA)
        }
    }
}
