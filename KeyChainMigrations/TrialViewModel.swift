//
//  TrialViewModel.swift
//  FreeAccessApp
//
//  Created by JAVIER CALATRAVA LLAVERIA on 8/6/25.
//

import Foundation
import SwiftUI

@MainActor
class TrialViewModel: ObservableObject {
    @Published var trialInfo: TrialInfoLatestModel?
    @Published var isTrialActive = true
    @Published var timeRemaining: Int = 60
    
    private var keychainManager = appSingletons.keychainManager
    
    let trialSeconds: TimeInterval = 60
    let key = "trialInfo"
    
    func initializeTrial() async {
        if let info = await loadTrialInfo(key: key) {
            trialInfo = info
            updateTrialStatus()
        } else {
            
            let newInfo = TrialInfoLatestModel.defaultValue
            
            if let data = try? JSONEncoder().encode(newInfo) {
                await keychainManager.saveKeychainData(for: key, data: data)
                trialInfo = newInfo
            }
            
            timeRemaining = Int(trialSeconds)
            isTrialActive = true
        }
    }
    
    func updateTrialStatus() {
        guard let info = trialInfo else {
            return
        }
        
        let secondsPassed = Date().timeIntervalSince(info.startDate)
        self.timeRemaining = max(0, Int(trialSeconds - secondsPassed))
        self.isTrialActive = timeRemaining > 0
    }
    
    func resetTrial() async {
        await keychainManager.deleteKeychainData(for: key)
        await initializeTrial()
    }
    
    func loadTrialInfo(key: String) async -> TrialInfoLatestModel? {
        
        guard let data = await keychainManager.loadKeychainData(for: key) else {
            return nil
        }
        
        let versionedTypes: [TrialInfoMigratable.Type] = [
            TrialInfoLatestModel.self,
            TrialInfoV1.self,
            TrialInfo.self
        ]
        if let decoded = try? JSONDecoder().decode(TrialInfoLatestModel.self, from: data) {
            return decoded
        } else {
            for type in versionedTypes {
                if let decoded = try? JSONDecoder().decode(type, from: data) {
                    var current: TrialInfoMigratable = decoded
                    
                    // Migrate until reaching the latest
                    while let next = current.migrate() {
                        await saveMigrated(object: next, key: key)
                        current = next
                    }
                    
                    return current as? TrialInfoLatestModel
                }
            }
        }

        return nil
    }
    
    func saveMigrated<T: Encodable>(object: T, key: String) async {
        guard let newData = try? JSONEncoder().encode(object) else {
            return
        }
        await keychainManager.saveKeychainData(for: key, data: newData)
    }
}
