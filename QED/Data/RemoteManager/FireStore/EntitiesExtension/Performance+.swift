//
//  Performance+.swift
//  QED
//
//  Created by changgyo seo on 10/22/23.
//

import Foundation

extension Performance: FireStoreEntityConvertable {
    var jsonString: String {
        guard let jsonData = try? JSONEncoder().encode(self) else { return "Encoding Fail" }
        return String(data: jsonData, encoding: .utf8) ?? "Encoding Fail"
    }

    convenience init(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8),
              let performance = try? JSONDecoder().decode(Performance.self, from: jsonData) else {
            self.init(id: "", author: User(id: "failure"), playable: Music(id: "failure", title: "failure", artistName: "failure"), headcount: -1)
            return
        }

        self.init(
            id: performance.id,
            author: performance.author,
            playable: performance.playable,
            headcount: performance.headcount,
            title: performance.title,
            formations: performance.formations,
            transitions: performance.transitions
        )
    }

    var fireStoreEntity: FireStoreEntity {
        return FireStoreDTO.PerformanceDTO(
            ID: id,
            OWNERID: "",
            DATA: jsonString
        )
    }
}
