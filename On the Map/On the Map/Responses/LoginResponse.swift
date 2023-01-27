//
//  LoginResponse.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 28/1/2023.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let key: String?
    let registered: Bool
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}
