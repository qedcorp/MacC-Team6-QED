// swiftlint:disable all
//  TypeDictionary.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

class KioInjection {

    var dependencyGraph: TypeDirectedGraph = TypeDirectedGraph()
    var typeToClosure: [ObjectIdentifier: (DependencyPurpose)->()] = [:]
    var defaultInstancesClosure: ClosureDictionary = ClosureDictionary()
    var providerType: AuthUIProtocol?

    var DIDictionary = TypeDictionary()
    
    func resolve<T>(_ type: T.Type, _ arg: Any ...) -> T {
        return DIDictionary[type.self] as! T
    }
    
    func register<T>(_ type: T.Type, _ completion: @escaping (TypeDictionary, Any ...) -> T) {
        let result = completion(self.DIDictionary)
        
        DIDictionary[type] = result
    }
    
    /// 특정 목적에 맞춰 protocol들의 의존성을 주입하는 함수
    ///
    /// - Parameters:
    ///     - dic: [ObjectIdentifier: DependencyPurpose]
    ///
    /// - DependencyPurpose:
    ///     의존성주입을 하는 목적
    ///     - mock : 목업 의존성 추가:
    ///     - realease : 출시용 의존성 추가
    ///     - other : 현재 미사용
    ///
    ///
    /// ```swift
    ///  dependencyInjection(
    ///     [
    ///         ObjectIdentifier(Procotol.self): .mock
    ///     ]
    ///  )
    /// ```
    /// 위와같이 사용하게되면 protocol이 mock에 따라 의존성이 주입되고 해당 protocol을 의존하고 있던
    /// 기존에 UseCase나 Repository 기타등등이 알아서 의존성 주입이 됨
    func dependencyInjection(_ dic: [ObjectIdentifier: DependencyPurpose] = [:], providerType: AuthUIProtocol? = nil) {
        self.providerType = providerType
        var copydependencyGraph = self.dependencyGraph
        if dic.count != 0 {
            copydependencyGraph = dfs(dic, graph: copydependencyGraph)
        }
        else {
            copydependencyGraph.nodes.forEach {
                $0.indegreeCount = $0.parentCount
            }
        }
        while !copydependencyGraph.nodes.isEmpty {
            copydependencyGraph.nodes.sort { $0.indegreeCount > $1.indegreeCount }
            guard let node = copydependencyGraph.nodes.last else {
                break
            }
            let purpose: DependencyPurpose = dic[node.value] == nil ? .release : .mock
            typeToClosure[node.value]!(purpose)
            
            _ = copydependencyGraph.nodes.popLast()
            
            for child in node.childs {
                child.indegreeCount -= 1
            }
        }
    }
    
    func dfs(_ dic: [ObjectIdentifier: DependencyPurpose], graph: TypeDirectedGraph) -> TypeDirectedGraph {
        var stack: [TypeDirectedGraph.Node] = []
        var visit: [ObjectIdentifier] = []
        var newGraph = graph
        newGraph.nodes = graph.nodes.filter { node in
            dic.contains { (key, value) in
                key == node.value
            }
        }
        for node in newGraph.nodes {
            node.indegreeCount = 0
            stack.append(node)
        }
        while !stack.isEmpty {
            guard var node = stack.popLast() else {
                break
            }
            for child in node.childs {
                child.indegreeCount += 1
                if !visit.contains(where: { $0 == child.value }) {
                    newGraph.nodes.append(child)
                    visit.append(child.value)
                    stack.append(child)
                }
            }
        }
        
        return newGraph
    }
}

extension KioInjection {
    enum DependencyPurpose {
        case release
        case mock
        case other
    }
}

struct TypeDictionary {
    private var dictionary: [(ObjectIdentifier): (Any)] = [:]

    subscript<T>(key: T.Type) -> T {
        get {
            return dictionary[ObjectIdentifier(key)] as! T
        }
        set {
            dictionary[ObjectIdentifier(key)] = newValue
        }
    }
}

struct ClosureDictionary {
    private var dictionary: [(ObjectIdentifier): (Any)] = [:]

    subscript<T>(key: T.Type) -> Any? {
        get {
            return dictionary[ObjectIdentifier(key)]
        }
        set {
            dictionary[ObjectIdentifier(key)] = newValue
        }
    }
}

