//
//  Rick&MortyBaseApi.swift
//  RickAndMortyApiProject-ios
//
//  Created by Thomas on 30/04/2021.
//

import Foundation
import Moya

public enum RickAndMortyBaseApi {
    case characters
    case character(id: Int)
    case location
    case episode
}

extension RickAndMortyBaseApi: TargetType {
  public var baseURL: URL {
    return URL(string: "https://rickandmortyapi.com/api")!
  }

  public var path: String {
    switch self {
    case .characters: return "/character"
    case .character(let id): return "/character/\(id)"
    case .location: return "/location"
    case .episode: return "/episode"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .character, .characters, .location, .episode: return .get
        
    }
  }

  public var sampleData: Data {
    return Data()
  }

  public var task: Task {
    switch self {
    case .character, .characters, .episode, .location:
        return .requestPlain
    }
  }

  public var headers: [String: String]? {
    return ["Content-Type": "application/json"]
  }

  public var validationType: ValidationType {
    return .successCodes
  }
}
