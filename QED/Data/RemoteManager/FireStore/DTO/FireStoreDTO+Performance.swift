//
//  FireStoreDTO+Performance.swift
//  QED
//
//  Created by changgyo seo on 10/21/23.
//

import Foundation

extension FireStoreDTO {
    final class PerformanceDTO: NSObject, FireStoreEntity {
        let collectionName: String = "PERFORMANCE"
        @objc var ID: String
        @objc var OWNERID: String?
        @objc var DATA: String?

        init(ID: String, OWNERID: String? = nil, DATA: String? = nil) {
            self.ID = ID
            self.OWNERID = OWNERID
            self.DATA = DATA
        }

        convenience override init() {
            self.init(ID: "", OWNERID: "", DATA: "")
        }

        var entity: FireStoreEntityConvertable {
            Performance(jsonString: DATA ?? "")
        }

        func copys() -> PerformanceDTO {
            PerformanceDTO(ID: ID, OWNERID: OWNERID, DATA: DATA)
        }
    }
}
