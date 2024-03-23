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
///   [Protocol.self])
/// ```
/// 위와같이 사용하게되면 protocol의 구현체가 나옴
/// 만약 dependencyInjection 함수를 사용해 mock 인스턴스를 주입했다면, mock 인스턴스가 나옴
final class DIContainer {
    static var shared: DIContainer = DIContainer()
    var resolver = FodiDIContainer()
    
    private init() {
        injectionAuthUIProtocol()
        injectionUserStore()
        injectionRemoteManager()
        injectionUserRepository()
        injectionPerformanceRepository()
        injectionMusicRepository()
        injectionKakaoAuthRepository()
        injectionGoogleAuthRepository()
        injectionAppleAuthRepository()
        injectionPresetRepository()
        injectionFormationTransitionUseCase()
        injectionFormationUseCase()
        injectionMemberUseCase()
        injectionMusicUseCase()
        injectionUserUseCase()
        injectionAuthUseCase()
        injectionPerformanceUseCase()
        injectionPresetUseCase()
    }
    
    func injectionAuthUIProtocol(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(AuthUIProtocol.self) { _ in
            return AuthViewController()
        }
    }
    
    func injectionRemoteManager(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(RemoteManager.self) { _ in
            FireStoreManager()
        }
    }
    
    func injectionUserRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(UserRepository.self) { resolver in
            let remoteManager = resolver[RemoteManager.self]
            
            return DefaultUserRepository(remoteManager: remoteManager)
        }
    }
    
    func injectionPerformanceRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(PerformanceRepository.self) { resolver in
            let remoteManager = resolver[RemoteManager.self]
            
            return DefaultPerformanceRepository(remoteManager: remoteManager)
        }
    }
    
    func injectionMusicRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(MusicRepository.self) { _  in
            return DefaultMusicRepository()
        }
    }
    
    func injectionPresetRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(PresetRepository.self) { resolver in
            var remoteManager = resolver[RemoteManager.self]
            
            return DefaultPresetRepository(remoteManager: remoteManager)
        }
    }
    
    func injectionKakaoAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(KakaoAuthRepository.self) { _ in
            
            return DefaultKakaoAuthRepository()
        }
    }
    
    func injectionGoogleAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(GoogleAuthRepository.self) { resolver in
            let authUI = resolver[AuthUIProtocol.self]
            
            return DefaultGoogleAuthRepository(authUI: authUI)
        }
    }
    
    func injectionAppleAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(AppleAuthRepository.self) { _ in
            
            return DefaultAppleAuthRepository()
        }
    }
    
    func injectionFormationTransitionUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(FormationTransitionUseCase.self) { _ in
            let performance = mockPerformance1
            
            return DefaultFormationTransitionUseCase(performance: performance)
        }
    }
    
    func injectionFormationUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(FormationUseCase.self) { _ in
            // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
            let performance = mockPerformance1
            
            return DefaultFormationUseCase(performance: performance)
        }
    }
    
    func injectionMemberUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(MemberUseCase.self) { _ in
            
            return DefaultMemberUseCase()
        }
    }
    
    func injectionUserStore(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(UserStore.self) { _ in
            
            return DefaultUserStore.shared
        }
    }
    
    func injectionMusicUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(MusicUseCase.self) { resolver in
            let musicRepository = resolver[MusicRepository.self]
            
            return DefaultMusicUseCase(musicRepository: musicRepository)
        }
    }
    
    func injectionUserUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(UserUseCase.self) { resolver in
            let userRepository = resolver[UserRepository.self]
            let userStore = resolver[UserStore.self]
            
            return DefaultUserUseCase(userRepository: userRepository, userStore: userStore)
        }
    }
    
    func injectionPresetUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(PresetUseCase.self) { resolver in
            let presetRepository = resolver[PresetRepository.self]
            
            return DefaultPresetUseCase(presetRepository: presetRepository)
        }
    }
    
    func injectionPerformanceUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(PerformanceUseCase.self) { resolver in
            let performanceRepository = resolver[PerformanceRepository.self]
            let userStore = resolver[UserStore.self]
            
            return DefaultPerformanceUseCase(performanceRepository: performanceRepository, userStore: userStore)
        }
    }
    
    func injectionAuthUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
        resolver.register(AuthUseCase.self) { resolver in
            let kakaoAuthRepository = resolver[KakaoAuthRepository.self]
            let googleAuthRepository = resolver[GoogleAuthRepository.self]
            let appleAuthRepository = resolver[AppleAuthRepository.self]
            
            return DefaultAuthUseCase(kakaoAuthRepository: kakaoAuthRepository,
                                      googleAuthRepository: googleAuthRepository,
                                      appleAuthRepository: appleAuthRepository)
        }
    }
}

final class FodiDIContainer {
    // private let dependencies: Dependencies
    var resolver = Resolver()
    
    struct Resolver {
        
        var DIDictionary = TypeDictionary<Any>()
        
        subscript<T>(type: T.Type) -> T {
            return DIDictionary[type.self] as! T
        }
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        return resolver[type]
    }
    
    
    func register<T>(_ type: T.Type, _ completion: @escaping (Resolver) -> T) {
        let result = completion(self.resolver)
        
        resolver.DIDictionary[type.self] = result
    }
    
    struct TypeDictionary<Value> {
        private var storage: [ObjectIdentifier: (Value)] = [:]
        
        subscript<T>(key: T.Type) -> Value? {
            get {
                return storage[ObjectIdentifier(key)]
            }
            set {
                storage[ObjectIdentifier(key)] = newValue
            }
        }
    }
}
