// swiftlint:disable all
//  DIContainer.swift
//  QED
//
//  Created by changgyo seo on 10/28/23.
//

import Foundation

import UIKit

/// DIContainer
///
/// ```swift
///   DIContainer
///   .shared
///   .storage
///   .resolver
///   .resolve(Protocol.self)
/// ```
/// 위와같이 사용하게되면 protocol의 구현체가 나옴
/// 만약 dependencyInjection 함수를 사용해 mock 인스턴스를 주입했다면, mock 인스턴스가 나옴
final class DIContainer {
    static var shared: DIContainer = DIContainer()
    var storage: KioInjection = KioInjection()
    
    private init() {
        
        storage.dependencyGraph.addNode(type: AuthUIProtocol.self)
        storage.dependencyGraph.addNode(type: UserStore.self)
        storage.dependencyGraph.addNode(type: RemoteManager.self)
        storage.dependencyGraph.addNode(type: UserRepository.self)
        storage.dependencyGraph.addNode(type: PerformanceRepository.self)
        storage.dependencyGraph.addNode(type: PresetRepository.self)
        storage.dependencyGraph.addNode(type: MusicRepository.self)
        storage.dependencyGraph.addNode(type: KakaoAuthRepository.self)
        storage.dependencyGraph.addNode(type: GoogleAuthRepository.self)
        storage.dependencyGraph.addNode(type: AppleAuthRepository.self)
        storage.dependencyGraph.addNode(type: FormationTransitionUseCase.self)
        storage.dependencyGraph.addNode(type: FormationUseCase.self)
        storage.dependencyGraph.addNode(type: MemberUseCase.self)
        storage.dependencyGraph.addNode(type: MusicUseCase.self)
        storage.dependencyGraph.addNode(type: UserUseCase.self)
        storage.dependencyGraph.addNode(type: AuthUseCase.self)
        storage.dependencyGraph.addNode(type: PerformanceUseCase.self)
        
        storage.dependencyGraph.connect(a: RemoteManager.self, b: PresetRepository.self)
        storage.dependencyGraph.connect(a: RemoteManager.self, b: UserRepository.self)
        storage.dependencyGraph.connect(a: RemoteManager.self, b: PerformanceRepository.self)
        storage.dependencyGraph.connect(a: AuthUIProtocol.self, b: GoogleAuthRepository.self)
        storage.dependencyGraph.connect(a: AuthUIProtocol.self, b: AuthUseCase.self)
        storage.dependencyGraph.connect(a: MusicRepository.self, b: MusicUseCase.self)
        storage.dependencyGraph.connect(a: UserRepository.self, b: UserUseCase.self)
        storage.dependencyGraph.connect(a: UserStore.self, b: UserUseCase.self)
        storage.dependencyGraph.connect(a: PresetRepository.self, b: PresetUseCase.self)
        storage.dependencyGraph.connect(a: PerformanceRepository.self, b: PerformanceUseCase.self)
        storage.dependencyGraph.connect(a: UserStore.self, b: PerformanceUseCase.self)
        storage.dependencyGraph.connect(a: KakaoAuthRepository.self, b: AuthUseCase.self)
        storage.dependencyGraph.connect(a: GoogleAuthRepository.self, b: AuthUseCase.self)
        storage.dependencyGraph.connect(a: AppleAuthRepository.self, b: AuthUseCase.self)
        
        storage.typeToClosure[ObjectIdentifier(AuthUIProtocol.self)] = injectionAuthUIProtocol
        storage.typeToClosure[ObjectIdentifier(RemoteManager.self)] = injectionRemoteManager
        storage.typeToClosure[ObjectIdentifier(UserRepository.self)] = injectionUserRepository
        storage.typeToClosure[ObjectIdentifier(PerformanceRepository.self)] = injectionPerformanceRepository
        storage.typeToClosure[ObjectIdentifier(PresetRepository.self)] = injectionPresetRepository
        storage.typeToClosure[ObjectIdentifier(MusicRepository.self)] = injectionMusicRepository
        storage.typeToClosure[ObjectIdentifier(KakaoAuthRepository.self)] = injectionKakaoAuthRepository
        storage.typeToClosure[ObjectIdentifier(GoogleAuthRepository.self)] = injectionGoogleAuthRepository
        storage.typeToClosure[ObjectIdentifier(AppleAuthRepository.self)] = injectionAppleAuthRepository
        storage.typeToClosure[ObjectIdentifier(FormationTransitionUseCase.self)] = injectionFormationTransitionUseCase
        storage.typeToClosure[ObjectIdentifier(FormationUseCase.self)] = injectionFormationUseCase
        storage.typeToClosure[ObjectIdentifier(MemberUseCase.self)] = injectionMemberUseCase
        storage.typeToClosure[ObjectIdentifier(UserStore.self)] = injectionUserStore
        storage.typeToClosure[ObjectIdentifier(MusicUseCase.self)] = injectionMusicUseCase
        storage.typeToClosure[ObjectIdentifier(UserUseCase.self)] = injectionUserUseCase
        storage.typeToClosure[ObjectIdentifier(AuthUseCase.self)] = injectionAuthUseCase
        storage.typeToClosure[ObjectIdentifier(PerformanceUseCase.self)] = injectionPerformanceUseCase
    }
    
    func injectionAuthUIProtocol(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionRemoteManager(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionUserRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionPerformanceRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionMusicRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionPresetRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionKakaoAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionGoogleAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionAppleAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionFormationTransitionUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionFormationUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionMemberUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionUserStore(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionMusicUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionUserUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionPresetUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionPerformanceUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
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
    
    func injectionAuthUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        if purpose == .release {
            storage.register(AuthUseCase.self) { resolver in
                let kakaoAuthRepository = resolver.resolve(KakaoAuthRepository.self)
                let googleAuthRepository = resolver.resolve(GoogleAuthRepository.self)
                let appleAuthRepository = resolver.resolve(AppleAuthRepository.self)
                
                return DefaultAuthUseCase(kakaoAuthRepository: kakaoAuthRepository,
                                          googleAuthRepository: googleAuthRepository,
                                          appleAuthRepository: appleAuthRepository)
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
                                          appleAuthRepository: appleAuthRepository)
            }
        }
    }
}
