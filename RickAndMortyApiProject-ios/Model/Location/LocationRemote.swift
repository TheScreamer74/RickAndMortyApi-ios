//
//  LocationRemote.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 30/04/2021.
//

import Foundation
struct LocationRemote: Decodable {
    let name: String
    let url: String //url
    
    enum CodingKeys: String, CodingKey{
        case name
        case url
    }
}

