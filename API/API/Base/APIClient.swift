//
//  APIClient.swift
//  API
//
//  Created by Cem Ege on 4.09.2023.
//

import Combine

public protocol APIClientProtocol {
    func call<T: Decodable>(request: APIRequest) -> AnyPublisher<T, APIError>
}

public class APIClient: APIClientProtocol {
    
    // MARK: - Properties
    public static let shared = APIClient()
    
    public let apiErrorPublisher = PassthroughSubject<APIError, Never>()
    
    private let session = URLSession.shared
    private var dataTask: URLSessionDataTask?
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: - Request Call
    public func call<T: Decodable>(request: APIRequest) -> AnyPublisher<T, APIError> {
        
        var urlComponents = URLComponents(string: request.baseUrl)
        urlComponents?.path += request.path
        urlComponents?.queryItems = request.urlQueryItems
        
        guard let url = urlComponents?.url else {
            return Fail(error: APIError(type: .unknown, title: "Hata!", description: "Bilinmeyen bir hata oluştu"))
                .eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.allHTTPHeaderFields = request.header
        
        if let httpBody = request.body {
            urlRequest.httpBody = httpBody.toJSONData()
        }
        
        return session
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, response: URLResponse) in
                if let httpResponse = response as? HTTPURLResponse {
                    guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
                        self.publishAPIError(request: request, data: data, httpResponse: httpResponse)
                        throw self.handleError(data: data, httpResponse: httpResponse)
                    }
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                guard let error = error as? APIError else {
                    return APIError(type: .badRequest, title: "Hata!", description: "Bilinmeyen bir hata oluştu")
                }
                
                return error
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - Error Handling
extension APIClient {
    private func handleError(data: Data, httpResponse: HTTPURLResponse) -> APIError {
        let apiErrorType = APIErrorType(rawValue: httpResponse.statusCode) ?? .unknown
        let apiError = APIError(type: apiErrorType, title: "Hata!", description: "Bilinmeyen bir hata oluştu")
        return apiError
    }
    
    private func publishAPIError(request: APIRequest, data: Data, httpResponse: HTTPURLResponse) {
        guard !request.dontShowErrorMessage else { return }
        let apiErrorType = APIErrorType(rawValue: httpResponse.statusCode) ?? .unknown
        let apiError = APIError(type: apiErrorType,
                                title: "Hata!",
                                description: "Bilinmeyen bir hata oluştu")
        apiErrorPublisher.send(apiError)
    }
}
