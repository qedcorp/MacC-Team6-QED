// swiftlint:disable all
//  TypeDirectedGraph.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

struct TypeDirectedGraph {
    var nodes: [Node] = []
    var count: Int { nodes.count }

    mutating func addNode<T>(type: T.Type) {
        let newNode = Node(id: nodes.count, value: ObjectIdentifier(type.self))

        nodes.append(newNode)
    }

    func connect<T, U>(a: T.Type, b: U.Type) {
        guard var parentNode = nodes
            .first(where: { $0.value == ObjectIdentifier(T.self) }),
              var childNode = nodes
            .first(where: { $0.value == ObjectIdentifier(U.self)})
        else { return }

        parentNode.childs.append(childNode)
        childNode.parentCount += 1
    }
}

extension TypeDirectedGraph {
    class Node {
        var id: Int
        var value: ObjectIdentifier
        var indegreeCount: Int
        var parentCount: Int {
            didSet {
                indegreeCount = parentCount
            }
        }
        var childs: [Node]

        init(id: Int, value: ObjectIdentifier) {
            self.id = id
            self.value = value
            self.parentCount = 0
            self.indegreeCount = 0
            self.childs = []
        }
    }
}
