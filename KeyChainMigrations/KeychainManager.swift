//
//  KeychainManager.swift
//  KM2
//
//  Created by JAVIER CALATRAVA LLAVERIA on 9/6/25.
//

import Foundation

@globalActor
actor GlobalManager {
    static var shared = GlobalManager()
}

@GlobalManager
final class KeychainManager {
    
    @MainActor
    static let shared = KeychainManager()
    
#if DEBUG
@MainActor
/*private*/ init() {
}
#else
@MainActor
private init() {
}
#endif
    
    func saveKeychainData(for key: String, data: Data) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemDelete(query as CFDictionary)
        SecItemAdd(query as CFDictionary, nil)
    }
    
    func loadKeychainData(for key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        return status == errSecSuccess ? dataTypeRef as? Data : nil
    }
    
    func deleteKeychainData(for key: String) async {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
