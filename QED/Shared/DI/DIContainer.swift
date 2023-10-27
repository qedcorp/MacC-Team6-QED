// swiftlint:disable all
//  DIContainer.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

final class DIContainer {
    
    static var shared: DIContainer = DIContainer()
    private var resolver: Resolver = Resolver()
    private var dependencyGraph: TypeDirectedGraph = TypeDirectedGraph()
    
    private init() {
        dependencyGraph.connect(at: GraphHead.self, with: AuthUIProtocol.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
        dependencyGraph.connect(at: AuthUIProtocol.self, with: AuthRepository.self)
    }
    
    private func settingDependency() {
        
    }
    
    func changeDenpendency<T>(_ value: [(T.Type, DependencyPurpose)]) {
        
    }
}

extension DIContainer {
    
    enum DependencyPurpose {
        case release
        case mock
        case other
    }
    
    struct Resolver {
        
        var DIDictionary = TypeDictionary()
        
        func resolve<T>(_ type: T.Type) -> T {
            return DIDictionary[type.self] as! T
        }
    }
    
    func register<T>(_ type: T.Type, _ completion: @escaping (Resolver) -> T) {
        let result = completion(self.resolver)
        
        resolver.DIDictionary[type.self] = result
    }
}
