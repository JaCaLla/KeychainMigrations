//
//  TrialInfo.swift
//  FreeAccessApp
//
//  Created by JAVIER CALATRAVA LLAVERIA on 8/6/25.
//
import Foundation

typealias TrialInfoLatestModel = TrialInfoV2

protocol TrialInfoMigratable:Codable {
    var version: Int { get }
    func migrate() -> TrialInfoMigratable?
}

// Current model (v2)
struct TrialInfoV2: Codable, TrialInfoMigratable {
    
    var version: Int = 2
    let startDate: Date
    let deviceId: String
    
    static let defaultValue = TrialInfoV2(startDate: Date(), deviceId: UUID().uuidString)
    
    init(startDate: Date, deviceId: String) {
        self.startDate = startDate
        self.deviceId = deviceId
    }
    
    func migrate() -> (any TrialInfoMigratable)? {
       nil
    }
}

// Current model (v1)
struct TrialInfoV1: Codable, TrialInfoMigratable {
    var version: Int = 1
    let startDate: Date
    let deviceId: String
    let userId: String
    
    static let defaultValue = TrialInfoV1(startDate: Date(), deviceId: UUID().uuidString, userId: UUID().uuidString)
    
    init(startDate: Date, deviceId: String, userId: String) {
        self.startDate = startDate
        self.deviceId = deviceId
        self.userId = userId
    }
    
    func migrate() -> (any TrialInfoMigratable)? {
        TrialInfoV2(startDate: self.startDate, deviceId: self.deviceId)
    }
}

// Current model (v0)
struct TrialInfo: Codable, TrialInfoMigratable, Equatable {
    var version: Int = 0
    let startDate: Date
    
    static let defaultValue = TrialInfo(startDate: Date())
    
    func migrate() -> (any TrialInfoMigratable)? {
        TrialInfoV1(startDate: self.startDate, deviceId: UUID().uuidString, userId: UUID().uuidString)
    }
}



