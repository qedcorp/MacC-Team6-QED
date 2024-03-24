//// swiftlint:disable all
////  DIContainer.swift
////  QED
////
////  Created by changgyo seo on 10/28/23.
////
//
// import Foundation
//
// import UIKit
//
///// DIContainer
/////
///// ```swift
/////   DIContainer
/////   .shared
/////   .storage
/////   .resolver
/////   [Protocol.self])
///// ```
///// 위와같이 사용하게되면 protocol의 구현체가 나옴
///// 만약 dependencyInjection 함수를 사용해 mock 인스턴스를 주입했다면, mock 인스턴스가 나옴
// final class DIContainer {
//    static var shared: DIContainer = DIContainer()
//    var resolver: KioInjection = KioInjection()
//    
//    private init() {
//        resolver.dependencyGraph.addNode(type: AuthUIProtocol.self)
//        resolver.dependencyGraph.addNode(type: UserStore.self)
//        resolver.dependencyGraph.addNode(type: RemoteManager.self)
//        resolver.dependencyGraph.addNode(type: UserRepository.self)
//        resolver.dependencyGraph.addNode(type: PerformanceRepository.self)
//        resolver.dependencyGraph.addNode(type: MusicRepository.self)
//        resolver.dependencyGraph.addNode(type: KakaoAuthRepository.self)
//        resolver.dependencyGraph.addNode(type: GoogleAuthRepository.self)
//        resolver.dependencyGraph.addNode(type: AppleAuthRepository.self)
//        resolver.dependencyGraph.addNode(type: FormationTransitionUseCase.self)
//        resolver.dependencyGraph.addNode(type: FormationUseCase.self)
//        resolver.dependencyGraph.addNode(type: MemberUseCase.self)
//        resolver.dependencyGraph.addNode(type: MusicUseCase.self)
//        resolver.dependencyGraph.addNode(type: UserUseCase.self)
//        resolver.dependencyGraph.addNode(type: AuthUseCase.self)
//        resolver.dependencyGraph.addNode(type: PerformanceUseCase.self)
//        resolver.dependencyGraph.addNode(type: PresetRepository.self)
//        resolver.dependencyGraph.addNode(type: PresetUseCase.self)
//        
//        resolver.dependencyGraph.connect(a: RemoteManager.self, b: PresetRepository.self)
//        resolver.dependencyGraph.connect(a: RemoteManager.self, b: UserRepository.self)
//        resolver.dependencyGraph.connect(a: RemoteManager.self, b: PerformanceRepository.self)
//        resolver.dependencyGraph.connect(a: AuthUIProtocol.self, b: GoogleAuthRepository.self)
//        resolver.dependencyGraph.connect(a: AuthUIProtocol.self, b: AuthUseCase.self)
//        resolver.dependencyGraph.connect(a: MusicRepository.self, b: MusicUseCase.self)
//        resolver.dependencyGraph.connect(a: UserRepository.self, b: UserUseCase.self)
//        resolver.dependencyGraph.connect(a: UserStore.self, b: UserUseCase.self)
//        resolver.dependencyGraph.connect(a: PresetRepository.self, b: PresetUseCase.self)
//        resolver.dependencyGraph.connect(a: PerformanceRepository.self, b: PerformanceUseCase.self)
//        resolver.dependencyGraph.connect(a: UserStore.self, b: PerformanceUseCase.self)
//        resolver.dependencyGraph.connect(a: KakaoAuthRepository.self, b: AuthUseCase.self)
//        resolver.dependencyGraph.connect(a: GoogleAuthRepository.self, b: AuthUseCase.self)
//        resolver.dependencyGraph.connect(a: AppleAuthRepository.self, b: AuthUseCase.self)
//        
//        resolver.typeToClosure[ObjectIdentifier(AuthUIProtocol.self)] = injectionAuthUIProtocol
//        resolver.typeToClosure[ObjectIdentifier(RemoteManager.self)] = injectionRemoteManager
//        resolver.typeToClosure[ObjectIdentifier(UserRepository.self)] = injectionUserRepository
//        resolver.typeToClosure[ObjectIdentifier(PerformanceRepository.self)] = injectionPerformanceRepository
//        resolver.typeToClosure[ObjectIdentifier(PresetRepository.self)] = injectionPresetRepository
//        resolver.typeToClosure[ObjectIdentifier(MusicRepository.self)] = injectionMusicRepository
//        resolver.typeToClosure[ObjectIdentifier(KakaoAuthRepository.self)] = injectionKakaoAuthRepository
//        resolver.typeToClosure[ObjectIdentifier(GoogleAuthRepository.self)] = injectionGoogleAuthRepository
//        resolver.typeToClosure[ObjectIdentifier(AppleAuthRepository.self)] = injectionAppleAuthRepository
//        resolver.typeToClosure[ObjectIdentifier(FormationTransitionUseCase.self)] = injectionFormationTransitionUseCase
//        resolver.typeToClosure[ObjectIdentifier(FormationUseCase.self)] = injectionFormationUseCase
//        resolver.typeToClosure[ObjectIdentifier(MemberUseCase.self)] = injectionMemberUseCase
//        resolver.typeToClosure[ObjectIdentifier(UserStore.self)] = injectionUserStore
//        resolver.typeToClosure[ObjectIdentifier(MusicUseCase.self)] = injectionMusicUseCase
//        resolver.typeToClosure[ObjectIdentifier(UserUseCase.self)] = injectionUserUseCase
//        resolver.typeToClosure[ObjectIdentifier(AuthUseCase.self)] = injectionAuthUseCase
//        resolver.typeToClosure[ObjectIdentifier(PerformanceUseCase.self)] = injectionPerformanceUseCase
//        resolver.typeToClosure[ObjectIdentifier(PresetUseCase.self)] = injectionPresetUseCase
//       
//        resolver.dependencyInjection()
//    }
//    
//    func injectionAuthUIProtocol(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(AuthUIProtocol.self) { _ ,_  in
//                if let returnValue = self.resolver.providerType  {
//                    return returnValue
//                }
//                return AuthViewController()
//            }
//        }
//        else {
//            resolver.register(AuthUIProtocol.self) { _ ,_ in
//                if let returnValue = self.resolver.providerType  {
//                    return returnValue
//                }
//                return AuthViewController()
//            }
//        }
//    }
//    
//    func injectionRemoteManager(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(RemoteManager.self) { _ ,_ in
//                FireStoreManager()
//            }
//        }
//        else {
//            resolver.register(RemoteManager.self) { _ ,_ in
//                FireStoreManager()
//            }
//        }
//    }
//    
//    func injectionUserRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(UserRepository.self) { resolver ,_ in
//                let remoteManager = resolver[RemoteManager.self]
//                
//                return DefaultUserRepository(remoteManager: remoteManager)
//            }
//        }
//        else {
//            resolver.register(UserRepository.self) { resolver ,_ in
//                let userStore = resolver[UserStore.self]
//                
//                return MockUserRepository(userStore: userStore)
//            }
//        }
//    }
//    
//    func injectionPerformanceRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(PerformanceRepository.self) { resolver ,_ in
//                let remoteManager = resolver[RemoteManager.self]
//                
//                return DefaultPerformanceRepository(remoteManager: remoteManager)
//            }
//        }
//        else {
//            resolver.register(PerformanceRepository.self) { _ ,_ in
//                
//                return MockPerformanceRepository()
//            }
//        }
//    }
//    
//    func injectionMusicRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(MusicRepository.self) { _ ,_ in
//                
//                return DefaultMusicRepository()
//            }
//        }
//        else {
//            resolver.register(MusicRepository.self) { _ ,_ in
//                
//                return MockMusicRepository()
//            }
//        }
//    }
//    
//    func injectionPresetRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(PresetRepository.self) { resolver ,_ in
//                var remoteManager = resolver[RemoteManager.self]
//                
//                return DefaultPresetRepository(remoteManager: remoteManager)
//            }
//        }
//        else {
//            resolver.register(PresetRepository.self) { _ ,_ in
//                
//                return MockPresetRepository()
//            }
//        }
//    }
//    
//    func injectionKakaoAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(KakaoAuthRepository.self) { _ ,_ in
//                
//                return DefaultKakaoAuthRepository()
//            }
//        }
//        else {
//            resolver.register(KakaoAuthRepository.self) { _ ,_ in
//                
//                return DefaultKakaoAuthRepository()
//            }
//        }
//    }
//    
//    func injectionGoogleAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(GoogleAuthRepository.self) { resolver  ,_ in
//                let authUI = resolver[AuthUIProtocol.self]
//                
//                return DefaultGoogleAuthRepository(authUI: authUI)
//            }
//        }
//        else {
//            resolver.register(GoogleAuthRepository.self) { resolver  ,_ in
//                let authUI = resolver[AuthUIProtocol.self]
//                
//                return DefaultGoogleAuthRepository(authUI: authUI)
//            }
//        }
//    }
//    
//    func injectionAppleAuthRepository(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(AppleAuthRepository.self) { _ ,_ in
//                
//                return DefaultAppleAuthRepository()
//            }
//        }
//        else {
//            resolver.register(AppleAuthRepository.self) { _  ,_ in
//                
//                return DefaultAppleAuthRepository()
//            }
//        }
//    }
//    
//    func injectionFormationTransitionUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(FormationTransitionUseCase.self) { _  ,_ in
//                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
//                let performance = mockPerformance1
//                
//                return DefaultFormationTransitionUseCase(performance: performance)
//            }
//        }
//        else {
//            resolver.register(FormationTransitionUseCase.self) { _ ,_ in
//                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
//                let performance = mockPerformance1
//                
//                return DefaultFormationTransitionUseCase(performance: performance)
//            }
//        }
//    }
//    
//    func injectionFormationUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(FormationUseCase.self) { _ ,_ in
//                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
//                let performance = mockPerformance1
//                
//                return DefaultFormationUseCase(performance: performance)
//            }
//        }
//        else {
//            resolver.register(FormationUseCase.self) { _ ,_ in
//                // TODO: 수정 요망 여기서 뭘 받아야할지 모르겠음
//                let performance = mockPerformance1
//                
//                return DefaultFormationUseCase(performance: performance)
//            }
//        }
//    }
//    
//    func injectionMemberUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(MemberUseCase.self) { _ ,_ in
//                
//                return DefaultMemberUseCase()
//            }
//        }
//        else {
//            resolver.register(MemberUseCase.self) { _ ,_ in
//                
//                return DefaultMemberUseCase()
//            }
//        }
//    }
//    
//    func injectionUserStore(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(UserStore.self) { _ ,_ in
//                
//                return DefaultUserStore.shared
//            }
//        }
//        else {
//            resolver.register(UserStore.self) { _ ,_ in
//                
//                return DefaultUserStore.shared
//            }
//        }
//    }
//    
//    func injectionMusicUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(MusicUseCase.self) { resolver ,_ in
//                let musicRepository = resolver[MusicRepository.self]
//                
//                return DefaultMusicUseCase(musicRepository: musicRepository)
//            }
//        }
//        else {
//            resolver.register(MusicUseCase.self) { resolver ,_ in
//                let musicRepository = resolver[MusicRepository.self]
//                
//                return DefaultMusicUseCase(musicRepository: musicRepository)
//            }
//        }
//    }
//    
//    func injectionUserUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(UserUseCase.self) { resolver ,_ in
//                let userRepository = resolver[UserRepository.self]
//                let userStore = resolver[UserStore.self]
//                
//                return DefaultUserUseCase(userRepository: userRepository, userStore: userStore)
//            }
//        }
//        else {
//            resolver.register(UserUseCase.self) { resolver ,_ in
//                let userRepository = resolver[UserRepository.self]
//                let userStore = resolver[UserStore.self]
//                
//                return DefaultUserUseCase(userRepository: userRepository, userStore: userStore)
//            }
//        }
//    }
//    
//    func injectionPresetUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(PresetUseCase.self) { resolver ,_ in
//                let presetRepository = resolver[PresetRepository.self]
//                
//                return DefaultPresetUseCase(presetRepository: presetRepository)
//            }
//        }
//        else {
//            resolver.register(PresetUseCase.self) { resolver ,_ in
//                let presetRepository = resolver[PresetRepository.self]
//                
//                return DefaultPresetUseCase(presetRepository: presetRepository)
//            }
//        }
//    }
//    
//    func injectionPerformanceUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(PerformanceUseCase.self) { resolver ,_ in
//                let performanceRepository = resolver[PerformanceRepository.self]
//                let userStore = resolver[UserStore.self]
//                
//                return DefaultPerformanceUseCase(performanceRepository: performanceRepository, userStore: userStore)
//            }
//        }
//        else {
//            resolver.register(PerformanceUseCase.self) { resolver ,_ in
//                let performanceRepository = resolver[PerformanceRepository.self]
//                let userStore = resolver[UserStore.self]
//                
//                return DefaultPerformanceUseCase(performanceRepository: performanceRepository, userStore: userStore)
//            }
//        }
//    }
//    
//    func injectionAuthUseCase(_ purpose: KioInjection.DependencyPurpose = .release) {
//        if purpose == .release {
//            resolver.register(AuthUseCase.self) { resolver ,_ in
//                let kakaoAuthRepository = resolver[KakaoAuthRepository.self]
//                let googleAuthRepository = resolver[GoogleAuthRepository.self]
//                let appleAuthRepository = resolver[AppleAuthRepository.self]
//                
//                return DefaultAuthUseCase(kakaoAuthRepository: kakaoAuthRepository,
//                                          googleAuthRepository: googleAuthRepository,
//                                          appleAuthRepository: appleAuthRepository)
//            }
//        }
//        else {
//            resolver.register(AuthUseCase.self) { resolver ,_ in
//                let kakaoAuthRepository = resolver[KakaoAuthRepository.self]
//                let googleAuthRepository = resolver[GoogleAuthRepository.self]
//                let appleAuthRepository = resolver[AppleAuthRepository.self]
//                let uiViewController = resolver[AuthUIProtocol.self]
//                
//                return DefaultAuthUseCase(kakaoAuthRepository: kakaoAuthRepository,
//                                          googleAuthRepository: googleAuthRepository,
//                                          appleAuthRepository: appleAuthRepository)
//            }
//        }
//    }
// }
