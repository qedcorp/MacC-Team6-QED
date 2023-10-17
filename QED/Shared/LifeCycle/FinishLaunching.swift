//
//  FinishLaunching.swift
//  QED
//
//  Created by changgyo seo on 10/17/23.
//

import Foundation

import FirebaseCore


struct FinishLaunching {
    private init() {
        initFirebaseApp()
    }
    static let shared: FinishLaunching = FinishLaunching()
    
    func initFirebaseApp() {
        FirebaseApp.configure()
    }
}
 
