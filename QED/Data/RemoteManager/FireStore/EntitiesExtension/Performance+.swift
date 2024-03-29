//
//  Performance+.swift
//  QED
//
//  Created by changgyo seo on 10/22/23.
//

import Foundation

extension Performance: FireStoreEntityConvertable {
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

    convenience init(jsonString: String) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            self.init(
                id: "",
                author: User(
                    id: "failure"
                ),
                music: Music(
                    id: "failure",
                    title: "failure",
                    artistName: "failure"
                ),
                headcount: 5
            )
            return
        }
        do {
            let performance = try JSONDecoder().decode(Performance.self, from: jsonData)
            self.init(
                id: performance.id,
                author: performance.author,
                music: performance.music,
                headcount: performance.headcount,
                title: performance.title,
                memberInfos: performance.memberInfos,
                formations: performance.formations,
                createdAt: performance.createdAt
            )
        } catch let jsonError {
            print("-----------------")
            print(jsonError)
            print("-----------------")
            self.init(id: "", author: User(id: "failure"), music: Music(id: "failure", title: "failure", artistName: "failure"), headcount: 5)
            return
        }
    }

    var fireStoreEntity: FireStoreEntity {
        return FireStoreDTO.PerformanceDTO(
            ID: id,
            OWNERID: "",
            DATA: jsonString
        )
    }
}
