//
//  TrialViewModel.swift
//  KM2Tests
//
//  Created by JAVIER CALATRAVA LLAVERIA on 10/6/25.
//
@testable import KeyChainMigrations

import Foundation
import Testing

@Suite("TrialViewModelTest", .serialized) // Serialize for avoiding concurrent access to Keychain
struct TrialViewModelTest {

    @Test("loadTrialInfo when nil")
    func loadTrialInfoWhenNil() async throws {
        // Given
        let sut = await TrialViewModel()
        await KeychainManager.shared.deleteKeychainData(for: sut.key)
        // When
        let info = await sut.loadTrialInfo(key: sut.key)
        // Then
        #expect(info == nil)
    }
   
    @Test("Load LatestTrialInfo when previous stored TrialInfo V0")
    func loadTrialInfoWhenV0() async throws {
        // Given
        let sut = await TrialViewModel()
        await KeychainManager.shared.deleteKeychainData(for: sut.key)
        let trialInfo = TrialInfo(startDate: Date.now)
        await sut.saveMigrated(object: trialInfo, key: sut.key)
        // When
        let trialInfoStored = await sut.loadTrialInfo(key: sut.key)
        // Then
        #expect(trialInfoStored?.version == 0)
    }
}
