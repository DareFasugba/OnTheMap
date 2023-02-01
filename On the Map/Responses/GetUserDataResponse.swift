//
//  GetUserDataResponse.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 26/1/2023.
//

import Foundation
struct GetUserDataResponse: Codable {
    let firstName : String
    let lastName: String
    enum CodingKeys: String, CodingKey {
        case firstName  = "first_name"
        case lastName = "last_name"
    }
}
