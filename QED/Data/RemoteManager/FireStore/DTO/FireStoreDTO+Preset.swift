//
//  FireStoreDTO+Preset.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import Foundation

extension FireStoreDTO {
    final class PresetDTO: NSObject, FireStoreEntity {
        let collectionName: String = "PRESET"
        @objc var ID: String
        @objc var HEADCOUNT: String?
        @objc var DATA: String?

        init(ID: String = "", HEADCOUNT: String? = nil, DATA: String? = nil) {
            self.ID = ID
            self.HEADCOUNT = HEADCOUNT
            self.DATA = DATA
        }

        convenience override init() {
            self.init(HEADCOUNT: "", DATA: "")
        }
        var entity: FireStoreEntityConvertable {
            Preset(jsonString: DATA ?? "")
        }

        func copys() -> PresetDTO {
            PresetDTO(ID: ID, HEADCOUNT: HEADCOUNT, DATA: DATA)
        }
    }
}
