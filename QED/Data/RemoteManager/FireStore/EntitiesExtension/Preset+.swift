//
//  Preset+.swift
//  QED
//
//  Created by changgyo seo on 10/23/23.
//

import Foundation

extension Preset: FireStoreEntityConvertable {
    var fireStoreID: String {
        get {
            self.id
        }
        set {
            self.id = newValue
        }
    }

    var jsonString: String {
        guard let jsonData = try? JSONEncoder().encode(self) else { return "Encoding Fail" }
        return String(data: jsonData, encoding: .utf8) ?? "Encoding Fail"
    }

    init(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8),
              let preset = try? JSONDecoder().decode(Preset.self, from: jsonData) else {
            self.init(id: "", headcount: 0, relativePositions: [])
            return
        }

        self.init(
            id: preset.id,
            headcount: preset.headcount,
            relativePositions: preset.relativePositions
        )
    }

    var fireStoreEntity: FireStoreEntity {
        FireStoreDTO.PresetDTO(
            ID: "",
            HEADCOUNT: "\(headcount)",
            DATA: jsonString
        )
    }
}
