//
//  CodableResponse.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 30/04/2021.
//

import Foundation

struct RickAndMortyResponse<T: Decodable>: Decodable {
    let results: [T]
}

