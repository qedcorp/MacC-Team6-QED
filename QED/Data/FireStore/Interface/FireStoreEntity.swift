//
//  FireStoreEntity.swift
//  QED
//
//  Created by changgyo seo on 10/21/23.
//

import Foundation

protocol FireStoreEntity: NSObject, Codable {
    var collectionName: String { get }
    var ID: String { get set }

    func copys() -> Self
}

extension FireStoreEntity {
    func fetchValue(id: String, data: [String: Any]) -> Self {

        setValue(id, forKey: "ID")
        Mirror(reflecting: self).children.forEach { child in
            guard let label = child.label,
                  let value = data[label] as? String
            else { return }
            setValue(value, forKey: label)
        }
        let returnV = self.copys()
        print(returnV)
        return returnV
    }
}
