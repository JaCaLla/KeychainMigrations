//
//  KeyChainMigrationsApp.swift
//  KeyChainMigrations
//
//  Created by JAVIER CALATRAVA LLAVERIA on 12/6/25.
//

import SwiftUI

@main
struct KeyChainMigrationsApp: App {
    var body: some Scene {
        WindowGroup {
            #if !RELEASE
            if NSClassFromString("XCTestCase") != nil {
                // TrialView onAppear interacts with Keychain and this causes random unit test execution
                EmptyView()
            } else {
                TrialView()
            }
            #else
            TrialView()
            #endif
        }
    }
}
