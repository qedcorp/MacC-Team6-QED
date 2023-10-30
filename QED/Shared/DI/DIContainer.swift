// swiftlint:disable all
//  DIContainer.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

import UIKit

final class DIContainer {
    
    static var shared: DIContainer = DIContainer()
    var storage: KioInjection = KioInjection()
    private var dependencyGraph: TypeDirectedGraph = TypeDirectedGraph()
    private var typeToClosure: [ObjectIdentifier: (DependencyPurpose)->()] = [:]
    
    private init() {
        
        dependencyGraph.addNode(type: AuthUIProtocol.self)
        dependencyGraph.addNode(type: UserStore.self)
        dependencyGraph.addNode(type: RemoteManager.self)
        dependencyGraph.addNode(type: UserRepository.self)
        dependencyGraph.addNode(type: PerformanceRepository.self)
        dependencyGraph.addNode(type: PresetRepository.self)
        dependencyGraph.addNode(type: MusicRepository.self)
        dependencyGraph.addNode(type: KakaoAuthRepository.self)
        dependencyGraph.addNode(type: GoogleAuthRepository.self)
        dependencyGraph.addNode(type: AppleAuthRepository.self)
        dependencyGraph.addNode(type: FormationTransitionUseCase.self)
        dependencyGraph.addNode(type: FormationUseCase.self)
        dependencyGraph.addNode(type: MemberUseCase.self)
        dependencyGraph.addNode(type: MusicUseCase.self)
        dependencyGraph.addNode(type: UserUseCase.self)
        dependencyGraph.addNode(type: AuthUseCase.self)
        dependencyGraph.addNode(type: PerformanceUseCase.self)
        
        dependencyGraph.connect(a: RemoteManager.self, b: PresetRepository.self)
        dependencyGraph.connect(a: RemoteManager.self, b: UserRepository.self)
        dependencyGraph.connect(a: RemoteManager.self, b: PerformanceRepository.self)
        dependencyGraph.connect(a: AuthUIProtocol.self, b: GoogleAuthRepository.self)
        dependencyGraph.connect(a: AuthUIProtocol.self, b: AuthUseCase.self)
        dependencyGraph.connect(a: MusicRepository.self, b: MusicUseCase.self)
        dependencyGraph.connect(a: UserRepository.self, b: UserUseCase.self)
        dependencyGraph.connect(a: UserStore.self, b: UserUseCase.self)
        dependencyGraph.connect(a: PresetRepository.self, b: PresetUseCase.self)
        dependencyGraph.connect(a: PerformanceRepository.self, b: PerformanceUseCase.self)
        dependencyGraph.connect(a: UserStore.self, b: PerformanceUseCase.self)
        dependencyGraph.connect(a: KakaoAuthRepository.self, b: AuthUseCase.self)
        dependencyGraph.connect(a: GoogleAuthRepository.self, b: AuthUseCase.self)
        dependencyGraph.connect(a: AppleAuthRepository.self, b: AuthUseCase.self)
        
        typeToClosure[ObjectIdentifier(AuthUIProtocol.self)] = injectionAuthUIProtocol
        typeToClosure[ObjectIdentifier(RemoteManager.self)] = injectionRemoteManager
        typeToClosure[ObjectIdentifier(UserRepository.self)] = injectionUserRepository
        typeToClosure[ObjectIdentifier(PerformanceRepository.self)] = injectionPerformanceRepository
        typeToClosure[ObjectIdentifier(PresetRepository.self)] = injectionPresetRepository
        typeToClosure[ObjectIdentifier(MusicRepository.self)] = injectionMusicRepository
        typeToClosure[ObjectIdentifier(KakaoAuthRepository.self)] = injectionKakaoAuthRepository
        typeToClosure[ObjectIdentifier(GoogleAuthRepository.self)] = injectionGoogleAuthRepository
        typeToClosure[ObjectIdentifier(AppleAuthRepository.self)] = injectionAppleAuthRepository
        typeToClosure[ObjectIdentifier(FormationTransitionUseCase.self)] = injectionFormationTransitionUseCase
        typeToClosure[ObjectIdentifier(FormationUseCase.self)] = injectionFormationUseCase
        typeToClosure[ObjectIdentifier(MemberUseCase.self)] = injectionMemberUseCase
        typeToClosure[ObjectIdentifier(UserStore.self)] = injectionUserStore
        typeToClosure[ObjectIdentifier(MusicUseCase.self)] = injectionMusicUseCase
        typeToClosure[ObjectIdentifier(UserUseCase.self)] = injectionUserUseCase
        typeToClosure[ObjectIdentifier(AuthUseCase.self)] = injectionAuthUseCase
        typeToClosure[ObjectIdentifier(PerformanceUseCase.self)] = injectionPerformanceUseCase
        
        dependencyInjection()
    }
    
    func dependencyInjection(_ dic: [ObjectIdentifier: DependencyPurpose] = [:]) {
        var copyDependencyGraph = self.dependencyGraph
        if dic.count != 0 {
            copyDependencyGraph = dfs(dic, graph: copyDependencyGraph)
            print(copyDependencyGraph.nodes.count)
        }
        else {
            copyDependencyGraph.nodes.forEach {
                $0.indegreeCount = $0.parentCount
            }
        }
        while !copyDependencyGraph.nodes.isEmpty {
            copyDependencyGraph.nodes.sort { $0.indegreeCount > $1.indegreeCount }
            let node = copyDependencyGraph.nodes.last!
            let purpose: DependencyPurpose = dic[node.value] == nil ? .release : .mock
            typeToClosure[node.value]!(purpose)
            
            _ = copyDependencyGraph.nodes.popLast()
            
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
            var node = stack.popLast()!
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
    
    func injectionAuthUIProtocol(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(AuthUIProtocol.self) { _ in
                AuthViewController()
            }
        }
        else {
            storage.register(AuthUIProtocol.self) { _ in
                AuthViewController()
            }
        }
    }
    
    func injectionRemoteManager(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(RemoteManager.self) { _ in
                FireStoreManager()
            }
        }
        else {
            storage.register(RemoteManager.self) { _ in
                FireStoreManager()
            }
        }
    }
    
    func injectionUserRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(UserRepository.self) { resolver in
                let remoteManager = resolver.resolve(RemoteManager.self)
                
                return DefaultUserRepository(remoteManager: remoteManager)
            }
        }
        else {
            storage.register(UserRepository.self) { resolver in
                let userStore = resolver.resolve(UserStore.self)
                
                return MockUserRepository(userStore: userStore)
            }
        }
    }
    
    func injectionPerformanceRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(PerformanceRepository.self) { resolver in
                let remoteManager = resolver.resolve(RemoteManager.self)
                
                return DefaultPerformanceRepository(remoteManager: remoteManager)
            }
        }
        else {
            storage.register(PerformanceRepository.self) { _ in
                
                return MockPerformanceRepository()
            }
        }
    }
    
    func injectionMusicRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(MusicRepository.self) { _ in
                
                return DefaultMusicRepository()
            }
        }
        else {
            storage.register(MusicRepository.self) { _ in
                
                return MockMusicRepository()
            }
        }
    }
    
    func injectionPresetRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(PresetRepository.self) { resolver in
                var remoteManager = resolver.resolve(RemoteManager.self)
                
                return DefaultPresetRepository(remoteManager: remoteManager)
            }
        }
        else {
            storage.register(PresetRepository.self) { _ in
                
                return MockPresetRepository()
            }
        }
    }
    
    func injectionKakaoAuthRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(KakaoAuthRepository.self) { _ in
                
                return DefaultKakaoAuthRepository()
            }
        }
        else {
            storage.register(KakaoAuthRepository.self) { _ in
                
                return DefaultKakaoAuthRepository()
            }
        }
    }
    
    func injectionGoogleAuthRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(GoogleAuthRepository.self) { resolver in
                let authUI = resolver.resolve(AuthUIProtocol.self)
                
                return DefaultGoogleAuthRepository(authUI: authUI)
            }
        }
        else {
            storage.register(GoogleAuthRepository.self) { resolver in
                let authUI = resolver.resolve(AuthUIProtocol.self)
                
                return DefaultGoogleAuthRepository(authUI: authUI)
            }
        }
    }
    
    func injectionAppleAuthRepository(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(AppleAuthRepository.self) { _ in
                
                return DefaultAppleAuthRepository()
            }
        }
        else {
            storage.register(AppleAuthRepository.self) { _ in
                
                return DefaultAppleAuthRepository()
            }
        }
    }
    
    func injectionFormationTransitionUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(FormationTransitionUseCase.self) { _ in
                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
                let performance = mockPerformance
                
                return DefaultFormationTransitionUseCase(performance: performance)
            }
        }
        else {
            storage.register(FormationTransitionUseCase.self) { _ in
                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
                let performance = mockPerformance
                
                return DefaultFormationTransitionUseCase(performance: performance)
            }
        }
    }
    
    func injectionFormationUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(FormationUseCase.self) { _ in
                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
                let performance = mockPerformance
                
                return DefaultFormationUseCase(performance: performance)
            }
        }
        else {
            storage.register(FormationUseCase.self) { _ in
                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
                let performance = mockPerformance
                
                return DefaultFormationUseCase(performance: performance)
            }
        }
    }
    
    func injectionMemberUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(MemberUseCase.self) { _ in
                
                return DefaultMemberUseCase()
            }
        }
        else {
            storage.register(MemberUseCase.self) { _ in
                
                return DefaultMemberUseCase()
            }
        }
    }
    
    func injectionUserStore(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(UserStore.self) { _ in
                
                return DefaultUserStore.shared
            }
        }
        else {
            storage.register(UserStore.self) { _ in
                
                return DefaultUserStore.shared
            }
        }
    }
    
    func injectionMusicUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(MusicUseCase.self) { resolver in
                let musicRepository = resolver.resolve(MusicRepository.self)
                
                return DefaultMusicUseCase(musicRepository: musicRepository)
            }
        }
        else {
            storage.register(MusicUseCase.self) { resolver in
                let musicRepository = resolver.resolve(MusicRepository.self)
                
                return DefaultMusicUseCase(musicRepository: musicRepository)
            }
        }
    }
    
    func injectionUserUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(UserUseCase.self) { resolver in
                let userRepository = resolver.resolve(UserRepository.self)
                let userStore = resolver.resolve(UserStore.self)
                
                return DefaultUserUseCase(userRepository: userRepository, userStore: userStore)
            }
        }
        else {
            storage.register(UserUseCase.self) { resolver in
                let userRepository = resolver.resolve(UserRepository.self)
                let userStore = resolver.resolve(UserStore.self)
                
                return DefaultUserUseCase(userRepository: userRepository, userStore: userStore)
            }
        }
    }
    
    func injectionPresetUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(PresetUseCase.self) { resolver in
                let presetRepository = resolver.resolve(PresetRepository.self)
                
                return DefaultPresetUseCase(presetRepository: presetRepository)
            }
        }
        else {
            storage.register(PresetUseCase.self) { resolver in
                let presetRepository = resolver.resolve(PresetRepository.self)
                
                return DefaultPresetUseCase(presetRepository: presetRepository)
            }
        }
    }
    
    func injectionPerformanceUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(PerformanceUseCase.self) { resolver in
                let performanceRepository = resolver.resolve(PerformanceRepository.self)
                let userStore = resolver.resolve(UserStore.self)
                
                return DefaultPerformanceUseCase(performanceRepository: performanceRepository, userStore: userStore)
            }
        }
        else {
            storage.register(PerformanceUseCase.self) { resolver in
                let performanceRepository = resolver.resolve(PerformanceRepository.self)
                let userStore = resolver.resolve(UserStore.self)
                
                return DefaultPerformanceUseCase(performanceRepository: performanceRepository, userStore: userStore)
            }
        }
    }
    
    func injectionAuthUseCase(_ purpose: DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(AuthUseCase.self) { resolver in
                let kakaoAuthRepository = resolver.resolve(KakaoAuthRepository.self)
                let googleAuthRepository = resolver.resolve(GoogleAuthRepository.self)
                let appleAuthRepository = resolver.resolve(AppleAuthRepository.self)
                let uiViewController = resolver.resolve(AuthUIProtocol.self)
                
                return DefaultAuthUseCase(kakaoAuthRepository: kakaoAuthRepository,
                                          googleAuthRepository: googleAuthRepository,
                                          appleAuthRepository: appleAuthRepository,
                                          uiViewController: uiViewController)
            }
        }
        else {
            storage.register(AuthUseCase.self) { resolver in
                let kakaoAuthRepository = resolver.resolve(KakaoAuthRepository.self)
                let googleAuthRepository = resolver.resolve(GoogleAuthRepository.self)
                let appleAuthRepository = resolver.resolve(AppleAuthRepository.self)
                let uiViewController = resolver.resolve(AuthUIProtocol.self)
                
                return DefaultAuthUseCase(kakaoAuthRepository: kakaoAuthRepository,
                                          googleAuthRepository: googleAuthRepository,
                                          appleAuthRepository: appleAuthRepository,
                                          uiViewController: uiViewController)
            }
        }
    }
}

extension DIContainer {
    
    enum DependencyPurpose {
        case release
        case mock
        case other
    }
}
