//
//  FireStoreDTO+Formation.swift
//  QED
//
//  Created by changgyo seo on 10/21/23.
//

import Foundation

extension FireStoreDTO {
    class PerFormance: NSObject, FireStoreEntity {
        let collectionName: String = "FORMATION"
        @objc var ID: String
        @objc var OWNERID: String?
        @objc var DATA: String?
        
        init(OWNERID: String? = nil, data: String? = nil) {
            self.ID = ""
            self.OWNERID = OWNERID
            self.DATA = DATA
        }
        
        convenience override init() {
            self.init(OWNERID: "", data: "")
        }
    }
}
