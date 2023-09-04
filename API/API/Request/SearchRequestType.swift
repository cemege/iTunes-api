//
//  SearchRequestType.swift
//  API
//
//  Created by Cem Ege on 4.09.2023.
//

import Foundation

public enum SearchRequestType: APIRequest {

    case SoftwareSearch(term: String)
    
    public var path: String {
        switch self {
        case .SoftwareSearch: return "search"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .SoftwareSearch: return .GET
        }
    }
    
    public var queryItems: [String : Any?]? {
        switch self {
        case .SoftwareSearch(let term):
            return [
                "term": term,
                "entity": "software"
            ]
        }
    }
}
