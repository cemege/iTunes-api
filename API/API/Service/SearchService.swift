//
//  SearchService.swift
//  API
//
//  Created by Cem Ege on 4.09.2023.
//

import Combine

public protocol SearchServiceProtocol {
    func softwareSearch(request: APIRequest) -> AnyPublisher<SoftwareSearchResponse, APIError>
}

public final class SearchService: SearchServiceProtocol {
    public init() {}
    
    public func softwareSearch(request: APIRequest) -> AnyPublisher<SoftwareSearchResponse, APIError> {
        return APIClient.shared.call(request: request)
    }
}
