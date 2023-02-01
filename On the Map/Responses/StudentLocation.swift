//
//  StudentLocation.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 27/1/2023.
//

import Foundation

struct StudentLocation: Codable {
    
    let createdAt: String?
    let firstName: String?
    let lastName: String?
    let latitude: Double?
    let longitude: Double?
    let mapString: String?
    let mediaURL: String?
    let objectId: String?
    let uniqueKey: String?
    let updatedAt: String?
    let ACL: String?
    
    init(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, uniqueKey: String?, updatedAt: String, ACL: String?){
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
        self.ACL = ACL
        
    }
}
