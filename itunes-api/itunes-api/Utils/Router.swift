//
//  Router.swift
//  itunes-api
//
//  Created by Cem Ege on 4.09.2023.
//

protocol RouterProtocol {}

class Router: RouterProtocol {
    
    // MARK: - Deinit
    deinit {
        debugPrint("deinit: \(self)")
    }
}
