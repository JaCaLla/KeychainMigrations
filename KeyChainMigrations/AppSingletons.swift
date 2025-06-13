//
//  AppSingletons.swift
//  KM2
//
//  Created by JAVIER CALATRAVA LLAVERIA on 12/6/25.
//

@MainActor
struct AppSingletons {
    var keychainManager: KeychainManager
    
    init(keychainManager: KeychainManager = KeychainManager.shared) {
        self.keychainManager = keychainManager
    }
}

@MainActor
 var appSingletons = AppSingletons()
