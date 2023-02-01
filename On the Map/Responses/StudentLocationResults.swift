//
//  StudentLocationResults.swift
//  On the Map
//
//  Created by The Fasugba Crew  on 27/1/2023.
//
//results of finding location of students
import Foundation

struct StudentLocationResults: Codable {
    let results: [StudentLocation]
    
    init(results: [StudentLocation]){
        self.results = results
        
    }
    
}
