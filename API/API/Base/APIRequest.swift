//
//  APIRequest.swift
//  API
//
//  Created by Cem Ege on 4.09.2023.
//

import Foundation
import class UIKit.UIDevice

public protocol APIRequest {
    var baseUrl: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var header: [String: String] { get }
    var body: Encodable? { get }
    var queryItems: [String: Any?]? { get }
    var urlQueryItems: [URLQueryItem]? { get }
    var dontShowErrorMessage: Bool { get }
}

public extension APIRequest {
    var baseUrl: String {
        return "https://itunes.apple.com/"
    }
    
    var method: HTTPMethod {
        .GET
    }
    
    var header: [String: String] {
        let appVersion = Bundle.main.infoDictionary?[kCFBundleVersionKey as String] as? String ?? ""

        let headerDict = [
            "appVersion": appVersion,
            "Accept-Charset": "utf-8",
            "Content-Type": "application/json",
            "osVersion": UIDevice.current.systemVersion,
        ]

        return headerDict
    }
    
    var body: Encodable? {
        nil
    }
    
    var queryItems: [String: Any?]? {
        nil
    }
    
    var urlQueryItems: [URLQueryItem]? {
        Self.convertToURLQueryItems(dict: queryItems)
    }
    
    var dontShowErrorMessage: Bool {
        false
    }
}

// MARK: - Encodable Helper
extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }

    func toDict() -> [String: Any] {
        guard let data = toJSONData() else { return [:] }
        guard let jsonDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
        return jsonDict
    }
}

// MARK: - URLQueryItem Convert
private extension APIRequest {
    static func convertToURLQueryItems(dict: [String: Any?]?) -> [URLQueryItem]? {
        guard let dict = dict else { return nil }
        
        return dict
            .filter { _, value in value != nil }
            .flatMap { key, value in Self.buildQueryItems(key: key, value: value) }
    }

    static func buildQueryItems(key: String, value: Any?) -> [URLQueryItem] {
        guard let value else {
            return [ URLQueryItem(name: key, value: nil) ]
        }

        switch value {
        case is String:
            return [ URLQueryItem(name: key, value: value as? String) ]
            
        case is Int,
            is Int32,
            is Bool,
            is Double,
            is Float:
            return [ URLQueryItem(name: key, value: String(describing: value)) ]
            
        case let value as [Any]:
            return value
                .filter { false == ($0 is [Any]) }
                .flatMap { Self.buildQueryItems(key: key, value: $0) }
            
        default:
            return []
        }
    }
}
