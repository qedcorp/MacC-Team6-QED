//
//  TypeDirectedGraph.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

class TypeDirectedGraph {
    private var nodes: [Node]

    init() {
        self.nodes = [Node(type: ObjectIdentifier(GraphHead.self), childs: [])]
    }

    func next<T>(type: T.Type) -> [ObjectIdentifier] {
        guard let objectIdentifers = nodes
            .first(where: { $0.type == ObjectIdentifier(T.self) })?
            .childs
            .map({ $0.type })
        else { return [] }

        return objectIdentifers
    }

    func connect<T, U>(at parent: T.Type, with value: U.Type) {
        guard let parentNode = nodes
            .first(where: { $0.type == ObjectIdentifier(T.self) })
        else { return }

        let childNode = Node(type: ObjectIdentifier(U.self), childs: [])
        parentNode.childs.append(childNode)
    }
}

extension TypeDirectedGraph {
    class Node {
        var type: ObjectIdentifier
        var childs: [Node]

        init(type: ObjectIdentifier, childs: [Node]) {
            self.type = type
            self.childs = childs
        }
    }
}

protocol GraphHead { }
