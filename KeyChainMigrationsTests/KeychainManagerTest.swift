//
//  KeychainManagerTest.swift
//  KM2Tests
//
//  Created by JAVIER CALATRAVA LLAVERIA on 10/6/25.
//
@testable import KeyChainMigrations
import Testing

@Suite("KeychainManagerTest", .serialized)
@MainActor
struct KeychainManagerTest {
    
    @MainActor
    let sut = KeychainManager.shared

    @Test("Load keychain data when nil")
    func loadKeychainDataWhenNil() async throws {
        // Given
        
        
        //await sut.loadKeychainData(for: "")
        // When
        await sut.deleteKeychainData(for: "asd")
        // Then
        #expect(await sut.loadKeychainData(for: "asd") == nil)
    }
    
    @Test("Save and Load keychain")
    func saveAndLoad() async throws {
        // Given
        await sut.deleteKeychainData(for: "asd")
        // When
        let myString = "Hello, Swift!"
        if let data = myString.data(using: .utf8) {
            await sut.saveKeychainData(for: "asd", data: data)
        }
        guard let data = await sut.loadKeychainData(for: "asd") else {
            #expect(Bool(false))
            return
        }

        // Then
        #expect( String(data: data, encoding: .utf8) == "Hello, Swift!")
    }
}

