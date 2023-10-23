//
//  FireStoreDTO+Preset.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import Foundation

extension FireStoreDTO {
    final class Preset: NSObject, FireStoreEntity {
        let collectionName: String = "PRESET"
        @objc var ID: String
        @objc var HEADCOUNT: String?
        @objc var DATA: String?

        init(ID: String = "", HEADCOUNT: String? = nil, DATA: String? = nil) {
            self.ID = ""
            self.HEADCOUNT = HEADCOUNT
            self.DATA = DATA
        }

        convenience override init() {
            self.init(HEADCOUNT: "", DATA: "")
        }

        func copys() -> Preset {
            Preset(ID: ID, HEADCOUNT: HEADCOUNT, DATA: DATA)
        }
    }
}
