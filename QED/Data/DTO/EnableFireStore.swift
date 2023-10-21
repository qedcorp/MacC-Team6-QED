//
//  EnableFireStore.swift
//  QED
//
//  Created by changgyo seo on 10/21/23.
//

import Foundation

protocol EnableFirestore: NSObject, Codable {
    var collectionName: String { get }
    var ID: String { get set }
}

extension EnableFirestore {
    func fetchValue(id: String, data: [String: Any]) {
        setValue(id, forKey: "ID")
        Mirror(reflecting: self).children.forEach { child in
            guard let label = child.label,
                  let value = data[label] as? String
            else { return }
            setValue(value, forKey: label)
        }
    }
}
