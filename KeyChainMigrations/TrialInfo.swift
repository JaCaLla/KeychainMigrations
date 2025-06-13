//
//  TrialInfo.swift
//  FreeAccessApp
//
//  Created by JAVIER CALATRAVA LLAVERIA on 8/6/25.
//
import Foundation

typealias TrialInfoLatestModel = TrialInfo

protocol TrialInfoMigratable:Codable {
    var version: Int { get }
    func migrate() -> TrialInfoMigratable?
}

// Current model (v0)
struct TrialInfo: Codable, TrialInfoMigratable, Equatable {
    var version: Int = 0
    let startDate: Date
    
    static let defaultValue = TrialInfo(startDate: Date())
    
    func migrate() -> (any TrialInfoMigratable)? {
        nil
    }
}



